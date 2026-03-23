package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User findOrCreate(final String email) {
        return userDao.findByEmail(email)
                .orElseGet(() -> userDao.create(email, email.split("@")[0]));
    }

    @Override
    public Optional<User> findByEmail(final String email) {
        return userDao.findByEmail(email);
    }
}
