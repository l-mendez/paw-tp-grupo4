package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Goal;
import ar.edu.itba.paw.models.GoalCategory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class GoalServiceImpl implements GoalService {

    private final GoalDao goalDao;

    @Autowired
    public GoalServiceImpl(final GoalDao goalDao) {
        this.goalDao = goalDao;
    }

    @Override
    public List<GoalCategory> getAllCategories() {
        return goalDao.findAllCategories();
    }

    @Override
    public List<Goal> getAllGoals() {
        return goalDao.findAll();
    }

    @Override
    public List<Goal> getGoalsByCategory(final UUID categoryId) {
        return goalDao.findByCategory(categoryId);
    }
}
