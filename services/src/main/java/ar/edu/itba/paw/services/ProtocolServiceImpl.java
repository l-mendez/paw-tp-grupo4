package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.PaginatedResult;
import ar.edu.itba.paw.models.Protocol;
import ar.edu.itba.paw.models.ProtocolFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class ProtocolServiceImpl implements ProtocolService {

    private final ProtocolDao protocolDao;

    @Autowired
    public ProtocolServiceImpl(final ProtocolDao protocolDao) {
        this.protocolDao = protocolDao;
    }

    @Override
    public PaginatedResult<Protocol> search(final ProtocolFilter filter) {
        if (filter.getSortBy() == null) {
            filter.setSortBy(ProtocolFilter.SortBy.NEWEST);
        }
        if (filter.getPageSize() > 50) {
            filter.setPageSize(50);
        }
        if (filter.getPageSize() < 1) {
            filter.setPageSize(12);
        }
        return protocolDao.search(filter);
    }

    @Override
    public Optional<Protocol> findById(final UUID id) {
        return protocolDao.findById(id);
    }

    @Override
    public List<String> getAllTags() {
        return protocolDao.findAllTags();
    }
}
