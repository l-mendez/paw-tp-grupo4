package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Goal;
import ar.edu.itba.paw.models.GoalCategory;

import java.util.List;
import java.util.UUID;

public interface GoalService {
    List<GoalCategory> getAllCategories();
    List<Goal> getAllGoals();
    List<Goal> getGoalsByCategory(UUID categoryId);
}
