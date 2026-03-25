package ar.edu.itba.paw.models;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

public class Protocol {

    private final UUID id;
    private final UUID creatorId;
    private final UUID goalId;
    private final UUID communityId;
    private final String title;
    private final String description;
    private final Integer durationDays;
    private final boolean isTemplate;
    private final String status;
    private final String visibility;
    private final Integer minParticipants;
    private final Integer maxParticipants;
    private final List<String> tags;
    private final int forkCount;
    private final UUID forkedFrom;
    private final LocalDateTime createdAt;
    private final LocalDateTime updatedAt;

    // Computed fields from search JOINs
    private final String creatorUsername;
    private final String creatorDisplayName;
    private final String goalLabel;
    private final String goalCategoryName;
    private final String goalCategoryIcon;
    private final double avgRating;
    private final int reviewCount;
    private final int enrollmentCount;
    private final int favoriteCount;

    private Protocol(final Builder builder) {
        this.id = builder.id;
        this.creatorId = builder.creatorId;
        this.goalId = builder.goalId;
        this.communityId = builder.communityId;
        this.title = builder.title;
        this.description = builder.description;
        this.durationDays = builder.durationDays;
        this.isTemplate = builder.isTemplate;
        this.status = builder.status;
        this.visibility = builder.visibility;
        this.minParticipants = builder.minParticipants;
        this.maxParticipants = builder.maxParticipants;
        this.tags = builder.tags != null ? Collections.unmodifiableList(builder.tags) : Collections.emptyList();
        this.forkCount = builder.forkCount;
        this.forkedFrom = builder.forkedFrom;
        this.createdAt = builder.createdAt;
        this.updatedAt = builder.updatedAt;
        this.creatorUsername = builder.creatorUsername;
        this.creatorDisplayName = builder.creatorDisplayName;
        this.goalLabel = builder.goalLabel;
        this.goalCategoryName = builder.goalCategoryName;
        this.goalCategoryIcon = builder.goalCategoryIcon;
        this.avgRating = builder.avgRating;
        this.reviewCount = builder.reviewCount;
        this.enrollmentCount = builder.enrollmentCount;
        this.favoriteCount = builder.favoriteCount;
    }

    public UUID getId() { return id; }
    public UUID getCreatorId() { return creatorId; }
    public UUID getGoalId() { return goalId; }
    public UUID getCommunityId() { return communityId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public Integer getDurationDays() { return durationDays; }
    public boolean isTemplate() { return isTemplate; }
    public String getStatus() { return status; }
    public String getVisibility() { return visibility; }
    public Integer getMinParticipants() { return minParticipants; }
    public Integer getMaxParticipants() { return maxParticipants; }
    public List<String> getTags() { return tags; }
    public int getForkCount() { return forkCount; }
    public UUID getForkedFrom() { return forkedFrom; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public String getCreatorUsername() { return creatorUsername; }
    public String getCreatorDisplayName() { return creatorDisplayName; }
    public String getGoalLabel() { return goalLabel; }
    public String getGoalCategoryName() { return goalCategoryName; }
    public String getGoalCategoryIcon() { return goalCategoryIcon; }
    public double getAvgRating() { return avgRating; }
    public int getReviewCount() { return reviewCount; }
    public int getEnrollmentCount() { return enrollmentCount; }
    public int getFavoriteCount() { return favoriteCount; }

    public static class Builder {
        private UUID id;
        private UUID creatorId;
        private UUID goalId;
        private UUID communityId;
        private String title;
        private String description;
        private Integer durationDays;
        private boolean isTemplate;
        private String status;
        private String visibility;
        private Integer minParticipants;
        private Integer maxParticipants;
        private List<String> tags;
        private int forkCount;
        private UUID forkedFrom;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        private String creatorUsername;
        private String creatorDisplayName;
        private String goalLabel;
        private String goalCategoryName;
        private String goalCategoryIcon;
        private double avgRating;
        private int reviewCount;
        private int enrollmentCount;
        private int favoriteCount;

        public Builder id(UUID id) { this.id = id; return this; }
        public Builder creatorId(UUID creatorId) { this.creatorId = creatorId; return this; }
        public Builder goalId(UUID goalId) { this.goalId = goalId; return this; }
        public Builder communityId(UUID communityId) { this.communityId = communityId; return this; }
        public Builder title(String title) { this.title = title; return this; }
        public Builder description(String description) { this.description = description; return this; }
        public Builder durationDays(Integer durationDays) { this.durationDays = durationDays; return this; }
        public Builder isTemplate(boolean isTemplate) { this.isTemplate = isTemplate; return this; }
        public Builder status(String status) { this.status = status; return this; }
        public Builder visibility(String visibility) { this.visibility = visibility; return this; }
        public Builder minParticipants(Integer minParticipants) { this.minParticipants = minParticipants; return this; }
        public Builder maxParticipants(Integer maxParticipants) { this.maxParticipants = maxParticipants; return this; }
        public Builder tags(List<String> tags) { this.tags = tags; return this; }
        public Builder forkCount(int forkCount) { this.forkCount = forkCount; return this; }
        public Builder forkedFrom(UUID forkedFrom) { this.forkedFrom = forkedFrom; return this; }
        public Builder createdAt(LocalDateTime createdAt) { this.createdAt = createdAt; return this; }
        public Builder updatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; return this; }
        public Builder creatorUsername(String creatorUsername) { this.creatorUsername = creatorUsername; return this; }
        public Builder creatorDisplayName(String creatorDisplayName) { this.creatorDisplayName = creatorDisplayName; return this; }
        public Builder goalLabel(String goalLabel) { this.goalLabel = goalLabel; return this; }
        public Builder goalCategoryName(String goalCategoryName) { this.goalCategoryName = goalCategoryName; return this; }
        public Builder goalCategoryIcon(String goalCategoryIcon) { this.goalCategoryIcon = goalCategoryIcon; return this; }
        public Builder avgRating(double avgRating) { this.avgRating = avgRating; return this; }
        public Builder reviewCount(int reviewCount) { this.reviewCount = reviewCount; return this; }
        public Builder enrollmentCount(int enrollmentCount) { this.enrollmentCount = enrollmentCount; return this; }
        public Builder favoriteCount(int favoriteCount) { this.favoriteCount = favoriteCount; return this; }

        public Protocol build() {
            return new Protocol(this);
        }
    }
}
