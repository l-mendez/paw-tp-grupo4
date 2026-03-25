package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Review;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ReviewDao {
    List<Review> findByProtocol(UUID protocolId);
    Optional<Review> findByProtocolAndUser(UUID protocolId, UUID userId);
    Review create(UUID protocolId, UUID userId, int rating, String body);
    void update(UUID reviewId, int rating, String body);
    void delete(UUID reviewId);
}
