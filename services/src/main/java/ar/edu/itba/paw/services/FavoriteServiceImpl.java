package ar.edu.itba.paw.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@Transactional(readOnly = true)
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteDao favoriteDao;

    @Autowired
    public FavoriteServiceImpl(final FavoriteDao favoriteDao) {
        this.favoriteDao = favoriteDao;
    }

    @Override
    public boolean isFavorited(final UUID protocolId, final UUID userId) {
        return favoriteDao.exists(protocolId, userId);
    }

    @Override
    @Transactional
    public void toggle(final UUID protocolId, final UUID userId) {
        if (favoriteDao.exists(protocolId, userId)) {
            favoriteDao.delete(protocolId, userId);
        } else {
            favoriteDao.create(protocolId, userId);
        }
    }
}
