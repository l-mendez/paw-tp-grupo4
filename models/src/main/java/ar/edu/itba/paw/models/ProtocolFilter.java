package ar.edu.itba.paw.models;

import java.util.List;
import java.util.UUID;

public class ProtocolFilter {

    public enum SortBy {
        NEWEST, POPULARITY, RATING, DURATION
    }

    public enum SortOrder {
        ASC, DESC
    }

    // Text search
    private String query;

    // Faceted filters
    private UUID goalCategoryId;
    private UUID goalId;
    private String status;
    private Integer minDuration;
    private Integer maxDuration;
    private Double minRating;
    private List<String> tags;
    private List<UUID> metricIds;
    private List<UUID> interventionCategoryIds;

    // Sorting
    private SortBy sortBy = SortBy.NEWEST;
    private SortOrder sortOrder = SortOrder.DESC;

    // Pagination
    private int page = 0;
    private int pageSize = 12;

    public String getQuery() { return query; }
    public void setQuery(String query) { this.query = query; }

    public UUID getGoalCategoryId() { return goalCategoryId; }
    public void setGoalCategoryId(UUID goalCategoryId) { this.goalCategoryId = goalCategoryId; }

    public UUID getGoalId() { return goalId; }
    public void setGoalId(UUID goalId) { this.goalId = goalId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getMinDuration() { return minDuration; }
    public void setMinDuration(Integer minDuration) { this.minDuration = minDuration; }

    public Integer getMaxDuration() { return maxDuration; }
    public void setMaxDuration(Integer maxDuration) { this.maxDuration = maxDuration; }

    public Double getMinRating() { return minRating; }
    public void setMinRating(Double minRating) { this.minRating = minRating; }

    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }

    public List<UUID> getMetricIds() { return metricIds; }
    public void setMetricIds(List<UUID> metricIds) { this.metricIds = metricIds; }

    public List<UUID> getInterventionCategoryIds() { return interventionCategoryIds; }
    public void setInterventionCategoryIds(List<UUID> interventionCategoryIds) { this.interventionCategoryIds = interventionCategoryIds; }

    public SortBy getSortBy() { return sortBy; }
    public void setSortBy(SortBy sortBy) { this.sortBy = sortBy; }

    public SortOrder getSortOrder() { return sortOrder; }
    public void setSortOrder(SortOrder sortOrder) { this.sortOrder = sortOrder; }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
}
