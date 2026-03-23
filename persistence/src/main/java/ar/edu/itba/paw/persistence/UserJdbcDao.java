package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.User;
import ar.edu.itba.paw.services.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Repository
public class UserJdbcDao implements UserDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<User> ROW_MAPPER = (rs, rowNum) -> {
        final java.sql.Timestamp ts = rs.getTimestamp("created_at");
        return new User(
                UUID.fromString(rs.getString("id")),
                rs.getString("email"),
                rs.getString("username"),
                rs.getString("display_name"),
                ts != null ? ts.toLocalDateTime() : java.time.LocalDateTime.now()
        );
    };

    @Autowired
    public UserJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
        this.jdbcInsert = new SimpleJdbcInsert(jdbcTemplate)
                .withTableName("users")
                .usingColumns("id", "email", "username", "display_name", "password_hash");
    }

    @Override
    public Optional<User> findByEmail(final String email) {
        return jdbcTemplate.query("SELECT * FROM users WHERE email = ?", ROW_MAPPER, email)
                .stream()
                .findFirst();
    }

    @Override
    public User create(final String email, final String username) {
        final Map<String, Object> args = new HashMap<>();
        args.put("email", email);
        args.put("username", username);
        args.put("display_name", username);
        args.put("password_hash", "");

        final UUID id = UUID.randomUUID();
        args.put("id", id);
        jdbcInsert.execute(args);
        return new User(id, email, username, username, java.time.LocalDateTime.now());
    }
}
