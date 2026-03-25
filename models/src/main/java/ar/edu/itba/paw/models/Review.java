package ar.edu.itba.paw.models;

import java.time.LocalDateTime;
import java.util.UUID;

public class Review {

    private final UUID id;
    private final UUID protocolId;
    private final UUID userId;
    private final String userDisplayName;
    private final int rating;
    private final String title;
    private final String body;
    private final LocalDateTime createdAt;

    public Review(final UUID id, final UUID protocolId, final UUID userId,
                  final String userDisplayName, final int rating, final String title,
                  final String body, final LocalDateTime createdAt) {
        this.id = id;
        this.protocolId = protocolId;
        this.userId = userId;
        this.userDisplayName = userDisplayName;
        this.rating = rating;
        this.title = title;
        this.body = body;
        this.createdAt = createdAt;
    }

    public UUID getId() { return id; }
    public UUID getProtocolId() { return protocolId; }
    public UUID getUserId() { return userId; }
    public String getUserDisplayName() { return userDisplayName; }
    public int getRating() { return rating; }
    public String getTitle() { return title; }
    public String getBody() { return body; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
