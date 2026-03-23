package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Intervention;
import ar.edu.itba.paw.models.InterventionCategory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class InterventionServiceImpl implements InterventionService {

    private final InterventionDao interventionDao;

    @Autowired
    public InterventionServiceImpl(final InterventionDao interventionDao) {
        this.interventionDao = interventionDao;
    }

    @Override
    public List<InterventionCategory> getAllCategories() {
        return interventionDao.findAllCategories();
    }

    @Override
    public List<Intervention> getAllInterventions() {
        return interventionDao.findAll();
    }

    @Override
    public List<Intervention> getInterventionsByCategory(final UUID categoryId) {
        return interventionDao.findByCategory(categoryId);
    }
}
