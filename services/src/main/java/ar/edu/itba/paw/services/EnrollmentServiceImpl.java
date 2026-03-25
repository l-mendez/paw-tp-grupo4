package ar.edu.itba.paw.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class EnrollmentServiceImpl implements EnrollmentService {

    private final EnrollmentDao enrollmentDao;

    @Autowired
    public EnrollmentServiceImpl(final EnrollmentDao enrollmentDao) {
        this.enrollmentDao = enrollmentDao;
    }

    @Override
    public boolean isEnrolled(final UUID protocolId, final UUID userId) {
        return enrollmentDao.exists(protocolId, userId);
    }

    @Override
    @Transactional
    public void toggle(final UUID protocolId, final UUID userId) {
        if (enrollmentDao.exists(protocolId, userId)) {
            enrollmentDao.delete(protocolId, userId);
        } else {
            enrollmentDao.create(protocolId, userId);
        }
    }
}
