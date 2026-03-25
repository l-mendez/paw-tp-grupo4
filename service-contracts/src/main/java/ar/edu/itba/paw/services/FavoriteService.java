package ar.edu.itba.paw.services;

import java.util.UUID;

public interface FavoriteService {
    boolean isFavorited(UUID protocolId, UUID userId);
    void toggle(UUID protocolId, UUID userId);
}
