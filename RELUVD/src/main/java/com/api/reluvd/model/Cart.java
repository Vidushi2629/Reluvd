package com.api.reluvd.model;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Cart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "listing_id")
    private Listings listing;

    private boolean isSavedForLater = false;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Listings getListing() {
		return listing;
	}

	public void setListing(Listings listing) {
		this.listing = listing;
	}

	public boolean isSavedForLater() {
		return isSavedForLater;
	}

	public void setSavedForLater(boolean isSavedForLater) {
		this.isSavedForLater = isSavedForLater;
	}

	public Cart(int id, User user, Listings listing, boolean isSavedForLater) {
		super();
		this.id = id;
		this.user = user;
		this.listing = listing;
		this.isSavedForLater = isSavedForLater;
	}

	public Cart() {
		super();
		// TODO Auto-generated constructor stub
	}
    
}
