package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.PaginatedResult;
import ar.edu.itba.paw.models.Protocol;
import ar.edu.itba.paw.models.ProtocolFilter;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ProtocolDao {
    PaginatedResult<Protocol> search(ProtocolFilter filter);
    Optional<Protocol> findById(UUID id);
    List<String> findAllTags();
}
