package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Intervention;
import ar.edu.itba.paw.models.InterventionCategory;

import java.util.List;
import java.util.UUID;

public interface InterventionDao {
    List<InterventionCategory> findAllCategories();
    List<Intervention> findAll();
    List<Intervention> findByCategory(UUID categoryId);
}
