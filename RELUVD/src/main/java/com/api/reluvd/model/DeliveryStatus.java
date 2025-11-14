package com.api.reluvd.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class DeliveryStatus {
	    @Id
	    private int listingId;

	    private String status;  

	    public DeliveryStatus() {}

	    public DeliveryStatus(int listingId, String status) {
	        this.listingId = listingId;
	        this.status = status;
	    }

	    public int getListingId() {
	        return listingId;
	    }

	    public void setListingId(int listingId) {
	        this.listingId = listingId;
	    }

	    public String getStatus() {
	        return status;
	    }

	    public void setStatus(String status) {
	        this.status = status;
	    }
	}

