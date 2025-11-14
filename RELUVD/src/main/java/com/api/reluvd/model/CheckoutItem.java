package com.api.reluvd.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;

@Entity
public class CheckoutItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "checkout_id")
    private CheckoutSession checkoutSession;

    @OneToOne  
    private Listings listing;
    @Column(name = "email_sent")
    private boolean emailSent;
    
	public boolean isEmailSent() {
		return emailSent;
	}

	public void setEmailSent(boolean emailSent) {
		this.emailSent = emailSent;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public CheckoutSession getCheckoutSession() {
		return checkoutSession;
	}

	public void setCheckoutSession(CheckoutSession checkoutSession) {
		this.checkoutSession = checkoutSession;
	}

	public Listings getListing() {
		return listing;
	}

	public void setListing(Listings listing) {
		this.listing = listing;
	}

	public CheckoutItem(int id, CheckoutSession checkoutSession, Listings listing) {
		super();
		this.id = id;
		this.checkoutSession = checkoutSession;
		this.listing = listing;
	}

	public CheckoutItem() {
		super();
	}
}
