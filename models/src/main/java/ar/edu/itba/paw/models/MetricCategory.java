package ar.edu.itba.paw.models;

import java.util.UUID;

public class MetricCategory {

    private final UUID id;
    private final String name;
    private final String label;
    private final int sortOrder;

    public MetricCategory(final UUID id, final String name, final String label,
                          final int sortOrder) {
        this.id = id;
        this.name = name;
        this.label = label;
        this.sortOrder = sortOrder;
    }

    public UUID getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getLabel() {
        return label;
    }

    public int getSortOrder() {
        return sortOrder;
    }
}
