package com.api.reluvd.controllers;

import com.api.reluvd.model.User;
import com.api.reluvd.model.Address;
import com.api.reluvd.model.CheckoutItem;
import com.api.reluvd.model.CheckoutSession;
import com.api.reluvd.model.DeliveryStatus;
import com.api.reluvd.model.Listings;
import com.api.reluvd.model.RazorpayPayment;
import com.api.reluvd.service.CartService;
import com.api.reluvd.service.EmailService;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.Utils;
import com.api.reluvd.dao.AddressRepository;
import com.api.reluvd.dao.CheckoutSessionRepository;
import com.api.reluvd.dao.ListingsRepository;
import com.api.reluvd.dao.RazorpayPaymentRepository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Hex; 

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;
    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private EmailService emailService;

    @Autowired
    private ListingsRepository listingRepo;
    @Autowired
    private CheckoutSessionRepository checkoutSessionRepository;
    
    @Autowired
    private RazorpayPaymentRepository razorpayPaymentRepository;
    
    @Autowired
    private AddressRepository addressRepository;

    @GetMapping
    public String showCart(@SessionAttribute(name = "user", required = false) User user,
                           HttpSession session,
                           Model model) {

        List<Listings> cartItems = new ArrayList<>();
        List<Listings> savedItems = new ArrayList<>();
        double subtotal = 0;

        if (user != null) {
            cartItems = cartService.getCartItems(user);
            savedItems = cartService.getSavedItems(user);
        } else {
            cartItems = (List<Listings>) session.getAttribute("guestCart");
            savedItems = (List<Listings>) session.getAttribute("guestSaved");

            if (cartItems == null) cartItems = new ArrayList<>();
            if (savedItems == null) savedItems = new ArrayList<>();
        }

        subtotal = cartItems.stream().mapToDouble(Listings::getPrice).sum();

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("savedItems", savedItems);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("total", subtotal);

        return "my-cart";
    }

    @PostMapping("/save")
    public String saveForLater(@RequestParam("listingId") int listingId,
                               @SessionAttribute(name = "user", required = false) User user,
                               HttpSession session) {

        Listings listing = listingRepo.findById(listingId).orElse(null);
        if (listing == null) return "redirect:/cart";

        if (user != null) {
            cartService.saveForLater(user, listing);
        } else {
            List<Listings> guestCart = (List<Listings>) session.getAttribute("guestCart");
            List<Listings> guestSaved = (List<Listings>) session.getAttribute("guestSaved");
            if (guestCart == null) guestCart = new ArrayList<>();
            if (guestSaved == null) guestSaved = new ArrayList<>();

            guestCart.removeIf(l -> l.getId() == listing.getId());
            if (guestSaved.stream().noneMatch(l -> l.getId() == listing.getId()))
                guestSaved.add(listing);

            session.setAttribute("guestCart", guestCart);
            session.setAttribute("guestSaved", guestSaved);
        }

        return "redirect:/cart";
    }
    @PostMapping("/add-to-cart")
    @ResponseBody
    public String addToCart(@RequestBody Map<String, Object> payload,
                            @SessionAttribute(name = "user", required = false) User user,
                            HttpSession session) {

        int listingId = (int) payload.get("listingId");

        Listings listing = listingRepo.findById(listingId).orElse(null);
        if (listing == null) return "Listing not found";

        if (user != null) {
            cartService.addToCart(user, listing);
        } else {
            List<Listings> guestCart = (List<Listings>) session.getAttribute("guestCart");
            List<Listings> guestSaved = (List<Listings>) session.getAttribute("guestSaved");

            if (guestCart == null) guestCart = new ArrayList<>();
            if (guestSaved == null) guestSaved = new ArrayList<>();

            guestSaved.removeIf(l -> l.getId() == listing.getId());
            if (guestCart.stream().noneMatch(l -> l.getId() == listing.getId()))
                guestCart.add(listing);

            session.setAttribute("guestCart", guestCart);
            session.setAttribute("guestSaved", guestSaved);
        }

        return "Item added to cart";
    }

    @PostMapping("/move-to-cart")
    public String moveToCart(@RequestParam("listingId") int listingId,
                             @SessionAttribute(name = "user", required = false) User user,
                             HttpSession session) {

        Listings listing = listingRepo.findById(listingId).orElse(null);
        if (listing == null) return "redirect:/cart";

        if (user != null) {
            cartService.moveToCart(user, listing);
        } else {
            List<Listings> guestCart = (List<Listings>) session.getAttribute("guestCart");
            List<Listings> guestSaved = (List<Listings>) session.getAttribute("guestSaved");
            if (guestCart == null) guestCart = new ArrayList<>();
            if (guestSaved == null) guestSaved = new ArrayList<>();

            guestSaved.removeIf(l -> l.getId() == listing.getId());
            if (guestCart.stream().noneMatch(l -> l.getId() == listing.getId()))
                guestCart.add(listing);

            session.setAttribute("guestCart", guestCart);
            session.setAttribute("guestSaved", guestSaved);
        }

        return "redirect:/cart";
    }

    @PostMapping("/delete")
    public String deleteItem(@RequestParam("listingId") int listingId,
                             @SessionAttribute(name = "user", required = false) User user,
                             HttpSession session) {

        Listings listing = listingRepo.findById(listingId).orElse(null);
        if (listing == null) return "redirect:/cart";

        if (user != null) {
            cartService.deleteItem(user, listing);
        } else {
            List<Listings> guestCart = (List<Listings>) session.getAttribute("guestCart");
            List<Listings> guestSaved = (List<Listings>) session.getAttribute("guestSaved");
            if (guestCart == null) guestCart = new ArrayList<>();
            if (guestSaved == null) guestSaved = new ArrayList<>();

            guestCart.removeIf(l -> l.getId() == listing.getId());
            guestSaved.removeIf(l -> l.getId() == listing.getId());

            session.setAttribute("guestCart", guestCart);
            session.setAttribute("guestSaved", guestSaved);
        }

        return "redirect:/cart";
    }
    @GetMapping("/proceed-to-buy")
    public String proceedToBuy(@SessionAttribute(name = "user", required = false) User user,
                               HttpSession session, Model model) {

        if (user == null) {
            session.setAttribute("redirectAfterLogin", "/cart/proceed-to-buy");
            return "redirect:/login";
        }

        List<Listings> cartItems = cartService.getCartItems(user);
        double subtotal = cartItems.stream().mapToDouble(Listings::getPrice).sum();

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("total", subtotal);

        return "checkout";
    }

    @RequestMapping(value = "/buy-now", method = {RequestMethod.GET, RequestMethod.POST})
    public String buyNow(@RequestParam("itemId") int itemId, Model model,
                         @SessionAttribute(name = "user", required = false) User user,
                         HttpSession session) {

        if (user == null) {
            session.setAttribute("redirectAfterLogin", "/view-item/" + itemId);
            return "redirect:/login";
        }

        Listings item = listingRepo.findById(itemId).orElse(null);
        if (item == null) return "redirect:/";

        model.addAttribute("cartItems", List.of(item));
        model.addAttribute("subtotal", item.getPrice());
        model.addAttribute("total", item.getPrice());

        return "checkout";
    }


    @PostMapping("/address")
    public String address(@RequestParam(required = false) Integer itemId,
                          @RequestParam("promoCode") String promoCode,
                          @RequestParam("discount") double discount,
                          @RequestParam("total") double total,
                          Model model,
                          @SessionAttribute(name = "user", required = false) User user) {

        if (user == null) return "redirect:/login";

        model.addAttribute("promoCode", promoCode);
        model.addAttribute("discount", discount);
        model.addAttribute("total", total);
        model.addAttribute("addresses", addressRepository.findByUser(user));
        if (itemId != null) model.addAttribute("itemId", itemId);

        return "address";
    }
    @PostMapping("/go-to-payment")
    public String goToPayment(@RequestParam(required = false) Integer itemId,
                              @RequestParam("promoCode") String promoCode,
                              @RequestParam("discount") double discount,
                              @RequestParam("total") double total,
                              @RequestParam("addressId") int addressId,
                              @RequestParam("deliveryInstructions") String instructions,
                              Model model,
                              @SessionAttribute(name = "user", required = false) User user) {

        if (user == null) return "redirect:/login";

        Address address = addressRepository.findById(addressId).orElse(null);
        if (address == null) return "redirect:/cart";

        model.addAttribute("promoCode", promoCode);
        model.addAttribute("discount", discount);
        model.addAttribute("total", total);
        model.addAttribute("address", address);
        model.addAttribute("addressId", addressId);
        model.addAttribute("deliveryInstructions", instructions);
        if (itemId != null) model.addAttribute("itemId", itemId);

        return "payment"; 
    }
    @PostMapping("/payment")
    public String checkout3(
            @RequestParam(required = false) Integer itemId,
            @RequestParam("promoCode") String promoCode,
            @RequestParam("discount") double discount,
            @RequestParam("total") double total,
            @RequestParam("addressId") int addressId,
            @RequestParam("deliveryInstructions") String instructions,
            @RequestParam("razorpay_order_id") String razorpayOrderId,
            @RequestParam("razorpay_payment_id") String razorpayPaymentId,
            @RequestParam("razorpay_signature") String razorpaySignature,
            Model model,
            @SessionAttribute(name = "user", required = false) User user,
            HttpSession session) {

        if (user == null) return "redirect:/login";

        Address address = addressRepository.findById(addressId).orElse(null);
        if (address == null) return "redirect:/cart";

        // Step 1: Signature verification
        String secret = "WYRsN0QrgiSezqK7oG0tEc87";
        boolean isValid = false;
        try {
            String payload = razorpayOrderId + "|" + razorpayPaymentId;
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(secret.getBytes(), "HmacSHA256");
            sha256_HMAC.init(secretKey);
            byte[] hash = sha256_HMAC.doFinal(payload.getBytes());
            String generatedSignature = Hex.encodeHexString(hash);
            isValid = generatedSignature.equals(razorpaySignature);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "An error occurred during payment verification.");
            return "error-page";
        }

        if (!isValid) {
            model.addAttribute("error", "Invalid payment signature.");
            return "error-page";
        }

        // Step 2: Perform transactional checkout
        CheckoutSession checkout;
        List<Listings> cartItems = null;
        Listings singleItem = null;

        boolean isCartCheckout = (itemId == null);
        if (isCartCheckout) {
            cartItems = cartService.getCartItems(user);
            if (cartItems.isEmpty()) {
                model.addAttribute("error", "Your cart is empty.");
                return "error-page";
            }
        } else {
            singleItem = listingRepo.findById(itemId).orElse(null);
            if (singleItem == null) {
                model.addAttribute("error", "Item not found.");
                return "error-page";
            }
        }

        try {
            checkout = cartService.performCheckoutTransactional(
                    user,
                    address,
                    promoCode,
                    discount,
                    total,
                    instructions,
                    razorpayOrderId,
                    razorpayPaymentId,
                    razorpaySignature,
                    singleItem,
                    cartItems,
                    isCartCheckout
            );
        } catch (Exception e) {
            e.printStackTrace();
            // Step 3: Refund on failure
            try {
                RazorpayClient razorpay = new RazorpayClient("rzp_test_eMM0dZQkGmn9wv", secret);
                JSONObject refundRequest = new JSONObject();
                refundRequest.put("payment_id", razorpayPaymentId);
                refundRequest.put("amount", (int)(total * 100));
                razorpay.payments.refund(refundRequest);
                model.addAttribute("error", "System error occurred. Amount has been refunded.");
            } catch (Exception refundEx) {
                refundEx.printStackTrace();
                model.addAttribute("error", "System error and refund failed.");
            }
            return "error-page";
        }

        // Step 4: Notify sellers
        Map<User, List<Listings>> sellerToListings = new HashMap<>();
        for (CheckoutItem ci : checkout.getCheckoutItems()) {
            Listings listing = ci.getListing();
            User seller = listing.getUser();
            if (seller != null) {
                sellerToListings.computeIfAbsent(seller, k -> new ArrayList<>()).add(listing);
            }
        }

        User buyer = user;
        for (Map.Entry<User, List<Listings>> entry : sellerToListings.entrySet()) {
            User seller = entry.getKey();
            List<Listings> soldItems = entry.getValue();

            if (seller.getEmail() != null) {
                String subject = "You've made a sale on ReLuvd!";
                String itemList = soldItems.stream().map(Listings::getTitle).collect(Collectors.joining(", "));

                String message = "Hi " + seller.getUsername() + ",\n\n" +
                        "Congratulations! The following item(s) you listed on ReLuvd have just been purchased:\n" +
                        itemList + ".\n\n" +
                        "Please get in touch with the buyer at: " + buyer.getEmail() + " to coordinate the delivery.\n\n" +
                        "Kindly ensure the item(s) are properly packed and delivered on time to maintain a great experience for the buyer.\n\n" +
                        "Thank you for being a valued part of the ReLuvd community.\n\n" +
                        "Warm regards,\nThe ReLuvd Team\nBecause OLD is the new NEW!";

                emailService.sendEmail(subject, message, seller.getEmail());
            }
        }

        // Step 5: Notify buyer
        if (buyer.getEmail() != null) {
            String subject = "Your ReLuvd Order Confirmation";
            String itemList = checkout.getCheckoutItems().stream()
                    .map(ci -> ci.getListing().getTitle())
                    .collect(Collectors.joining(", "));

            String message = "Hi " + buyer.getUsername() + ",\n\n" +
                    "Thank you for your purchase on ReLuvd!\n\n" +
                    "We have received your order for the following item(s): " + itemList + "\n\n" +
                    "Our sellers have been notified and will get in touch with you shortly to deliver the products.\n\n" +
                    "If you have any questions, feel free to reply to this email.\n\n" +
                    "Warm regards,\nThe ReLuvd Team\nBecause OLD is the new NEW!";

            emailService.sendEmail(subject, message, buyer.getEmail());
        }

        return "redirect:/cart/complete?sessionId=" + checkout.getCheckoutId();
    }

    @GetMapping("/complete")
    public String complete(@RequestParam("sessionId") int sessionId,
                           @SessionAttribute(name = "user", required = false) User user,
                           Model model) {

        if (user == null) return "redirect:/login";

        CheckoutSession checkout = checkoutSessionRepository.findById(sessionId).orElse(null);
        if (checkout == null) return "redirect:/cart";

        model.addAttribute("promoCode", checkout.getPromoCode());
        model.addAttribute("discount", checkout.getDiscount());
        model.addAttribute("total", checkout.getTotal());
        model.addAttribute("instructions", checkout.getDeliveryInstructions());
        model.addAttribute("address", checkout.getAddress());

        return "order-confirmation";
    }
    @PostMapping("/create-order")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createOrder(
            @RequestBody Map<String, Object> payload,
            @SessionAttribute(name = "user", required = false) User user) {
        try {
            double amount = Double.parseDouble(payload.get("amount").toString());

            RazorpayClient client = new RazorpayClient("rzp_test_eMM0dZQkGmn9wv", "WYRsN0QrgiSezqK7oG0tEc87");

            JSONObject options = new JSONObject();
            options.put("amount", (int) amount);
            options.put("currency", "INR");
            options.put("receipt", "txn_" + user.getId() + "_" + System.currentTimeMillis());


            Order order = client.orders.create(options);

            Map<String, Object> resp = new HashMap<>();
            resp.put("orderId", order.get("id"));
            resp.put("amount", order.get("amount"));
            resp.put("currency", order.get("currency"));

            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                 .body(Map.of("error", "Order creation failed"));
        }
    }
    @PostMapping("/proceed-to-buy")
    public String proceedToBuy(
            @RequestParam("selectedItems") List<Integer> selectedItemIds,
            @SessionAttribute(name = "user", required = false) User user,
            HttpSession session,
            Model model) {

        if (user == null) {
            session.setAttribute("redirectAfterLogin", "/cart/proceed-to-buy");
            return "redirect:/login";
        }

        List<Listings> selectedCartItems = selectedItemIds.stream()
                .map(id -> listingRepo.findById(id).orElse(null))
                .filter(item -> item != null)
                .collect(Collectors.toList());

        double subtotal = selectedCartItems.stream().mapToDouble(Listings::getPrice).sum();

        model.addAttribute("cartItems", selectedCartItems);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("total", subtotal);

        return "checkout"; // Make sure this points to your correct JSP/Thymeleaf view
    }


}
