package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.PaginatedResult;
import ar.edu.itba.paw.models.Protocol;
import ar.edu.itba.paw.models.ProtocolFilter;
import ar.edu.itba.paw.services.ProtocolDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@Repository
public class ProtocolJdbcDao implements ProtocolDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<Protocol> PROTOCOL_ROW_MAPPER = (rs, rowNum) -> {
        final java.sql.Array tagsArray = rs.getArray("tags");
        final List<String> tags = tagsArray != null
                ? Arrays.asList((String[]) tagsArray.getArray())
                : Collections.emptyList();

        final String communityIdStr = rs.getString("community_id");
        final String forkedFromStr = rs.getString("forked_from");

        return new Protocol.Builder()
                .id(UUID.fromString(rs.getString("id")))
                .creatorId(UUID.fromString(rs.getString("creator_id")))
                .goalId(UUID.fromString(rs.getString("goal_id")))
                .communityId(communityIdStr != null ? UUID.fromString(communityIdStr) : null)
                .title(rs.getString("title"))
                .description(rs.getString("description"))
                .durationDays(rs.getObject("duration_days") != null ? rs.getInt("duration_days") : null)
                .isTemplate(rs.getBoolean("is_template"))
                .status(rs.getString("status"))
                .visibility(rs.getString("visibility"))
                .minParticipants(rs.getObject("min_participants") != null ? rs.getInt("min_participants") : null)
                .maxParticipants(rs.getObject("max_participants") != null ? rs.getInt("max_participants") : null)
                .tags(tags)
                .forkCount(rs.getInt("fork_count"))
                .forkedFrom(forkedFromStr != null ? UUID.fromString(forkedFromStr) : null)
                .createdAt(rs.getTimestamp("created_at").toLocalDateTime())
                .updatedAt(rs.getTimestamp("updated_at").toLocalDateTime())
                .creatorUsername(rs.getString("creator_username"))
                .creatorDisplayName(rs.getString("creator_display_name"))
                .goalLabel(rs.getString("goal_label"))
                .goalCategoryName(rs.getString("goal_category_name"))
                .goalCategoryIcon(rs.getString("goal_category_icon"))
                .avgRating(rs.getDouble("avg_rating"))
                .reviewCount(rs.getInt("review_count"))
                .enrollmentCount(rs.getInt("enrollment_count"))
                .favoriteCount(rs.getInt("favorite_count"))
                .build();
    };

    @Autowired
    public ProtocolJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
    }

    @Override
    public PaginatedResult<Protocol> search(final ProtocolFilter filter) {
        final StringBuilder sql = new StringBuilder();
        final List<Object> params = new ArrayList<>();

        // SELECT
        sql.append("SELECT p.id, p.creator_id, p.goal_id, p.community_id, p.title, p.description, ");
        sql.append("p.duration_days, p.is_template, p.status, p.visibility, ");
        sql.append("p.min_participants, p.max_participants, p.tags, p.fork_count, p.forked_from, ");
        sql.append("p.created_at, p.updated_at, ");
        sql.append("u.username AS creator_username, u.display_name AS creator_display_name, ");
        sql.append("g.label AS goal_label, gc.label AS goal_category_name, gc.icon AS goal_category_icon, ");
        sql.append("COALESCE(r.avg_rating, 0) AS avg_rating, COALESCE(r.review_count, 0) AS review_count, ");
        sql.append("COALESCE(e.enrollment_count, 0) AS enrollment_count, ");
        sql.append("COALESCE(f.favorite_count, 0) AS favorite_count, ");
        sql.append("COUNT(*) OVER() AS total_count ");

        // FROM + JOINs
        sql.append("FROM protocols p ");
        sql.append("INNER JOIN users u ON p.creator_id = u.id ");
        sql.append("INNER JOIN goals g ON p.goal_id = g.id ");
        sql.append("INNER JOIN goal_categories gc ON g.category_id = gc.id ");

        // Aggregation subqueries
        sql.append("LEFT JOIN (SELECT protocol_id, AVG(rating)::NUMERIC(3,2) AS avg_rating, COUNT(*) AS review_count ");
        sql.append("FROM protocol_reviews GROUP BY protocol_id) r ON r.protocol_id = p.id ");

        sql.append("LEFT JOIN (SELECT protocol_id, COUNT(*) AS enrollment_count ");
        sql.append("FROM protocol_enrollments GROUP BY protocol_id) e ON e.protocol_id = p.id ");

        sql.append("LEFT JOIN (SELECT protocol_id, COUNT(*) AS favorite_count ");
        sql.append("FROM protocol_favorites GROUP BY protocol_id) f ON f.protocol_id = p.id ");

        // Conditional JOINs
        final boolean hasMetricFilter = filter.getMetricIds() != null && !filter.getMetricIds().isEmpty();
        final boolean hasInterventionFilter = filter.getInterventionCategoryIds() != null && !filter.getInterventionCategoryIds().isEmpty();

        if (hasMetricFilter) {
            sql.append("INNER JOIN protocol_metrics pm ON pm.protocol_id = p.id ");
        }
        if (hasInterventionFilter) {
            sql.append("INNER JOIN protocol_interventions pi2 ON pi2.protocol_id = p.id ");
            sql.append("INNER JOIN interventions inv ON pi2.intervention_id = inv.id ");
        }

        // WHERE (always applied)
        sql.append("WHERE p.deleted_at IS NULL AND p.visibility = 'public' AND p.is_template = FALSE AND p.status != 'draft' ");

        // Dynamic WHERE clauses
        if (filter.getQuery() != null && !filter.getQuery().isBlank()) {
            sql.append("AND p.search_vector @@ plainto_tsquery('spanish', ?) ");
            params.add(filter.getQuery().trim());
        }

        if (filter.getStatus() != null && !filter.getStatus().isBlank()) {
            sql.append("AND p.status = ? ");
            params.add(filter.getStatus());
        }

        if (filter.getGoalCategoryId() != null) {
            sql.append("AND gc.id = ?::UUID ");
            params.add(filter.getGoalCategoryId().toString());
        }

        if (filter.getGoalId() != null) {
            sql.append("AND p.goal_id = ?::UUID ");
            params.add(filter.getGoalId().toString());
        }

        if (filter.getMinDuration() != null) {
            sql.append("AND p.duration_days >= ? ");
            params.add(filter.getMinDuration());
        }

        if (filter.getMaxDuration() != null) {
            sql.append("AND p.duration_days <= ? ");
            params.add(filter.getMaxDuration());
        }

        if (filter.getTags() != null && !filter.getTags().isEmpty()) {
            sql.append("AND p.tags && ?::TEXT[] ");
            final String pgArray = "{" + String.join(",",
                    filter.getTags().stream()
                            .map(t -> "\"" + t.replace("\\", "\\\\").replace("\"", "\\\"") + "\"")
                            .toList()) + "}";
            params.add(pgArray);
        }

        if (hasMetricFilter) {
            sql.append("AND pm.metric_id IN (");
            appendPlaceholders(sql, filter.getMetricIds().size(), "::UUID");
            sql.append(") ");
            filter.getMetricIds().forEach(id -> params.add(id.toString()));
        }

        if (hasInterventionFilter) {
            sql.append("AND inv.category_id IN (");
            appendPlaceholders(sql, filter.getInterventionCategoryIds().size(), "::UUID");
            sql.append(") ");
            filter.getInterventionCategoryIds().forEach(id -> params.add(id.toString()));
        }

        if (filter.getMinRating() != null) {
            sql.append("AND COALESCE(r.avg_rating, 0) >= ? ");
            params.add(filter.getMinRating());
        }

        // GROUP BY when conditional JOINs may cause row multiplication
        if (hasMetricFilter || hasInterventionFilter) {
            sql.append("GROUP BY p.id, p.creator_id, p.goal_id, p.community_id, p.title, p.description, ");
            sql.append("p.duration_days, p.is_template, p.status, p.visibility, ");
            sql.append("p.min_participants, p.max_participants, p.tags, p.fork_count, p.forked_from, ");
            sql.append("p.created_at, p.updated_at, ");
            sql.append("u.username, u.display_name, g.label, gc.name, gc.icon, ");
            sql.append("r.avg_rating, r.review_count, e.enrollment_count, f.favorite_count ");
        }

        // ORDER BY
        switch (filter.getSortBy()) {
            case POPULARITY:
                sql.append("ORDER BY (COALESCE(e.enrollment_count, 0) + COALESCE(f.favorite_count, 0)) DESC, p.created_at DESC ");
                break;
            case RATING:
                sql.append("ORDER BY COALESCE(r.avg_rating, 0) DESC, COALESCE(r.review_count, 0) DESC, p.created_at DESC ");
                break;
            case DURATION:
                sql.append("ORDER BY p.duration_days ");
                sql.append(filter.getSortOrder() == ProtocolFilter.SortOrder.ASC ? "ASC" : "DESC");
                sql.append(" NULLS LAST, p.created_at DESC ");
                break;
            case NEWEST:
            default:
                sql.append("ORDER BY p.created_at DESC ");
                break;
        }

        // LIMIT / OFFSET
        sql.append("LIMIT ? OFFSET ? ");
        params.add(filter.getPageSize());
        params.add(filter.getPage() * filter.getPageSize());

        // Execute with ResultSetExtractor to capture total_count
        return jdbcTemplate.query(sql.toString(), new SearchResultExtractor(filter.getPage(), filter.getPageSize()), params.toArray());
    }

    @Override
    public Optional<Protocol> findById(final UUID id) {
        final String sql = "SELECT p.id, p.creator_id, p.goal_id, p.community_id, p.title, p.description, " +
                "p.duration_days, p.is_template, p.status, p.visibility, " +
                "p.min_participants, p.max_participants, p.tags, p.fork_count, p.forked_from, " +
                "p.created_at, p.updated_at, " +
                "u.username AS creator_username, u.display_name AS creator_display_name, " +
                "g.label AS goal_label, gc.label AS goal_category_name, gc.icon AS goal_category_icon, " +
                "COALESCE(r.avg_rating, 0) AS avg_rating, COALESCE(r.review_count, 0) AS review_count, " +
                "COALESCE(e.enrollment_count, 0) AS enrollment_count, " +
                "COALESCE(f.favorite_count, 0) AS favorite_count " +
                "FROM protocols p " +
                "INNER JOIN users u ON p.creator_id = u.id " +
                "INNER JOIN goals g ON p.goal_id = g.id " +
                "INNER JOIN goal_categories gc ON g.category_id = gc.id " +
                "LEFT JOIN (SELECT protocol_id, AVG(rating)::NUMERIC(3,2) AS avg_rating, COUNT(*) AS review_count " +
                "FROM protocol_reviews GROUP BY protocol_id) r ON r.protocol_id = p.id " +
                "LEFT JOIN (SELECT protocol_id, COUNT(*) AS enrollment_count " +
                "FROM protocol_enrollments GROUP BY protocol_id) e ON e.protocol_id = p.id " +
                "LEFT JOIN (SELECT protocol_id, COUNT(*) AS favorite_count " +
                "FROM protocol_favorites GROUP BY protocol_id) f ON f.protocol_id = p.id " +
                "WHERE p.id = ?::UUID AND p.deleted_at IS NULL";

        return jdbcTemplate.query(sql, PROTOCOL_ROW_MAPPER, id.toString())
                .stream().findFirst();
    }

    @Override
    public List<String> findAllTags() {
        return jdbcTemplate.queryForList(
                "SELECT tag FROM (" +
                "SELECT unnest(tags) AS tag FROM protocols WHERE deleted_at IS NULL AND visibility = 'public'" +
                ") t GROUP BY tag ORDER BY COUNT(*) DESC, tag",
                String.class
        );
    }

    private void appendPlaceholders(final StringBuilder sql, final int count, final String cast) {
        for (int i = 0; i < count; i++) {
            if (i > 0) sql.append(", ");
            sql.append("?").append(cast);
        }
    }

    private static class SearchResultExtractor implements ResultSetExtractor<PaginatedResult<Protocol>> {
        private final int page;
        private final int pageSize;

        SearchResultExtractor(final int page, final int pageSize) {
            this.page = page;
            this.pageSize = pageSize;
        }

        @Override
        public PaginatedResult<Protocol> extractData(final ResultSet rs) throws SQLException, DataAccessException {
            final List<Protocol> protocols = new ArrayList<>();
            long totalCount = 0;
            int rowNum = 0;

            while (rs.next()) {
                if (rowNum == 0) {
                    totalCount = rs.getLong("total_count");
                }
                protocols.add(PROTOCOL_ROW_MAPPER.mapRow(rs, rowNum++));
            }

            return new PaginatedResult<>(protocols, page, pageSize, totalCount);
        }
    }
}
