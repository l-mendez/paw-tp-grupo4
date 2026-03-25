package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Intervention;
import ar.edu.itba.paw.models.InterventionCategory;
import ar.edu.itba.paw.models.ProtocolIntervention;

import java.util.List;
import java.util.UUID;

public interface InterventionService {
    List<InterventionCategory> getAllCategories();
    List<Intervention> getAllInterventions();
    List<Intervention> getInterventionsByCategory(UUID categoryId);
    List<ProtocolIntervention> getInterventionsByProtocol(UUID protocolId);
}
