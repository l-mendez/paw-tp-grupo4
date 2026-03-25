package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Intervention;
import ar.edu.itba.paw.models.InterventionCategory;
import ar.edu.itba.paw.services.InterventionDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;
import java.util.UUID;

@Repository
public class InterventionJdbcDao implements InterventionDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<InterventionCategory> CATEGORY_MAPPER = (rs, rowNum) ->
            new InterventionCategory(
                    UUID.fromString(rs.getString("id")),
                    rs.getString("name"),
                    rs.getString("label"),
                    rs.getString("icon"),
                    rs.getInt("sort_order")
            );

    private static final RowMapper<Intervention> INTERVENTION_MAPPER = (rs, rowNum) ->
            new Intervention(
                    UUID.fromString(rs.getString("id")),
                    UUID.fromString(rs.getString("category_id")),
                    rs.getString("name"),
                    rs.getString("label"),
                    rs.getString("description")
            );

    @Autowired
    public InterventionJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
    }

    @Override
    public List<InterventionCategory> findAllCategories() {
        return jdbcTemplate.query(
                "SELECT id, name, label, icon, sort_order FROM intervention_categories ORDER BY sort_order",
                CATEGORY_MAPPER
        );
    }

    @Override
    public List<Intervention> findAll() {
        return jdbcTemplate.query(
                "SELECT id, category_id, name, label, description FROM interventions ORDER BY name",
                INTERVENTION_MAPPER
        );
    }

    @Override
    public List<Intervention> findByCategory(final UUID categoryId) {
        return jdbcTemplate.query(
                "SELECT id, category_id, name, label, description FROM interventions WHERE category_id = CAST(? AS UUID) ORDER BY label",
                INTERVENTION_MAPPER, categoryId.toString()
        );
    }
}
