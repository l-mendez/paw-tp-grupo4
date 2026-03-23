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

@Repository
public class UserJdbcDao implements UserDao {

    private final JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert jdbcInsert;

    private static final RowMapper<User> ROW_MAPPER = (rs, rowNum) -> {
        final java.sql.Timestamp ts = rs.getTimestamp("created_at");
        return new User(
                rs.getLong("user_id"),
                rs.getString("email"),
                rs.getString("username"),
                ts != null ? ts.toLocalDateTime() : java.time.LocalDateTime.now()
        );
    };

    @Autowired
    public UserJdbcDao(final DataSource ds) {
        this.jdbcTemplate = new JdbcTemplate(ds);
        this.jdbcInsert = new SimpleJdbcInsert(jdbcTemplate)
                .withTableName("users")
                .usingGeneratedKeyColumns("user_id");
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
        args.put("password", "");

        final Number userId = jdbcInsert.executeAndReturnKey(args);
        return new User(userId.longValue(), email, username, java.time.LocalDateTime.now());
    }
}
