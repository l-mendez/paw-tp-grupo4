package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Intervention;
import ar.edu.itba.paw.models.InterventionCategory;
import ar.edu.itba.paw.models.ProtocolIntervention;
import ar.edu.itba.paw.services.InterventionDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.math.BigDecimal;
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

    private static final RowMapper<ProtocolIntervention> PROTOCOL_INTERVENTION_MAPPER = (rs, rowNum) -> {
        final BigDecimal dosage = rs.getBigDecimal("dosage");
        return new ProtocolIntervention(
                UUID.fromString(rs.getString("id")),
                UUID.fromString(rs.getString("protocol_id")),
                UUID.fromString(rs.getString("intervention_id")),
                rs.getString("intervention_name"),
                rs.getString("intervention_label"),
                dosage,
                rs.getString("dosage_unit"),
                rs.getString("frequency"),
                rs.getString("timing"),
                rs.getString("instructions"),
                rs.getInt("sort_order"),
                rs.getBoolean("is_active")
        );
    };

    @Override
    public List<ProtocolIntervention> findByProtocol(final UUID protocolId) {
        return jdbcTemplate.query(
                "SELECT pi.id, pi.protocol_id, pi.intervention_id, " +
                "i.name AS intervention_name, i.label AS intervention_label, " +
                "pi.dosage, pi.dosage_unit, pi.frequency, pi.timing, pi.instructions, " +
                "pi.sort_order, pi.is_active " +
                "FROM protocol_interventions pi " +
                "INNER JOIN interventions i ON pi.intervention_id = i.id " +
                "WHERE pi.protocol_id = CAST(? AS UUID) AND pi.is_active = TRUE " +
                "ORDER BY pi.sort_order, i.label",
                PROTOCOL_INTERVENTION_MAPPER, protocolId.toString()
        );
    }
}
