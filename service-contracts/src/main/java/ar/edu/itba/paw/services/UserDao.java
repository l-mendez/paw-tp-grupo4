package ar.edu.itba.paw.services;

import ar.edu.itba.paw.models.User;

import java.util.Optional;

public interface UserDao {
    Optional<User> findByEmail(String email);
    User create(String email, String username);
}
