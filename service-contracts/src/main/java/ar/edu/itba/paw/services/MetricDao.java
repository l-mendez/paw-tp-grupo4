package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Metric;
import ar.edu.itba.paw.models.MetricCategory;

import java.util.List;
import java.util.UUID;

public interface MetricDao {
    List<MetricCategory> findAllCategories();
    List<Metric> findAll();
    List<Metric> findByCategory(UUID categoryId);
}
