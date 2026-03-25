package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class ReviewServiceImpl implements ReviewService {

    private final ReviewDao reviewDao;

    @Autowired
    public ReviewServiceImpl(final ReviewDao reviewDao) {
        this.reviewDao = reviewDao;
    }

    @Override
    public List<Review> getReviewsByProtocol(final UUID protocolId) {
        return reviewDao.findByProtocol(protocolId);
    }

    @Override
    public Optional<Review> getUserReview(final UUID protocolId, final UUID userId) {
        return reviewDao.findByProtocolAndUser(protocolId, userId);
    }

    @Override
    @Transactional
    public Review createOrUpdate(final UUID protocolId, final UUID userId, final int rating, final String body) {
        final int clampedRating = Math.max(1, Math.min(5, rating));
        final Optional<Review> existing = reviewDao.findByProtocolAndUser(protocolId, userId);
        if (existing.isPresent()) {
            reviewDao.update(existing.get().getId(), clampedRating, body);
            return reviewDao.findByProtocolAndUser(protocolId, userId).orElseThrow();
        }
        return reviewDao.create(protocolId, userId, clampedRating, body);
    }

    @Override
    @Transactional
    public void delete(final UUID protocolId, final UUID userId) {
        reviewDao.findByProtocolAndUser(protocolId, userId)
                .ifPresent(review -> reviewDao.delete(review.getId()));
    }
}
