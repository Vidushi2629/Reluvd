package com.api.reluvd.model;


import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Transient;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@Entity
public class Listings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @NotBlank
    private String imageUrl;
    @NotBlank
    private String title;
    @NotBlank
    private String clothingType;
    @NotBlank
    private String size;
    @NotBlank
    private String color;
    @NotBlank
    private String brand;
    @NotBlank
    private String material;
    @NotBlank
    private String gender;
    @NotBlank
    @Column(name = "`condition`")
    private String condition;
    @NotNull
    @Min(0)
    private double price;
    @NotBlank
    @Column(columnDefinition = "TEXT")
    private String description;


    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; 
    @Column(nullable = false)
    private String status = "Pending"; 
    
    private LocalDateTime createdAt;

    @Column(name = "rejection_note")
    private String rejectionNote;
    @NotBlank
    private String availability ="Available";
    @Column(name = "sold_at")
    private LocalDateTime soldAt;
    @Transient
    private String deliveryStatus;

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }


    public LocalDateTime getSoldAt() {
        return soldAt;
    }

    public void setSoldAt(LocalDateTime soldAt) {
        this.soldAt = soldAt;
    }
    

	public Listings(int id, @NotBlank String imageUrl, @NotBlank String title, @NotBlank String clothingType,
			@NotBlank String size, @NotBlank String color, @NotBlank String brand, @NotBlank String material,
			@NotBlank String gender, @NotBlank String condition, @NotNull @Min(0) double price,
			@NotBlank String description, User user, String status, LocalDateTime createdAt, String rejectionNote,
			@NotBlank String availability) {
		super();
		this.id = id;
		this.imageUrl = imageUrl;
		this.title = title;
		this.clothingType = clothingType;
		this.size = size;
		this.color = color;
		this.brand = brand;
		this.material = material;
		this.gender = gender;
		this.condition = condition;
		this.price = price;
		this.description = description;
		this.user = user;
		this.status = status;
		this.createdAt = createdAt;
		this.rejectionNote = rejectionNote;
		this.availability = availability;
	}

	public String getAvailability() {
		return availability;
	}

	public void setAvailability(String availability) {
		this.availability = availability;
	}

	public String getRejectionNote() {
		return rejectionNote;
	}

	public void setRejectionNote(String rejectionNote) {
		this.rejectionNote = rejectionNote;
	}

	@PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
    public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getMaterial() {
		return material;
	}

	public void setMaterial(String material) {
		this.material = material;
	}

	public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getClothingType() {
		return clothingType;
	}

	public void setClothingType(String clothingType) {
		this.clothingType = clothingType;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	public Listings() {
		super();
		// TODO Auto-generated constructor stub
	}

    
}
