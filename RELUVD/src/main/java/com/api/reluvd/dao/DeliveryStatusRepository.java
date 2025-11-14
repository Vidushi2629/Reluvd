package com.api.reluvd.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.api.reluvd.model.DeliveryStatus;

public interface DeliveryStatusRepository extends JpaRepository<DeliveryStatus, Integer> {
}
