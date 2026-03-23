package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Metric;
import ar.edu.itba.paw.models.MetricCategory;

import java.util.List;
import java.util.UUID;

public interface MetricService {
    List<MetricCategory> getAllCategories();
    List<Metric> getAllMetrics();
    List<Metric> getMetricsByCategory(UUID categoryId);
}
