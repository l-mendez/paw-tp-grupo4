package ar.edu.itba.paw.models;

import java.math.BigDecimal;
import java.util.UUID;

public class ProtocolIntervention {

    private final UUID id;
    private final UUID protocolId;
    private final UUID interventionId;
    private final String interventionName;
    private final String interventionLabel;
    private final BigDecimal dosage;
    private final String dosageUnit;
    private final String frequency;
    private final String timing;
    private final String instructions;
    private final int sortOrder;
    private final boolean active;

    public ProtocolIntervention(final UUID id, final UUID protocolId, final UUID interventionId,
                                final String interventionName, final String interventionLabel,
                                final BigDecimal dosage, final String dosageUnit,
                                final String frequency, final String timing,
                                final String instructions, final int sortOrder,
                                final boolean active) {
        this.id = id;
        this.protocolId = protocolId;
        this.interventionId = interventionId;
        this.interventionName = interventionName;
        this.interventionLabel = interventionLabel;
        this.dosage = dosage;
        this.dosageUnit = dosageUnit;
        this.frequency = frequency;
        this.timing = timing;
        this.instructions = instructions;
        this.sortOrder = sortOrder;
        this.active = active;
    }

    public UUID getId() { return id; }
    public UUID getProtocolId() { return protocolId; }
    public UUID getInterventionId() { return interventionId; }
    public String getInterventionName() { return interventionName; }
    public String getInterventionLabel() { return interventionLabel; }
    public BigDecimal getDosage() { return dosage; }
    public String getDosageUnit() { return dosageUnit; }
    public String getFrequency() { return frequency; }
    public String getTiming() { return timing; }
    public String getInstructions() { return instructions; }
    public int getSortOrder() { return sortOrder; }
    public boolean isActive() { return active; }
}
