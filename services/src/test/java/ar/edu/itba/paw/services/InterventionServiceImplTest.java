package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Intervention;
import ar.edu.itba.paw.models.InterventionCategory;
import ar.edu.itba.paw.models.ProtocolIntervention;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class InterventionServiceImplTest {

    @Mock
    private InterventionDao interventionDao;

    @InjectMocks
    private InterventionServiceImpl interventionService;

    private static final UUID CATEGORY_ID = UUID.randomUUID();

    // ── getAllCategories ──

    @Test
    public void getAllCategories_returnsCategoriesFromDao() {
        final List<InterventionCategory> categories = List.of(
                new InterventionCategory(UUID.randomUUID(), "supplements", "Suplementos", "pill", 1),
                new InterventionCategory(UUID.randomUUID(), "exercise", "Ejercicio", "dumbbell", 2)
        );
        when(interventionDao.findAllCategories()).thenReturn(categories);

        final List<InterventionCategory> result = interventionService.getAllCategories();

        assertEquals(2, result.size());
        assertEquals("supplements", result.get(0).getName());
    }

    @Test
    public void getAllCategories_empty_returnsEmptyList() {
        when(interventionDao.findAllCategories()).thenReturn(Collections.emptyList());

        assertTrue(interventionService.getAllCategories().isEmpty());
    }

    // ── getAllInterventions ──

    @Test
    public void getAllInterventions_returnsInterventionsFromDao() {
        final List<Intervention> interventions = List.of(
                new Intervention(UUID.randomUUID(), CATEGORY_ID, "creatine", "Creatina", "Creatina monohidrato")
        );
        when(interventionDao.findAll()).thenReturn(interventions);

        final List<Intervention> result = interventionService.getAllInterventions();

        assertEquals(1, result.size());
        assertEquals("creatine", result.get(0).getName());
    }

    // ── getInterventionsByCategory ──

    @Test
    public void getInterventionsByCategory_delegatesWithCategoryId() {
        final List<Intervention> interventions = List.of(
                new Intervention(UUID.randomUUID(), CATEGORY_ID, "meditation", "Meditación", "Mindfulness")
        );
        when(interventionDao.findByCategory(CATEGORY_ID)).thenReturn(interventions);

        final List<Intervention> result = interventionService.getInterventionsByCategory(CATEGORY_ID);

        assertEquals(1, result.size());
    }

    @Test
    public void getInterventionsByCategory_noMatches_returnsEmptyList() {
        final UUID unknownCategory = UUID.randomUUID();
        when(interventionDao.findByCategory(unknownCategory)).thenReturn(Collections.emptyList());

        assertTrue(interventionService.getInterventionsByCategory(unknownCategory).isEmpty());
    }

    // ── getInterventionsByProtocol ──

    @Test
    public void getInterventionsByProtocol_returnsList() {
        final UUID protocolId = UUID.randomUUID();
        final List<ProtocolIntervention> expected = List.of(
                new ProtocolIntervention(UUID.randomUUID(), protocolId, CATEGORY_ID,
                        "creatine", "Creatina", new java.math.BigDecimal("5"), "g",
                        "diario", "manana", "Tomar con agua", 1, true)
        );
        when(interventionDao.findByProtocol(protocolId)).thenReturn(expected);

        final List<ProtocolIntervention> result = interventionService.getInterventionsByProtocol(protocolId);

        assertEquals(1, result.size());
        assertEquals("creatine", result.get(0).getInterventionName());
    }

    @Test
    public void getInterventionsByProtocol_noResults_returnsEmptyList() {
        final UUID protocolId = UUID.randomUUID();
        when(interventionDao.findByProtocol(protocolId)).thenReturn(Collections.emptyList());

        assertTrue(interventionService.getInterventionsByProtocol(protocolId).isEmpty());
    }
}
