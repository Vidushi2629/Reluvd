package com.api.reluvd.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;

@Entity
public class CheckoutSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int checkoutId;

    @ManyToOne
    private User user; //buyer

    @OneToMany(mappedBy = "checkoutSession", cascade = CascadeType.ALL)
    private List<CheckoutItem> checkoutItems = new ArrayList<>();


    @ManyToOne
    private Address address;

    private String promoCode;
    private double discount;
    private double total;
    private String deliveryInstructions;
    @OneToOne(mappedBy = "checkoutSession", cascade = CascadeType.ALL)
    private RazorpayPayment razorpayPayment;
    private LocalDateTime placedAt;
    public LocalDateTime getPlacedAt() {
        return placedAt;
    }

    public void setPlacedAt(LocalDateTime placedAt) {
        this.placedAt = placedAt;
    }


    public int getCheckoutId() {
        return checkoutId;
    }

    public void setCheckoutId(int checkoutId) {
        this.checkoutId = checkoutId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

  

    public List<CheckoutItem> getCheckoutItems() {
		return checkoutItems;
	}

	public void setCheckoutItems(List<CheckoutItem> checkoutItems) {
		this.checkoutItems = checkoutItems;
	}

	public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getDeliveryInstructions() {
        return deliveryInstructions;
    }

    public void setDeliveryInstructions(String deliveryInstructions) {
        this.deliveryInstructions = deliveryInstructions;
    }

    public CheckoutSession() {
        super();
    }

	public RazorpayPayment getRazorpayPayment() {
		return razorpayPayment;
	}

	public void setRazorpayPayment(RazorpayPayment razorpayPayment) {
		this.razorpayPayment = razorpayPayment;
	}

	public CheckoutSession(int checkoutId, User user, List<CheckoutItem> checkoutItems, Address address,
			String promoCode, double discount, double total, String deliveryInstructions,
			RazorpayPayment razorpayPayment) {
		super();
		this.checkoutId = checkoutId;
		this.user = user;
		this.checkoutItems = checkoutItems;
		this.address = address;
		this.promoCode = promoCode;
		this.discount = discount;
		this.total = total;
		this.deliveryInstructions = deliveryInstructions;
		this.razorpayPayment = razorpayPayment;
	}

	

	
}
