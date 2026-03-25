package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.services.FavoriteDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.UUID;

@Repository
public class FavoriteJdbcDao implements FavoriteDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public FavoriteJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
    }

    @Override
    public boolean exists(final UUID protocolId, final UUID userId) {
        final Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM protocol_favorites WHERE protocol_id = CAST(? AS UUID) AND user_id = CAST(? AS UUID)",
                Integer.class, protocolId.toString(), userId.toString()
        );
        return count != null && count > 0;
    }

    @Override
    public void create(final UUID protocolId, final UUID userId) {
        jdbcTemplate.update(
                "INSERT INTO protocol_favorites (id, protocol_id, user_id) VALUES (CAST(? AS UUID), CAST(? AS UUID), CAST(? AS UUID))",
                UUID.randomUUID().toString(), protocolId.toString(), userId.toString()
        );
    }

    @Override
    public void delete(final UUID protocolId, final UUID userId) {
        jdbcTemplate.update(
                "DELETE FROM protocol_favorites WHERE protocol_id = CAST(? AS UUID) AND user_id = CAST(? AS UUID)",
                protocolId.toString(), userId.toString()
        );
    }
}
