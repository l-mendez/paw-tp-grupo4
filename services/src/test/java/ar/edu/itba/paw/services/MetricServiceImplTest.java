package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.Metric;
import ar.edu.itba.paw.models.MetricCategory;
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
public class MetricServiceImplTest {

    @Mock
    private MetricDao metricDao;

    @InjectMocks
    private MetricServiceImpl metricService;

    private static final UUID CATEGORY_ID = UUID.randomUUID();

    // ── getAllCategories ──

    @Test
    public void getAllCategories_returnsCategoriesFromDao() {
        final List<MetricCategory> categories = List.of(
                new MetricCategory(UUID.randomUUID(), "biometrics", "Biométricas", 1),
                new MetricCategory(UUID.randomUUID(), "subjective", "Subjetivas", 2)
        );
        when(metricDao.findAllCategories()).thenReturn(categories);

        final List<MetricCategory> result = metricService.getAllCategories();

        assertEquals(2, result.size());
        assertEquals("biometrics", result.get(0).getName());
        verify(metricDao).findAllCategories();
    }

    @Test
    public void getAllCategories_empty_returnsEmptyList() {
        when(metricDao.findAllCategories()).thenReturn(Collections.emptyList());

        assertTrue(metricService.getAllCategories().isEmpty());
    }

    // ── getAllMetrics ──

    @Test
    public void getAllMetrics_returnsMetricsFromDao() {
        final List<Metric> metrics = List.of(
                new Metric(UUID.randomUUID(), CATEGORY_ID, "hrv", "HRV", "ms", "numeric"),
                new Metric(UUID.randomUUID(), CATEGORY_ID, "sleep_hours", "Horas de sueño", "horas", "numeric")
        );
        when(metricDao.findAll()).thenReturn(metrics);

        final List<Metric> result = metricService.getAllMetrics();

        assertEquals(2, result.size());
        verify(metricDao).findAll();
    }

    // ── getMetricsByCategory ──

    @Test
    public void getMetricsByCategory_delegatesWithCategoryId() {
        final List<Metric> metrics = List.of(
                new Metric(UUID.randomUUID(), CATEGORY_ID, "hrv", "HRV", "ms", "numeric")
        );
        when(metricDao.findByCategory(CATEGORY_ID)).thenReturn(metrics);

        final List<Metric> result = metricService.getMetricsByCategory(CATEGORY_ID);

        assertEquals(1, result.size());
        assertEquals("hrv", result.get(0).getName());
        verify(metricDao).findByCategory(CATEGORY_ID);
    }

    @Test
    public void getMetricsByCategory_noMatches_returnsEmptyList() {
        final UUID unknownCategory = UUID.randomUUID();
        when(metricDao.findByCategory(unknownCategory)).thenReturn(Collections.emptyList());

        assertTrue(metricService.getMetricsByCategory(unknownCategory).isEmpty());
    }
}
