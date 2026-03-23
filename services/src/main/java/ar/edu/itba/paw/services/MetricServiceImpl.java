package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Metric;
import ar.edu.itba.paw.models.MetricCategory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class MetricServiceImpl implements MetricService {

    private final MetricDao metricDao;

    @Autowired
    public MetricServiceImpl(final MetricDao metricDao) {
        this.metricDao = metricDao;
    }

    @Override
    public List<MetricCategory> getAllCategories() {
        return metricDao.findAllCategories();
    }

    @Override
    public List<Metric> getAllMetrics() {
        return metricDao.findAll();
    }

    @Override
    public List<Metric> getMetricsByCategory(final UUID categoryId) {
        return metricDao.findByCategory(categoryId);
    }
}
