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
public class EnrollmentJdbcDaoTest {

    private static final UUID PROTOCOL_ID = UUID.fromString("00000000-0000-0000-0008-000000000001");
    private static final UUID USER_1_ID = UUID.fromString("00000000-0000-0000-0007-000000000001");
    private static final UUID USER_2_ID = UUID.fromString("00000000-0000-0000-0007-000000000002");

    @Autowired
    private EnrollmentJdbcDao enrollmentDao;

    @Test
    public void exists_enrolled_returnsTrue() {
        assertTrue(enrollmentDao.exists(PROTOCOL_ID, USER_1_ID));
    }

    @Test
    public void exists_notEnrolled_returnsFalse() {
        assertFalse(enrollmentDao.exists(PROTOCOL_ID, USER_2_ID));
    }

    @Test
    public void create_newEnrollment_existsAfter() {
        enrollmentDao.create(PROTOCOL_ID, USER_2_ID);
        assertTrue(enrollmentDao.exists(PROTOCOL_ID, USER_2_ID));
    }

    @Test
    public void delete_existingEnrollment_notExistsAfter() {
        enrollmentDao.delete(PROTOCOL_ID, USER_1_ID);
        assertFalse(enrollmentDao.exists(PROTOCOL_ID, USER_1_ID));
    }
}
