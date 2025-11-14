package com.api.reluvd.service;

import com.api.reluvd.dao.MenuMasterRepository;
import com.api.reluvd.model.MenuMaster;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuService {

    @Autowired
    private MenuMasterRepository menuRepo;

    public List<MenuMaster> getMenusByRole(String role) {
        return menuRepo.findByRole(role);
    }
}
