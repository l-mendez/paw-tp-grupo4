package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Goal;
import ar.edu.itba.paw.models.GoalCategory;
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
public class GoalServiceImplTest {

    @Mock
    private GoalDao goalDao;

    @InjectMocks
    private GoalServiceImpl goalService;

    private static final UUID CATEGORY_ID = UUID.randomUUID();

    // ── getAllCategories ──

    @Test
    public void getAllCategories_returnsCategoriesFromDao() {
        final List<GoalCategory> categories = List.of(
                new GoalCategory(UUID.randomUUID(), "sleep", "Sueño", "moon", 1),
                new GoalCategory(UUID.randomUUID(), "cognition", "Cognición", "brain", 2)
        );
        when(goalDao.findAllCategories()).thenReturn(categories);

        final List<GoalCategory> result = goalService.getAllCategories();

        assertEquals(2, result.size());
        assertEquals("sleep", result.get(0).getName());
        verify(goalDao).findAllCategories();
    }

    @Test
    public void getAllCategories_empty_returnsEmptyList() {
        when(goalDao.findAllCategories()).thenReturn(Collections.emptyList());

        final List<GoalCategory> result = goalService.getAllCategories();

        assertTrue(result.isEmpty());
    }

    // ── getAllGoals ──

    @Test
    public void getAllGoals_returnsGoalsFromDao() {
        final List<Goal> goals = List.of(
                new Goal(UUID.randomUUID(), CATEGORY_ID, "better_sleep", "Mejor sueño", "Dormir mejor")
        );
        when(goalDao.findAll()).thenReturn(goals);

        final List<Goal> result = goalService.getAllGoals();

        assertEquals(1, result.size());
        assertEquals("better_sleep", result.get(0).getName());
        verify(goalDao).findAll();
    }

    // ── getGoalsByCategory ──

    @Test
    public void getGoalsByCategory_delegatesToDaoWithCategoryId() {
        final List<Goal> goals = List.of(
                new Goal(UUID.randomUUID(), CATEGORY_ID, "gain_muscle", "Ganar músculo", "Hipertrofia")
        );
        when(goalDao.findByCategory(CATEGORY_ID)).thenReturn(goals);

        final List<Goal> result = goalService.getGoalsByCategory(CATEGORY_ID);

        assertEquals(1, result.size());
        verify(goalDao).findByCategory(CATEGORY_ID);
    }

    @Test
    public void getGoalsByCategory_noMatches_returnsEmptyList() {
        final UUID unknownCategory = UUID.randomUUID();
        when(goalDao.findByCategory(unknownCategory)).thenReturn(Collections.emptyList());

        final List<Goal> result = goalService.getGoalsByCategory(unknownCategory);

        assertTrue(result.isEmpty());
    }
}
