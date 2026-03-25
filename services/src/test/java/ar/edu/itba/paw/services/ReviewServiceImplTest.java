package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Review;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ReviewServiceImplTest {

    @Mock
    private ReviewDao reviewDao;

    @InjectMocks
    private ReviewServiceImpl reviewService;

    private static final UUID PROTOCOL_ID = UUID.randomUUID();
    private static final UUID USER_ID = UUID.randomUUID();

    // ── getReviewsByProtocol ──

    @Test
    public void getReviewsByProtocol_returnsList() {
        final List<Review> expected = List.of(
                new Review(UUID.randomUUID(), PROTOCOL_ID, USER_ID, "Test", 5, null, "Great", LocalDateTime.now())
        );
        when(reviewDao.findByProtocol(PROTOCOL_ID)).thenReturn(expected);

        final List<Review> result = reviewService.getReviewsByProtocol(PROTOCOL_ID);

        assertEquals(1, result.size());
    }

    @Test
    public void getReviewsByProtocol_noReviews_returnsEmptyList() {
        when(reviewDao.findByProtocol(PROTOCOL_ID)).thenReturn(Collections.emptyList());

        assertTrue(reviewService.getReviewsByProtocol(PROTOCOL_ID).isEmpty());
    }

    // ── getUserReview ──

    @Test
    public void getUserReview_exists_returnsReview() {
        final Review review = new Review(UUID.randomUUID(), PROTOCOL_ID, USER_ID, "Test", 4, null, "Good", LocalDateTime.now());
        when(reviewDao.findByProtocolAndUser(PROTOCOL_ID, USER_ID)).thenReturn(Optional.of(review));

        final Optional<Review> result = reviewService.getUserReview(PROTOCOL_ID, USER_ID);

        assertTrue(result.isPresent());
        assertEquals(4, result.get().getRating());
    }

    // ── createOrUpdate ──

    @Test
    public void createOrUpdate_newReview_createsReview() {
        when(reviewDao.findByProtocolAndUser(PROTOCOL_ID, USER_ID)).thenReturn(Optional.empty());
        final Review created = new Review(UUID.randomUUID(), PROTOCOL_ID, USER_ID, "Test", 4, null, "Nice", LocalDateTime.now());
        when(reviewDao.create(PROTOCOL_ID, USER_ID, 4, "Nice")).thenReturn(created);

        final Review result = reviewService.createOrUpdate(PROTOCOL_ID, USER_ID, 4, "Nice");

        assertEquals(4, result.getRating());
    }

    @Test
    public void createOrUpdate_existingReview_updatesReview() {
        final UUID reviewId = UUID.randomUUID();
        final Review existing = new Review(reviewId, PROTOCOL_ID, USER_ID, "Test", 3, null, "Old", LocalDateTime.now());
        final Review updated = new Review(reviewId, PROTOCOL_ID, USER_ID, "Test", 5, null, "Updated", LocalDateTime.now());
        when(reviewDao.findByProtocolAndUser(PROTOCOL_ID, USER_ID))
                .thenReturn(Optional.of(existing))
                .thenReturn(Optional.of(updated));

        final Review result = reviewService.createOrUpdate(PROTOCOL_ID, USER_ID, 5, "Updated");

        assertEquals(5, result.getRating());
    }

    @Test
    public void createOrUpdate_ratingAbove5_clampedTo5() {
        when(reviewDao.findByProtocolAndUser(PROTOCOL_ID, USER_ID)).thenReturn(Optional.empty());
        final Review created = new Review(UUID.randomUUID(), PROTOCOL_ID, USER_ID, "Test", 5, null, "Max", LocalDateTime.now());
        when(reviewDao.create(PROTOCOL_ID, USER_ID, 5, "Max")).thenReturn(created);

        final Review result = reviewService.createOrUpdate(PROTOCOL_ID, USER_ID, 10, "Max");

        assertEquals(5, result.getRating());
    }
}
