package ar.edu.itba.paw.models;

import java.time.LocalDateTime;

public class User {

    private final long userId;
    private final String email;
    private final String username;
    private final LocalDateTime createdAt;

    public User(final long userId, final String email, final String username, final LocalDateTime createdAt) {
        this.userId = userId;
        this.email = email;
        this.username = username;
        this.createdAt = createdAt;
    }

    public long getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    public String getUsername() {
        return username;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
