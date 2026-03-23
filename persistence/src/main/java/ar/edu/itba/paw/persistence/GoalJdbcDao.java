package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Goal;
import ar.edu.itba.paw.models.GoalCategory;
import ar.edu.itba.paw.services.GoalDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class GoalJdbcDao implements GoalDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<GoalCategory> CATEGORY_MAPPER = (rs, rowNum) ->
            new GoalCategory(
                    UUID.fromString(rs.getString("id")),
                    rs.getString("name"),
                    rs.getString("label"),
                    rs.getString("icon"),
                    rs.getInt("sort_order")
            );

    private static final RowMapper<Goal> GOAL_MAPPER = (rs, rowNum) ->
            new Goal(
                    UUID.fromString(rs.getString("id")),
                    UUID.fromString(rs.getString("category_id")),
                    rs.getString("name"),
                    rs.getString("label"),
                    rs.getString("description")
            );

    @Autowired
    public GoalJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
    }

    @Override
    public List<GoalCategory> findAllCategories() {
        return jdbcTemplate.query(
                "SELECT id, name, label, icon, sort_order FROM goal_categories ORDER BY sort_order",
                CATEGORY_MAPPER
        );
    }

    @Override
    public List<Goal> findAll() {
        return jdbcTemplate.query(
                "SELECT id, category_id, name, label, description FROM goals ORDER BY name",
                GOAL_MAPPER
        );
    }

    @Override
    public List<Goal> findByCategory(final UUID categoryId) {
        return jdbcTemplate.query(
                "SELECT id, category_id, name, label, description FROM goals WHERE category_id = CAST(? AS UUID) ORDER BY label",
                GOAL_MAPPER, categoryId.toString()
        );
    }

    @Override
    public Optional<Goal> findById(final UUID id) {
        return jdbcTemplate.query(
                "SELECT id, category_id, name, label, description FROM goals WHERE id = CAST(? AS UUID)",
                GOAL_MAPPER, id.toString()
        ).stream().findFirst();
    }
}
