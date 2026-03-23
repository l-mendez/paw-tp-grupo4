package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Intervention;
import ar.edu.itba.paw.models.InterventionCategory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = TestConfig.class)
@Transactional
@Rollback
public class InterventionJdbcDaoTest {

    private static final UUID SUPPLEMENTS_CATEGORY_ID = UUID.fromString("00000000-0000-0000-0003-000000000001");
    private static final UUID EXERCISE_CATEGORY_ID = UUID.fromString("00000000-0000-0000-0003-000000000002");
    private static final UUID NONEXISTENT_ID = UUID.fromString("ffffffff-ffff-ffff-ffff-ffffffffffff");

    @Autowired
    private InterventionJdbcDao interventionDao;

    // ── findAllCategories ──

    @Test
    public void findAllCategories_returnsAllOrderedBySortOrder() {
        final List<InterventionCategory> categories = interventionDao.findAllCategories();

        assertEquals(2, categories.size());
        assertEquals("supplements", categories.get(0).getName());
        assertEquals("exercise", categories.get(1).getName());
    }

    @Test
    public void findAllCategories_categoriesHaveCorrectFields() {
        final InterventionCategory supplements = interventionDao.findAllCategories().get(0);

        assertEquals(SUPPLEMENTS_CATEGORY_ID, supplements.getId());
        assertEquals("Suplementos", supplements.getLabel());
        assertEquals("pill", supplements.getIcon());
        assertEquals(1, supplements.getSortOrder());
    }

    // ── findAll ──

    @Test
    public void findAll_returnsAllInterventionsOrderedByName() {
        final List<Intervention> interventions = interventionDao.findAll();

        assertEquals(3, interventions.size());
        assertEquals("creatine", interventions.get(0).getName());
        assertEquals("magnesium", interventions.get(1).getName());
        assertEquals("strength_training", interventions.get(2).getName());
    }

    // ── findByCategory ──

    @Test
    public void findByCategory_supplements_returnsTwoInterventions() {
        final List<Intervention> interventions = interventionDao.findByCategory(SUPPLEMENTS_CATEGORY_ID);

        assertEquals(2, interventions.size());
        assertTrue(interventions.stream().allMatch(i -> i.getCategoryId().equals(SUPPLEMENTS_CATEGORY_ID)));
    }

    @Test
    public void findByCategory_exercise_returnsOneIntervention() {
        final List<Intervention> interventions = interventionDao.findByCategory(EXERCISE_CATEGORY_ID);

        assertEquals(1, interventions.size());
        assertEquals("strength_training", interventions.get(0).getName());
    }

    @Test
    public void findByCategory_nonexistent_returnsEmptyList() {
        assertTrue(interventionDao.findByCategory(NONEXISTENT_ID).isEmpty());
    }
}
