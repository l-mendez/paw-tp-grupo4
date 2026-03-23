package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.PaginatedResult;
import ar.edu.itba.paw.models.Protocol;
import ar.edu.itba.paw.models.ProtocolFilter;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ProtocolServiceImplTest {

    @Mock
    private ProtocolDao protocolDao;

    @InjectMocks
    private ProtocolServiceImpl protocolService;

    private static final UUID PROTOCOL_ID = UUID.randomUUID();

    private static Protocol buildProtocol() {
        return new Protocol.Builder()
                .id(PROTOCOL_ID)
                .creatorId(UUID.randomUUID())
                .goalId(UUID.randomUUID())
                .title("Test Protocol")
                .status("active")
                .visibility("public")
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
    }

    // ── search: sortBy defaults ──

    @Test
    public void search_nullSortBy_setsNewest() {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setSortBy(null);
        when(protocolDao.search(any())).thenReturn(new PaginatedResult<>(Collections.emptyList(), 0, 12, 0));

        protocolService.search(filter);

        assertEquals(ProtocolFilter.SortBy.NEWEST, filter.getSortBy());
    }

    @Test
    public void search_validSortBy_unchanged() {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setSortBy(ProtocolFilter.SortBy.RATING);
        when(protocolDao.search(any())).thenReturn(new PaginatedResult<>(Collections.emptyList(), 0, 12, 0));

        protocolService.search(filter);

        assertEquals(ProtocolFilter.SortBy.RATING, filter.getSortBy());
    }

    // ── search: pageSize clamping ──

    @Test
    public void search_pageSizeExceedsMax_clampedTo50() {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setPageSize(100);
        when(protocolDao.search(any())).thenReturn(new PaginatedResult<>(Collections.emptyList(), 0, 50, 0));

        protocolService.search(filter);

        assertEquals(50, filter.getPageSize());
    }

    @Test
    public void search_pageSizeZero_setsDefault() {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setPageSize(0);
        when(protocolDao.search(any())).thenReturn(new PaginatedResult<>(Collections.emptyList(), 0, 12, 0));

        protocolService.search(filter);

        assertEquals(12, filter.getPageSize());
    }

    @Test
    public void search_pageSizeNegative_setsDefault() {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setPageSize(-5);
        when(protocolDao.search(any())).thenReturn(new PaginatedResult<>(Collections.emptyList(), 0, 12, 0));

        protocolService.search(filter);

        assertEquals(12, filter.getPageSize());
    }

    @Test
    public void search_pageSizeWithinRange_unchanged() {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setPageSize(25);
        when(protocolDao.search(any())).thenReturn(new PaginatedResult<>(Collections.emptyList(), 0, 25, 0));

        protocolService.search(filter);

        assertEquals(25, filter.getPageSize());
    }

    // ── search: delegation ──

    @Test
    public void search_delegatesToDao() {
        final ProtocolFilter filter = new ProtocolFilter();
        final PaginatedResult<Protocol> expected = new PaginatedResult<>(
                List.of(buildProtocol()), 0, 12, 1
        );
        when(protocolDao.search(filter)).thenReturn(expected);

        final PaginatedResult<Protocol> result = protocolService.search(filter);

        assertSame(expected, result);
        verify(protocolDao).search(filter);
    }

    @Test
    public void search_passesFilterToDao() {
        final ProtocolFilter filter = new ProtocolFilter();
        filter.setQuery("creatine");
        filter.setPage(2);
        when(protocolDao.search(any())).thenReturn(new PaginatedResult<>(Collections.emptyList(), 2, 12, 0));

        protocolService.search(filter);

        final ArgumentCaptor<ProtocolFilter> captor = ArgumentCaptor.forClass(ProtocolFilter.class);
        verify(protocolDao).search(captor.capture());
        assertEquals("creatine", captor.getValue().getQuery());
        assertEquals(2, captor.getValue().getPage());
    }

    // ── findById ──

    @Test
    public void findById_existing_returnsProtocol() {
        final Protocol protocol = buildProtocol();
        when(protocolDao.findById(PROTOCOL_ID)).thenReturn(Optional.of(protocol));

        final Optional<Protocol> result = protocolService.findById(PROTOCOL_ID);

        assertTrue(result.isPresent());
        assertSame(protocol, result.get());
    }

    @Test
    public void findById_nonExisting_returnsEmpty() {
        final UUID id = UUID.randomUUID();
        when(protocolDao.findById(id)).thenReturn(Optional.empty());

        final Optional<Protocol> result = protocolService.findById(id);

        assertTrue(result.isEmpty());
    }

    // ── getAllTags ──

    @Test
    public void getAllTags_delegatesToDao() {
        final List<String> tags = List.of("sleep", "nootropics", "cold");
        when(protocolDao.findAllTags()).thenReturn(tags);

        final List<String> result = protocolService.getAllTags();

        assertSame(tags, result);
        verify(protocolDao).findAllTags();
    }

    @Test
    public void getAllTags_emptyList_returnsEmpty() {
        when(protocolDao.findAllTags()).thenReturn(Collections.emptyList());

        final List<String> result = protocolService.getAllTags();

        assertTrue(result.isEmpty());
    }
}
