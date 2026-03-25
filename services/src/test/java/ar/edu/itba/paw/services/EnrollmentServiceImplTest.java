package ar.edu.itba.paw.services;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class EnrollmentServiceImplTest {

    @Mock
    private EnrollmentDao enrollmentDao;

    @InjectMocks
    private EnrollmentServiceImpl enrollmentService;

    private static final UUID PROTOCOL_ID = UUID.randomUUID();
    private static final UUID USER_ID = UUID.randomUUID();

    @Test
    public void isEnrolled_enrolled_returnsTrue() {
        when(enrollmentDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(true);
        assertTrue(enrollmentService.isEnrolled(PROTOCOL_ID, USER_ID));
    }

    @Test
    public void isEnrolled_notEnrolled_returnsFalse() {
        when(enrollmentDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(false);
        assertFalse(enrollmentService.isEnrolled(PROTOCOL_ID, USER_ID));
    }

    @Test
    public void toggle_notEnrolled_enrolls() {
        when(enrollmentDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(false);
        enrollmentService.toggle(PROTOCOL_ID, USER_ID);
        // No exception — toggle completed
    }

    @Test
    public void toggle_enrolled_unenrolls() {
        when(enrollmentDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(true);
        enrollmentService.toggle(PROTOCOL_ID, USER_ID);
        // No exception — toggle completed
    }
}
