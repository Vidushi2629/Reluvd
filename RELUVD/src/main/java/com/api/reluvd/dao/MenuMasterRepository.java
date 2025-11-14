package com.api.reluvd.dao;
import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.api.reluvd.model.MenuMaster;
public interface MenuMasterRepository extends CrudRepository<MenuMaster, Integer> {
    List<MenuMaster> findByRole(String role);
}
