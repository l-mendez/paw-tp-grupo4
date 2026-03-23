package ar.edu.itba.paw.models;

import java.util.UUID;

public class Metric {

    private final UUID id;
    private final UUID categoryId;
    private final String name;
    private final String label;
    private final String unit;
    private final String valueType;

    public Metric(final UUID id, final UUID categoryId, final String name,
                  final String label, final String unit, final String valueType) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.label = label;
        this.unit = unit;
        this.valueType = valueType;
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

    public String getUnit() {
        return unit;
    }

    public String getValueType() {
        return valueType;
    }
}
