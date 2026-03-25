package ar.edu.itba.paw.models;

import java.util.UUID;

public class Intervention {

    private final UUID id;
    private final UUID categoryId;
    private final String name;
    private final String label;
    private final String description;

    public Intervention(final UUID id, final UUID categoryId, final String name,
                        final String label, final String description) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.label = label;
        this.description = description;
    }

    public UUID getId() {
        return id;
    }

    public UUID getCategoryId() {
        return categoryId;
    }

    public String getName() {
        return name;
    }

    public String getLabel() {
        return label;
    }

    public String getDescription() {
        return description;
    }
}
