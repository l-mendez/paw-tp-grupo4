package ar.edu.itba.paw.models;

import java.time.LocalDateTime;
import java.util.UUID;

public class User {

    private final UUID id;
    private final String email;
    private final String username;
    private final String displayName;
    private final LocalDateTime createdAt;

    public User(final UUID id, final String email, final String username,
                final String displayName, final LocalDateTime createdAt) {
        this.id = id;
        this.email = email;
        this.username = username;
        this.displayName = displayName;
        this.createdAt = createdAt;
    }

    public UUID getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getUsername() {
        return username;
    }

    public String getDisplayName() {
        return displayName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
