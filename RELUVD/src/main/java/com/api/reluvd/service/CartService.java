package com.api.reluvd.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.api.reluvd.dao.CartRepository;
import com.api.reluvd.dao.CheckoutSessionRepository;
import com.api.reluvd.dao.ListingsRepository;
import com.api.reluvd.dao.RazorpayPaymentRepository;
import com.api.reluvd.model.Address;
import com.api.reluvd.model.Cart;
import com.api.reluvd.model.CheckoutItem;
import com.api.reluvd.model.CheckoutSession;
import com.api.reluvd.model.DeliveryStatus;
import com.api.reluvd.model.Listings;
import com.api.reluvd.model.RazorpayPayment;
import com.api.reluvd.model.User;

import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;
    @Autowired
    private ListingsRepository listingRepo;
    @Autowired
    private CheckoutSessionRepository checkoutSessionRepository;

    @Autowired
    private RazorpayPaymentRepository razorpayPaymentRepository;

    @Autowired
    private RestTemplate restTemplate;

    public List<Listings> getCartItems(User user) {
        List<Cart> carts = cartRepository.findByUserAndIsSavedForLater(user, false);
        return carts.stream().map(Cart::getListing).collect(Collectors.toList());
    }

    public List<Listings> getSavedItems(User user) {
        List<Cart> carts = cartRepository.findByUserAndIsSavedForLater(user, true);
        return carts.stream().map(Cart::getListing).collect(Collectors.toList());
    }

    public void addToCart(User user, Listings listing) {
        Cart existing = cartRepository.findByUserAndListing(user, listing);
        if (existing == null) {
            Cart item = new Cart ();
            item.setUser(user);
            item.setListing(listing);
            item.setSavedForLater(false);
            cartRepository.save(item);
        } else if (existing.isSavedForLater()) {
            existing.setSavedForLater(false);
            cartRepository.save(existing);
        }
    }

    public void saveForLater(User user, Listings listing) {
        Cart item = cartRepository.findByUserAndListing(user, listing);
        if (item != null) {
            item.setSavedForLater(true);
        } else {
            item = new Cart();
            item.setUser(user);
            item.setListing(listing);
            item.setSavedForLater(true);
        }
        cartRepository.save(item);
    }


    public void moveToCart(User user, Listings listing) {
        Cart item = cartRepository.findByUserAndListing(user,listing);
        if (item != null) {
            item.setSavedForLater(false);
            cartRepository.save(item);
        }
    }
    @Transactional 
    public void deleteItem(User user,Listings listing) {
        cartRepository.deleteByUserAndListing(user, listing);
    }
    public void mergeGuestCartIntoUserCart(List<Listings> guestCart, User user) {
        if (guestCart == null) return;
        guestCart.forEach(listing -> addToCart(user, listing));
    }
    public void mergeGuestSavedIntoUserSaved(List<Listings> guestSaved, User user) {
        if (guestSaved == null || guestSaved.isEmpty()) return;

        List<Listings> userSaved = getSavedItems(user);

        for (Listings item : guestSaved) {
            boolean alreadySaved = userSaved.stream()
                    .anyMatch(saved -> saved.getId() == item.getId());
            if (!alreadySaved) {
                saveForLater(user, item);
            }
        }
    }
//adding new 
    @Transactional
    public CheckoutSession performCheckoutTransactional(
            User user,
            Address address,
            String promoCode,
            double discount,
            double total,
            String instructions,
            String razorpayOrderId,
            String razorpayPaymentId,
            String razorpaySignature,
            Listings singleItem,
            List<Listings> cartItems,
            boolean isCartCheckout
    ) {
        CheckoutSession checkout = new CheckoutSession();
        checkout.setUser(user);
        checkout.setAddress(address);
        checkout.setPromoCode(promoCode);
        checkout.setDiscount(discount);
        checkout.setTotal(total);
        checkout.setDeliveryInstructions(instructions);

        List<CheckoutItem> checkoutItems = new ArrayList<>();

        List<Listings> itemsToProcess = isCartCheckout ? cartItems : Collections.singletonList(singleItem);
        for (Listings item : itemsToProcess) {
            item.setAvailability("Sold");
            item.setSoldAt(LocalDateTime.now());
            listingRepo.save(item);

            DeliveryStatus status = new DeliveryStatus();
            status.setListingId(item.getId());
            status.setStatus("Placed");

            String deliveryAppUrl = "http://localhost:8081/ReLuvdDelivery/api/delivery/update";
            restTemplate.postForEntity(deliveryAppUrl, status, String.class);

            CheckoutItem checkoutItem = new CheckoutItem();
            checkoutItem.setCheckoutSession(checkout);
            checkoutItem.setListing(item);
            checkoutItems.add(checkoutItem);
        }

        checkout.setCheckoutItems(checkoutItems);
        checkout.setPlacedAt(LocalDateTime.now());
        checkout = checkoutSessionRepository.save(checkout);

        RazorpayPayment payment = new RazorpayPayment();
        payment.setCheckoutSession(checkout);
        payment.setRazorpayOrderId(razorpayOrderId);
        payment.setRazorpayPaymentId(razorpayPaymentId);
        payment.setRazorpaySignature(razorpaySignature);
        payment.setPaymentStatus("success");
        payment.setPaymentVerified(true);
        payment.setPaidAt(LocalDateTime.now());

        // Simulate failure for testing rollback
        // Remove/comment out this line in production
       // if (true) throw new RuntimeException("Simulated error after DB changes");

        razorpayPaymentRepository.save(payment);
        return checkout;
    }
    //till here


    }
