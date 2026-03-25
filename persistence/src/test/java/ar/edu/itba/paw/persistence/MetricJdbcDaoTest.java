package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.Metric;
import ar.edu.itba.paw.models.MetricCategory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = TestConfig.class)
@Transactional
@Rollback
public class MetricJdbcDaoTest {

    private static final UUID BIOMETRICS_CATEGORY_ID = UUID.fromString("00000000-0000-0000-0005-000000000001");
    private static final UUID SUBJECTIVE_CATEGORY_ID = UUID.fromString("00000000-0000-0000-0005-000000000002");
    private static final UUID NONEXISTENT_ID = UUID.fromString("ffffffff-ffff-ffff-ffff-ffffffffffff");

    @Autowired
    private MetricJdbcDao metricDao;

    // ── findAllCategories ──

    @Test
    public void findAllCategories_returnsAllOrderedBySortOrder() {
        final List<MetricCategory> categories = metricDao.findAllCategories();

        assertEquals(2, categories.size());
        assertEquals("biometrics", categories.get(0).getName());
        assertEquals("subjective", categories.get(1).getName());
    }

    @Test
    public void findAllCategories_categoriesHaveCorrectFields() {
        final List<MetricCategory> categories = metricDao.findAllCategories();
        assertFalse(categories.isEmpty());
        final MetricCategory biometrics = categories.get(0);

        assertEquals(BIOMETRICS_CATEGORY_ID, biometrics.getId());
        assertEquals("Biométricas", biometrics.getLabel());
        assertEquals(1, biometrics.getSortOrder());
    }

    // ── findAll ──

    @Test
    public void findAll_returnsAllMetricsOrderedByName() {
        final List<Metric> metrics = metricDao.findAll();

        assertEquals(3, metrics.size());
        assertEquals("hrv", metrics.get(0).getName());
        assertEquals("perceived_focus", metrics.get(1).getName());
        assertEquals("sleep_hours", metrics.get(2).getName());
    }

    @Test
    public void findAll_metricsHaveCorrectFields() {
        final List<Metric> metrics = metricDao.findAll();
        assertFalse(metrics.isEmpty());
        final Metric hrv = metrics.get(0);

        assertEquals("HRV", hrv.getLabel());
        assertEquals("ms", hrv.getUnit());
        assertEquals("numeric", hrv.getValueType());
        assertEquals(BIOMETRICS_CATEGORY_ID, hrv.getCategoryId());
    }

    // ── findByCategory ──

    @Test
    public void findByCategory_biometrics_returnsTwoMetrics() {
        final List<Metric> metrics = metricDao.findByCategory(BIOMETRICS_CATEGORY_ID);

        assertEquals(2, metrics.size());
        assertTrue(metrics.stream().allMatch(m -> m.getCategoryId().equals(BIOMETRICS_CATEGORY_ID)));
    }

    @Test
    public void findByCategory_subjective_returnsOneMetric() {
        final List<Metric> metrics = metricDao.findByCategory(SUBJECTIVE_CATEGORY_ID);

        assertEquals(1, metrics.size());
        assertEquals("perceived_focus", metrics.get(0).getName());
    }

    @Test
    public void findByCategory_nonexistent_returnsEmptyList() {
        assertTrue(metricDao.findByCategory(NONEXISTENT_ID).isEmpty());
    }
}
