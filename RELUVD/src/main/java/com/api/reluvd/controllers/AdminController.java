package com.api.reluvd.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.api.reluvd.dao.CheckoutSessionRepository;
import com.api.reluvd.dao.ListingsRepository;
import com.api.reluvd.dao.UserRepository;
import com.api.reluvd.model.CheckoutItem;
import com.api.reluvd.model.CheckoutSession;
import com.api.reluvd.model.DeliveryStatus;
import com.api.reluvd.model.Listings;

@Controller
public class AdminController {


	 @Autowired
	    private RestTemplate restTemplate;
	    @Autowired
	    private UserRepository userRepository;
	    @Autowired
	    private CheckoutSessionRepository checkoutSessionRepository;

    @Autowired
    private ListingsRepository listingsRepository;

    @GetMapping("/admin/pending-listings")
    public String viewPendingListings(Model model) {
        List<Listings> pendingListings = listingsRepository.findByStatus("Pending");
        model.addAttribute("pendingListings", pendingListings);
        return "admin/pending-listings";
    }
    @GetMapping("/admin/dashboard")
    public String adminDashboard(Model model) {
        long totalUsers = userRepository.count();
        long totalListings = listingsRepository.count();
        long totalSold = listingsRepository.countByAvailability("Sold");
        long pendingListings = listingsRepository.countByStatus("Pending");

        List<Listings> recentListings = listingsRepository.findTop5ByOrderByCreatedAtDesc();

        model.addAttribute("totalUsers", userRepository.count());
        model.addAttribute("totalListings", listingsRepository.count());
        model.addAttribute("totalSold", listingsRepository.countByAvailability("Sold"));
        model.addAttribute("pendingListings", listingsRepository.countByStatus("Pending"));
        model.addAttribute("approvedCount", listingsRepository.countByStatus("Approved"));
        model.addAttribute("rejectedCount", listingsRepository.countByStatus("Rejected"));
        model.addAttribute("recentListings", listingsRepository.findTop5ByOrderByCreatedAtDesc());


        return "admin/dashboard";
    }
    @GetMapping("/admin/users")
    public String manageUsers(Model model) {
    	model.addAttribute("users", userRepository.findAll());
        return "admin/users";
    }

    @GetMapping("/admin/listings")
    public String viewListings(Model model) {
        List<Listings> listings = listingsRepository.findAll();

        for (Listings l : listings) {
            try {
                String url = "http://localhost:8081/ReLuvdDelivery/api/delivery/status/" + l.getId();
                DeliveryStatus ds = restTemplate.getForObject(url, DeliveryStatus.class);
                if (ds != null) {
                    l.setDeliveryStatus(ds.getStatus());
                }
            } catch (Exception e) {
                l.setDeliveryStatus("N/A");
            }
        }

        model.addAttribute("listings", listings);
        return "admin/listings"; // maps to listings.jsp
    }


    @GetMapping("/admin/orders")
    public String manageOrders(Model model) {
        List<CheckoutSession> sessions = checkoutSessionRepository.findAll();

        for (CheckoutSession session : sessions) {
            for (CheckoutItem item : session.getCheckoutItems()) {
                Listings listing = item.getListing();

                try {
                    String deliveryAppUrl = "http://localhost:8081/ReLuvdDelivery/api/delivery/status/" + listing.getId();
                    DeliveryStatus status = restTemplate.getForObject(deliveryAppUrl, DeliveryStatus.class);
                    if (status != null) {
                        listing.setDeliveryStatus(status.getStatus());  // Transient or in-memory field
                    }
                } catch (Exception e) {
                    // Skip setting status
                }
            }
        }

        model.addAttribute("orders", sessions);
        return "admin/orders";
    }


    @PostMapping("/admin/reject-listing")
    public String rejectListing(@RequestParam("id") int id, @RequestParam("note") String note) {
        listingsRepository.rejectListingWithNote(id, "Rejected", note);
        return "redirect:/admin/pending-listings";
    }
    @PostMapping("/admin/approve-listing/{id}")
	public String approveListing(@PathVariable int  id) {
		listingsRepository.updateStatus(id, "Approved");
	    return "redirect:/admin/pending-listings";
	}

	@PostMapping("/admin/reject-listing/{id}")
	public String rejectListing(@PathVariable int  id) {
		listingsRepository.updateStatus(id, "Rejected");
	    return "redirect:/admin/pending-listings";
	}


}
