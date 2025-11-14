package com.api.reluvd.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.api.reluvd.model.CheckoutSession;
import com.api.reluvd.model.User;

public interface CheckoutSessionRepository extends JpaRepository<CheckoutSession, Integer> {
	   List<CheckoutSession> findByUser(User user);
}
