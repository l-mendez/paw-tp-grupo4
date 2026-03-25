package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Metric;
import ar.edu.itba.paw.models.MetricCategory;
import ar.edu.itba.paw.services.MetricDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;
import java.util.UUID;

@Repository
public class MetricJdbcDao implements MetricDao {

    private final JdbcTemplate jdbcTemplate;

    private static final RowMapper<MetricCategory> CATEGORY_MAPPER = (rs, rowNum) ->
            new MetricCategory(
                    UUID.fromString(rs.getString("id")),
                    rs.getString("name"),
                    rs.getString("label"),
                    rs.getInt("sort_order")
            );

    private static final RowMapper<Metric> METRIC_MAPPER = (rs, rowNum) ->
            new Metric(
                    UUID.fromString(rs.getString("id")),
                    UUID.fromString(rs.getString("category_id")),
                    rs.getString("name"),
                    rs.getString("label"),
                    rs.getString("unit"),
                    rs.getString("value_type")
            );

    @Autowired
    public MetricJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
    }

    @Override
    public List<MetricCategory> findAllCategories() {
        return jdbcTemplate.query(
                "SELECT id, name, label, sort_order FROM metric_categories ORDER BY sort_order",
                CATEGORY_MAPPER
        );
    }

    @Override
    public List<Metric> findAll() {
        return jdbcTemplate.query(
                "SELECT id, category_id, name, label, unit, value_type FROM metrics ORDER BY name",
                METRIC_MAPPER
        );
    }

    @Override
    public List<Metric> findByCategory(final UUID categoryId) {
        return jdbcTemplate.query(
                "SELECT id, category_id, name, label, unit, value_type FROM metrics WHERE category_id = CAST(? AS UUID) ORDER BY label",
                METRIC_MAPPER, categoryId.toString()
        );
    }
}
