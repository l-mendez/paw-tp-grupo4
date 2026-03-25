package ar.edu.itba.paw.persistence;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = TestConfig.class)
@Transactional
@Rollback
public class FavoriteJdbcDaoTest {

    private static final UUID PROTOCOL_ID = UUID.fromString("00000000-0000-0000-0008-000000000001");
    private static final UUID USER_1_ID = UUID.fromString("00000000-0000-0000-0007-000000000001");
    private static final UUID USER_2_ID = UUID.fromString("00000000-0000-0000-0007-000000000002");

    @Autowired
    private FavoriteJdbcDao favoriteDao;

    @Test
    public void exists_favorited_returnsTrue() {
        assertTrue(favoriteDao.exists(PROTOCOL_ID, USER_1_ID));
    }

    @Test
    public void exists_notFavorited_returnsFalse() {
        assertFalse(favoriteDao.exists(PROTOCOL_ID, USER_2_ID));
    }

    @Test
    public void create_newFavorite_existsAfter() {
        favoriteDao.create(PROTOCOL_ID, USER_2_ID);
        assertTrue(favoriteDao.exists(PROTOCOL_ID, USER_2_ID));
    }

    @Test
    public void delete_existingFavorite_notExistsAfter() {
        favoriteDao.delete(PROTOCOL_ID, USER_1_ID);
        assertFalse(favoriteDao.exists(PROTOCOL_ID, USER_1_ID));
    }
}
