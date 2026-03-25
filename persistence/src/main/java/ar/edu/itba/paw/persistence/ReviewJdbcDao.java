package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.services.ReviewDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.*;

@Repository
public class ReviewJdbcDao implements ReviewDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<Review> REVIEW_MAPPER = (rs, rowNum) ->
            new Review(
                    UUID.fromString(rs.getString("id")),
                    UUID.fromString(rs.getString("protocol_id")),
                    UUID.fromString(rs.getString("user_id")),
                    rs.getString("user_display_name"),
                    rs.getInt("rating"),
                    rs.getString("title"),
                    rs.getString("body"),
                    rs.getTimestamp("created_at").toLocalDateTime()
            );

    @Autowired
    public ReviewJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
        this.jdbcInsert = new SimpleJdbcInsert(jdbcTemplate)
                .withTableName("protocol_reviews")
                .usingColumns("id", "protocol_id", "user_id", "rating", "body");
    }

    @Override
    public List<Review> findByProtocol(final UUID protocolId) {
        return jdbcTemplate.query(
                "SELECT r.id, r.protocol_id, r.user_id, u.display_name AS user_display_name, " +
                "r.rating, r.title, r.body, r.created_at " +
                "FROM protocol_reviews r " +
                "INNER JOIN users u ON r.user_id = u.id " +
                "WHERE r.protocol_id = CAST(? AS UUID) " +
                "ORDER BY r.created_at DESC",
                REVIEW_MAPPER, protocolId.toString()
        );
    }

    @Override
    public Optional<Review> findByProtocolAndUser(final UUID protocolId, final UUID userId) {
        return jdbcTemplate.query(
                "SELECT r.id, r.protocol_id, r.user_id, u.display_name AS user_display_name, " +
                "r.rating, r.title, r.body, r.created_at " +
                "FROM protocol_reviews r " +
                "INNER JOIN users u ON r.user_id = u.id " +
                "WHERE r.protocol_id = CAST(? AS UUID) AND r.user_id = CAST(? AS UUID)",
                REVIEW_MAPPER, protocolId.toString(), userId.toString()
        ).stream().findFirst();
    }

    @Override
    public Review create(final UUID protocolId, final UUID userId, final int rating, final String body) {
        final UUID id = UUID.randomUUID();
        final Map<String, Object> args = new HashMap<>();
        args.put("id", id);
        args.put("protocol_id", protocolId);
        args.put("user_id", userId);
        args.put("rating", rating);
        args.put("body", body);

        jdbcInsert.execute(args);
        return findByProtocolAndUser(protocolId, userId).orElseThrow();
    }

    @Override
    public void update(final UUID reviewId, final int rating, final String body) {
        jdbcTemplate.update(
                "UPDATE protocol_reviews SET rating = ?, body = ?, updated_at = CURRENT_TIMESTAMP WHERE id = CAST(? AS UUID)",
                rating, body, reviewId.toString()
        );
    }

    @Override
    public void delete(final UUID reviewId) {
        jdbcTemplate.update(
                "DELETE FROM protocol_reviews WHERE id = CAST(? AS UUID)",
                reviewId.toString()
        );
    }
}
