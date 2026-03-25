package ar.edu.itba.paw.models;

import java.util.UUID;

public class InterventionCategory {

    private final UUID id;
    private final String name;
    private final String label;
    private final String icon;
    private final int sortOrder;

    public InterventionCategory(final UUID id, final String name, final String label,
                                final String icon, final int sortOrder) {
        this.id = id;
        this.name = name;
        this.label = label;
        this.icon = icon;
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

    public String getIcon() {
        return icon;
    }

    public int getSortOrder() {
        return sortOrder;
    }
}
