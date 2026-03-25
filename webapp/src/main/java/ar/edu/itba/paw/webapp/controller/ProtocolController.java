package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.models.*;
import ar.edu.itba.paw.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.UUID;

// TODO: add controller tests (MockMvc) for filter binding, sort, and pagination
@Controller
public class ProtocolController {

    private final ProtocolService protocolService;
    private final GoalService goalService;
    private final MetricService metricService;
    private final InterventionService interventionService;

    @Autowired
    public ProtocolController(final ProtocolService protocolService,
                              final GoalService goalService,
                              final MetricService metricService,
                              final InterventionService interventionService) {
        this.protocolService = protocolService;
        this.goalService = goalService;
        this.metricService = metricService;
        this.interventionService = interventionService;
    }

    @RequestMapping(value = "/protocols", method = RequestMethod.GET)
    public ModelAndView list(
            @RequestParam(value = "q", required = false) final String query,
            @RequestParam(value = "goalCategory", required = false) final String goalCategoryId,
            @RequestParam(value = "goal", required = false) final String goalId,
            @RequestParam(value = "status", required = false) final String status,
            @RequestParam(value = "minDuration", required = false) final Integer minDuration,
            @RequestParam(value = "maxDuration", required = false) final Integer maxDuration,
            @RequestParam(value = "minRating", required = false) final Double minRating,
            @RequestParam(value = "tags", required = false) final List<String> tags,
            @RequestParam(value = "metrics", required = false) final List<String> metricIds,
            @RequestParam(value = "interventionCategories", required = false) final List<String> interventionCategoryIds,
            @RequestParam(value = "sort", required = false, defaultValue = "newest") final String sort,
            @RequestParam(value = "page", required = false, defaultValue = "0") final int page
    ) {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setQuery(query);
        filter.setStatus(status);
        filter.setMinDuration(minDuration);
        filter.setMaxDuration(maxDuration);
        filter.setMinRating(minRating);
        filter.setTags(tags);
        filter.setPage(page);

        parseUuid(goalCategoryId).ifPresent(filter::setGoalCategoryId);
        parseUuid(goalId).ifPresent(filter::setGoalId);

        if (metricIds != null && !metricIds.isEmpty()) {
            filter.setMetricIds(metricIds.stream()
                    .map(ProtocolController::parseUuid)
                    .filter(java.util.Optional::isPresent)
                    .map(java.util.Optional::get)
                    .toList());
        }
        if (interventionCategoryIds != null && !interventionCategoryIds.isEmpty()) {
            filter.setInterventionCategoryIds(interventionCategoryIds.stream()
                    .map(ProtocolController::parseUuid)
                    .filter(java.util.Optional::isPresent)
                    .map(java.util.Optional::get)
                    .toList());
        }

        switch (sort) {
            case "popular":
                filter.setSortBy(ProtocolFilter.SortBy.POPULARITY);
                break;
            case "rating":
                filter.setSortBy(ProtocolFilter.SortBy.RATING);
                break;
            case "duration":
                filter.setSortBy(ProtocolFilter.SortBy.DURATION);
                break;
            default:
                filter.setSortBy(ProtocolFilter.SortBy.NEWEST);
                break;
        }

        final PaginatedResult<Protocol> result = protocolService.search(filter);

        final List<GoalCategory> goalCategories = goalService.getAllCategories();
        // TODO: metricCategories and allMetrics are loaded but not yet used in the JSP.
        //  Remove these queries or add a metric filter to the UI.
        final List<MetricCategory> metricCategories = metricService.getAllCategories();
        final List<Metric> allMetrics = metricService.getAllMetrics();
        final List<InterventionCategory> interventionCats = interventionService.getAllCategories();
        final List<String> allTags = protocolService.getAllTags();

        final ModelAndView mav = new ModelAndView("protocols/list");
        mav.addObject("result", result);
        mav.addObject("protocols", result.getItems());
        mav.addObject("filter", filter);
        mav.addObject("goalCategories", goalCategories);
        mav.addObject("metricCategories", metricCategories);
        mav.addObject("allMetrics", allMetrics);
        mav.addObject("interventionCategories", interventionCats);
        mav.addObject("allTags", allTags);
        mav.addObject("currentSort", sort);

        return mav;
    }

    @RequestMapping(value = "/protocols/{id}", method = RequestMethod.GET)
    public ModelAndView detail(@PathVariable("id") final String id) {
        final UUID protocolId;
        try {
            protocolId = UUID.fromString(id);
        } catch (IllegalArgumentException e) {
            return new ModelAndView("404");
        }

        final java.util.Optional<Protocol> maybeProtocol = protocolService.findById(protocolId);
        if (maybeProtocol.isEmpty()) {
            return new ModelAndView("404");
        }

        final Protocol protocol = maybeProtocol.get();
        final java.util.List<ProtocolIntervention> interventions =
                interventionService.getInterventionsByProtocol(protocolId);

        final ModelAndView mav = new ModelAndView("protocols/detail");
        mav.addObject("protocol", protocol);
        mav.addObject("interventions", interventions);
        return mav;
    }

    private static java.util.Optional<UUID> parseUuid(final String value) {
        if (value == null || value.isBlank()) {
            return java.util.Optional.empty();
        }
        try {
            return java.util.Optional.of(UUID.fromString(value));
        } catch (IllegalArgumentException e) {
            return java.util.Optional.empty();
        }
    }
}
