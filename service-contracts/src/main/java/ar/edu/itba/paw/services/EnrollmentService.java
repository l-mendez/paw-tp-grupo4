package ar.edu.itba.paw.services;

import java.util.UUID;

public interface EnrollmentService {
    boolean isEnrolled(UUID protocolId, UUID userId);
    void toggle(UUID protocolId, UUID userId);
}
