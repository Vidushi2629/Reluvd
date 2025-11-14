package com.api.reluvd.model;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;

@Entity
public class RazorpayPayment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne
    @JoinColumn(name = "checkout_id")
    private CheckoutSession checkoutSession;

    private String razorpayOrderId;     
    private String razorpayPaymentId;   
    private String razorpaySignature;  
    private boolean paymentVerified; 
    private String paymentStatus;
    private LocalDateTime paidAt;
    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
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
	public String getRazorpayOrderId() {
		return razorpayOrderId;
	}
	public void setRazorpayOrderId(String razorpayOrderId) {
		this.razorpayOrderId = razorpayOrderId;
	}
	public String getRazorpayPaymentId() {
		return razorpayPaymentId;
	}
	public void setRazorpayPaymentId(String razorpayPaymentId) {
		this.razorpayPaymentId = razorpayPaymentId;
	}
	public String getRazorpaySignature() {
		return razorpaySignature;
	}
	public void setRazorpaySignature(String razorpaySignature) {
		this.razorpaySignature = razorpaySignature;
	}
	public boolean isPaymentVerified() {
		return paymentVerified;
	}
	public void setPaymentVerified(boolean paymentVerified) {
		this.paymentVerified = paymentVerified;
	}
	public String getPaymentStatus() {
		return paymentStatus;
	}
	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}
	public RazorpayPayment(int id, CheckoutSession checkoutSession, String razorpayOrderId, String razorpayPaymentId,
			String razorpaySignature, boolean paymentVerified, String paymentStatus) {
		super();
		this.id = id;
		this.checkoutSession = checkoutSession;
		this.razorpayOrderId = razorpayOrderId;
		this.razorpayPaymentId = razorpayPaymentId;
		this.razorpaySignature = razorpaySignature;
		this.paymentVerified = paymentVerified;
		this.paymentStatus = paymentStatus;
	}
	public RazorpayPayment() {
		super();
		// TODO Auto-generated constructor stub
	}  
}
