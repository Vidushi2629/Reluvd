package com.api.reluvd.model;

import jakarta.persistence.*;

@Entity
@Table(name = "menu_master")
public class MenuMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String url;
    @Column(nullable = false)
    private String icon;

    @Column(nullable = false)
    private String role = "User"; 

  
    public MenuMaster() {}


    public MenuMaster(String name, String url, String icon, String role) {
        this.name = name;
        this.url = url;
        this.icon = icon;
        this.role = role;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
