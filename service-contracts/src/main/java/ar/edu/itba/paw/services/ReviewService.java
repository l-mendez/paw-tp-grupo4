package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Review;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ReviewService {
    List<Review> getReviewsByProtocol(UUID protocolId);
    Optional<Review> getUserReview(UUID protocolId, UUID userId);
    Review createOrUpdate(UUID protocolId, UUID userId, int rating, String body);
    void delete(UUID protocolId, UUID userId);
}
