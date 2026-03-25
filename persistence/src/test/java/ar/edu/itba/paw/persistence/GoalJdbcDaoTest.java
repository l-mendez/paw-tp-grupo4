package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Goal;
import ar.edu.itba.paw.models.GoalCategory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = TestConfig.class)
@Transactional
@Rollback
public class GoalJdbcDaoTest {

    private static final UUID SLEEP_CATEGORY_ID = UUID.fromString("00000000-0000-0000-0001-000000000001");
    private static final UUID COGNITION_CATEGORY_ID = UUID.fromString("00000000-0000-0000-0001-000000000002");
    private static final UUID BETTER_SLEEP_ID = UUID.fromString("00000000-0000-0000-0002-000000000001");
    private static final UUID NONEXISTENT_ID = UUID.fromString("ffffffff-ffff-ffff-ffff-ffffffffffff");

    @Autowired
    private GoalJdbcDao goalDao;

    // ── findAllCategories ──

    @Test
    public void findAllCategories_returnsAllOrderedBySortOrder() {
        final List<GoalCategory> categories = goalDao.findAllCategories();

        assertEquals(3, categories.size());
        assertEquals("sleep", categories.get(0).getName());
        assertEquals("cognition", categories.get(1).getName());
        assertEquals("fitness", categories.get(2).getName());
    }

    @Test
    public void findAllCategories_categoriesHaveCorrectFields() {
        final List<GoalCategory> categories = goalDao.findAllCategories();
        assertFalse(categories.isEmpty());
        final GoalCategory sleep = categories.get(0);

        assertEquals(SLEEP_CATEGORY_ID, sleep.getId());
        assertEquals("Sueño", sleep.getLabel());
        assertEquals("moon", sleep.getIcon());
        assertEquals(1, sleep.getSortOrder());
    }

    // ── findAll ──

    @Test
    public void findAll_returnsAllGoalsOrderedByName() {
        final List<Goal> goals = goalDao.findAll();

        assertEquals(4, goals.size());
        // Alphabetical by name
        assertEquals("better_sleep", goals.get(0).getName());
        assertEquals("gain_muscle", goals.get(1).getName());
        assertEquals("improve_focus", goals.get(2).getName());
        assertEquals("reduce_latency", goals.get(3).getName());
    }

    // ── findByCategory ──

    @Test
    public void findByCategory_sleepCategory_returnsTwoGoals() {
        final List<Goal> goals = goalDao.findByCategory(SLEEP_CATEGORY_ID);

        assertEquals(2, goals.size());
        assertTrue(goals.stream().allMatch(g -> g.getCategoryId().equals(SLEEP_CATEGORY_ID)));
    }

    @Test
    public void findByCategory_cognitionCategory_returnsOneGoal() {
        final List<Goal> goals = goalDao.findByCategory(COGNITION_CATEGORY_ID);

        assertEquals(1, goals.size());
        assertEquals("improve_focus", goals.get(0).getName());
    }

    @Test
    public void findByCategory_nonexistentCategory_returnsEmptyList() {
        final List<Goal> goals = goalDao.findByCategory(NONEXISTENT_ID);

        assertTrue(goals.isEmpty());
    }

    // ── findById ──

    @Test
    public void findById_existing_returnsGoal() {
        final Optional<Goal> goal = goalDao.findById(BETTER_SLEEP_ID);

        assertTrue(goal.isPresent());
        assertEquals("better_sleep", goal.get().getName());
        assertEquals("Mejor sueño", goal.get().getLabel());
        assertEquals(SLEEP_CATEGORY_ID, goal.get().getCategoryId());
    }

    @Test
    public void findById_nonexistent_returnsEmpty() {
        final Optional<Goal> goal = goalDao.findById(NONEXISTENT_ID);

        assertTrue(goal.isEmpty());
    }
}
