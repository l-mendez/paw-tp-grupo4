package ar.edu.itba.paw.models;

import java.util.Collections;
import java.util.List;

public class PaginatedResult<T> {

    private final List<T> items;
    private final int currentPage;
    private final int pageSize;
    private final long totalCount;

    public PaginatedResult(final List<T> items, final int currentPage,
                           final int pageSize, final long totalCount) {
        this.items = items != null ? Collections.unmodifiableList(items) : Collections.emptyList();
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
    }

    public List<T> getItems() { return items; }
    public int getCurrentPage() { return currentPage; }
    public int getPageSize() { return pageSize; }
    public long getTotalCount() { return totalCount; }

    public int getTotalPages() {
        return pageSize > 0 ? (int) Math.ceil((double) totalCount / pageSize) : 0;
    }

    public boolean getHasNext() {
        return currentPage < getTotalPages() - 1;
    }

    public boolean getHasPrevious() {
        return currentPage > 0;
    }
}
