package com.api.reluvd.controllers;
 import com.api.reluvd.dao.CheckoutItemRepository;
import com.api.reluvd.dao.CheckoutSessionRepository;

import com.api.reluvd.model.CheckoutItem;
import com.api.reluvd.model.CheckoutSession;
import com.api.reluvd.model.DeliveryStatus;
import com.api.reluvd.model.Listings;
import com.api.reluvd.model.User;
import com.api.reluvd.service.EmailService;

import com.api.reluvd.service.HomeService;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
 import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
 import org.springframework.ui.Model;
 import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

 @Controller
 public class HomeController {
	 @Autowired
	 private CheckoutItemRepository checkoutItemRepository;

     @Autowired
     private HomeService homeService;
     @Autowired
     private EmailService emailService;
     @Autowired
     private CheckoutSessionRepository checkoutSessionRepository;
    
     @Autowired
     private RestTemplate restTemplate;

     @GetMapping("/home")
     public String showHomePage(
             @RequestParam(value = "query", required = false) String query,
             @RequestParam(value = "gender", required = false) String gender,
             @RequestParam(value = "type", required = false) String type,
             @RequestParam(value = "size", required = false) String size,
             @RequestParam(value = "condition", required = false) String condition,
             @RequestParam(value = "sort", required = false) String sort,
             @RequestParam(value = "material", required = false) String material,
             @RequestParam(value = "color", required = false) String color,
             @RequestParam(value = "brand", required = false) String brand,
             @RequestParam(value = "page", defaultValue = "1") int page,
             Model model
     ) {
         final int pageSize = 10;
         int currentPage = Math.max(0, page - 1);
         
         Page<Listings> listingsPage = homeService.getFilteredListingsPaginated(
                 query, gender, type, size, condition, material, color, brand,
                 sort, currentPage, pageSize
         );

         model.addAttribute("listings", listingsPage.getContent());
         model.addAttribute("currentPage", page);
         model.addAttribute("totalPages", listingsPage.getTotalPages());

         model.addAttribute("materials", homeService.getAllMaterials());
         model.addAttribute("brands", homeService.getAllBrands());
         model.addAttribute("colors", homeService.getAllColors());

         return "home";
     }

   
    @GetMapping("/sell-item")
    public String showSellItemPage(HttpSession session, Model model) {
        Object user = session.getAttribute("user");

        if (user == null) {
            return "redirect:/";
        }

        model.addAttribute("user", user);

        return "sell-item";
    }

    @GetMapping("/my-orders")
    public String showUserOrders(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        List<CheckoutSession> orders = checkoutSessionRepository.findByUser(user);

        Map<Integer, String> statusMap = new HashMap<>();

        for (CheckoutSession order : orders) {
            for (CheckoutItem item : order.getCheckoutItems()) {
                int listingId = item.getListing().getId();
                String itemTitle = item.getListing().getTitle();

                try {
                    ResponseEntity<DeliveryStatus> response = restTemplate.getForEntity(
                        "http://localhost:8081/ReLuvdDelivery/api/delivery/status/" + listingId,
                        DeliveryStatus.class
                    );

                    if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                        String status = response.getBody().getStatus();
                        statusMap.put(listingId, status);

                        if ("Out for Delivery".equalsIgnoreCase(status) && !item.isEmailSent()) {
                            String subject = "Your ReLuvd Order is Out for Delivery!";
                            String message = "Hi " + user.getUsername() + ",\n\n" +
                                    "Your item \"" + itemTitle + "\" is now out for delivery!\n" +
                                    "It should reach you soon.\n\n" +
                                    "You can track it under the 'My Orders' section on ReLuvd.\n\n" +
                                    "Warm regards,\n" +
                                    "The ReLuvd Team\n" +
                                    "Because OLD is the new NEW!";

                            if (user.getEmail() != null && !user.getEmail().isEmpty()) {
                                emailService.sendEmail(subject, message, user.getEmail());

                                // Set flag and save
                                item.setEmailSent(true);
                                checkoutItemRepository.save(item);  // Add this line to persist the change
                            }
                        }
                    } else {
                        statusMap.put(listingId, "Placed");
                    }

                } catch (Exception e) {
                    statusMap.put(listingId, "Placed");
                }
            }
        }


        model.addAttribute("orders", orders);
        model.addAttribute("deliveryStatusMap", statusMap);
        return "my-orders";
    }

    @GetMapping("/error-page")
    public String showErrorPage(@RequestParam(value = "error", required = false) String errorMsg,
                                Model model) {
        if (errorMsg != null && !errorMsg.isEmpty()) {
            model.addAttribute("error", errorMsg);
        } else {
            model.addAttribute("error", "An unexpected error occurred.");
        }
        return "error-page";
    }


	    @GetMapping("/my-messages")
	    public String myMessages() {
	        return "my-messages";
	    }

}