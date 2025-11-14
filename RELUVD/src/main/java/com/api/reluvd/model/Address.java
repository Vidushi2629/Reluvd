package com.api.reluvd.model;
import jakarta.validation.constraints.NotBlank;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Address {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
	@NotBlank
	private String addressType;
	@NotBlank
    private String firstName;
	@NotBlank
    private String lastName;

	@NotBlank
    private String flatNumber;
	@NotBlank
	private String buildingName;
	private String landmark;
	@NotBlank
    private String street;
	@NotBlank
    private String city;
	@NotBlank
    private String state;
	@NotBlank
    private String zipcode;
	@NotBlank
    private String country;
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
	public String getAddressType() {
		return addressType;
	}
	public void setAddressType(String addressType) {
		this.addressType = addressType;
	}
	public String getLandmark() {
		return landmark;
	}
	public void setLandmark(String landmark) {
		this.landmark = landmark;
	}
	public int getId() {
	    return id;
	}
	public void setId(int id) {
	    this.id = id;
	}

	public String getBuildingName() {
		return buildingName;
	}
	public void setBuildingName(String buildingName) {
		this.buildingName = buildingName;
	}
    public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Address() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	public Address(int id, @NotBlank String addressType, @NotBlank String firstName, @NotBlank String lastName,
			@NotBlank String flatNumber, @NotBlank String buildingName, String landmark, @NotBlank String street,
			@NotBlank String city, @NotBlank String state, @NotBlank String zipcode, @NotBlank String country,
			User user) {
		super();
		this.id = id;
		this.addressType = addressType;
		this.firstName = firstName;
		this.lastName = lastName;
		this.flatNumber = flatNumber;
		this.buildingName = buildingName;
		this.landmark = landmark;
		this.street = street;
		this.city = city;
		this.state = state;
		this.zipcode = zipcode;
		this.country = country;
		this.user = user;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}

    
	// Getters and Setters
    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFlatNumber() {
        return flatNumber;
    }
    public void setFlatNumber(String flatNumber) {
        this.flatNumber = flatNumber;
    }

    public String getStreet() {
        return street;
    }
    public void setStreet(String street) {
        this.street = street;
    }

    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }
    public void setState(String state) {
        this.state = state;
    }

    public String getZipcode() {
        return zipcode;
    }
    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    
}
