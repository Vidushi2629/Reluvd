package com.api.reluvd.dao;

import java.util.Optional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.api.reluvd.model.User;

public interface UserRepository extends CrudRepository<User,Integer> {
	long count();
	boolean existsByEmail(String email);
	boolean existsByEmailAndPassword(String email, String password);
	User findByEmail(String email);
	User getUserById(int id);
	@Query("SELECT u FROM User u LEFT JOIN FETCH u.addresses WHERE u.id = :id")
	User findByIdWithAddresses(@Param("id") int id);
	 boolean existsByUsername(String username);
	 boolean existsByUsernameIgnoreCaseAndIdNot(String username, int id);
	 Optional<User> findByUsername(String username);
	    @Modifying
	    @Transactional
	    @Query("UPDATE User u SET u.status = 'D' WHERE u.id = :id")
	    void deactivateUserById(@Param("id") int id);

}

