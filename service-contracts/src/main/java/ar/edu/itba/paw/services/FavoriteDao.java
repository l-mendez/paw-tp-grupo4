package ar.edu.itba.paw.services;

import java.util.UUID;

public interface FavoriteDao {
    boolean exists(UUID protocolId, UUID userId);
    void create(UUID protocolId, UUID userId);
    void delete(UUID protocolId, UUID userId);
}
