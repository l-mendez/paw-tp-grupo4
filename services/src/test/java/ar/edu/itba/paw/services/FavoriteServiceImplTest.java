package ar.edu.itba.paw.services;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class FavoriteServiceImplTest {

    @Mock
    private FavoriteDao favoriteDao;

    @InjectMocks
    private FavoriteServiceImpl favoriteService;

    private static final UUID PROTOCOL_ID = UUID.randomUUID();
    private static final UUID USER_ID = UUID.randomUUID();

    @Test
    public void isFavorited_favorited_returnsTrue() {
        when(favoriteDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(true);
        assertTrue(favoriteService.isFavorited(PROTOCOL_ID, USER_ID));
    }

    @Test
    public void isFavorited_notFavorited_returnsFalse() {
        when(favoriteDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(false);
        assertFalse(favoriteService.isFavorited(PROTOCOL_ID, USER_ID));
    }

    @Test
    public void toggle_notFavorited_favorites() {
        when(favoriteDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(false);
        favoriteService.toggle(PROTOCOL_ID, USER_ID);
    }

    @Test
    public void toggle_favorited_unfavorites() {
        when(favoriteDao.exists(PROTOCOL_ID, USER_ID)).thenReturn(true);
        favoriteService.toggle(PROTOCOL_ID, USER_ID);
    }
}
