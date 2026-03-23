package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Goal;
import ar.edu.itba.paw.models.GoalCategory;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface GoalDao {
    List<GoalCategory> findAllCategories();
    List<Goal> findAll();
    List<Goal> findByCategory(UUID categoryId);
    Optional<Goal> findById(UUID id);
}
