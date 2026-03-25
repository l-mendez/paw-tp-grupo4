package ar.edu.itba.paw.services;

import java.util.UUID;

public interface EnrollmentDao {
    boolean exists(UUID protocolId, UUID userId);
    void create(UUID protocolId, UUID userId);
    void delete(UUID protocolId, UUID userId);
}
