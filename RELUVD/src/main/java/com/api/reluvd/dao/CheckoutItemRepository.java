package com.api.reluvd.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.api.reluvd.model.CheckoutItem;

public interface CheckoutItemRepository  extends JpaRepository<CheckoutItem, Integer> {
	List<CheckoutItem> findByListing_Id(int listingId);
}


