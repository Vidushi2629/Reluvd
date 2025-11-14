package com.api.reluvd.controllers;

import com.api.reluvd.model.MenuMaster;
import com.api.reluvd.service.MenuService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

import java.util.List;

@Controller
public class MenuController {

    @Autowired
    private MenuService menuService;

    @GetMapping("/load-sidebar")
    public String loadSidebar(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");

        if (role == null) {
            role = "Guest";
        }

        List<MenuMaster> menus = menuService.getMenusByRole(role);
        model.addAttribute("menus", menus);
        return "includes/sidebar";
    }
  
}
