package com.api.reluvd.controllers;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;


import com.api.reluvd.dao.ListingsRepository;
import com.api.reluvd.helper.FileUploadHelper;
import com.api.reluvd.model.Listings;
import com.api.reluvd.model.User;


import jakarta.servlet.http.HttpSession;
@Controller
public class ListingsController {
  
    @Autowired
    private FileUploadHelper fileUploadHelper;
 
    @Autowired
    private ListingsRepository listingsRepository;
   
    @PostMapping("/submit-item")
    public String submitItem(
            @RequestParam(value = "id", required = false) Integer id,
            @RequestParam("image") MultipartFile image,
            @RequestParam String title,
            @RequestParam String clothingType,
            @RequestParam String size,
            @RequestParam String color,
            @RequestParam String brand, 
            @RequestParam String material,  
            @RequestParam String gender,
            @RequestParam String condition,
            @RequestParam double price,
            @RequestParam String description,
            HttpSession session
    ) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        Listings listings;

        if (id != null) {
            //Editing an existing item
            listings = listingsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Listing not found"));
            if ("rejected".equalsIgnoreCase(listings.getStatus())) {
                listings.setStatus("pending");
                listings.setRejectionNote(null); // assuming the column is called rejectionNote
            }
            // Only update image if a new one was uploaded
            if (!image.isEmpty()) {
                String fileName = UUID.randomUUID().toString() + "_" + image.getOriginalFilename();
                boolean uploaded = fileUploadHelper.uploadFile(image, fileName, "listings");
                if (!uploaded) return "error";
                listings.setImageUrl(fileName);
            }

        } else {
            //New item
            listings = new Listings();

            if (image.isEmpty()) return "error"; // Image is required for new items

            String fileName = UUID.randomUUID().toString() + "_" + image.getOriginalFilename();
            boolean uploaded = fileUploadHelper.uploadFile(image, fileName, "listings");
            if (!uploaded) return "error";
            listings.setImageUrl(fileName);
            listings.setUser(user); // Set user only for new listings
        }

        listings.setTitle(title);
        listings.setClothingType(clothingType);
        listings.setSize(size);
        listings.setColor(color);
        listings.setBrand(brand); 
        listings.setMaterial(material); 
        listings.setGender(gender);
        listings.setCondition(condition);
        listings.setPrice(price);
        listings.setDescription(description);

        listingsRepository.save(listings);
        return "redirect:/my-listings";
    }
	@GetMapping("/my-listings")
	public String myListings(HttpSession session, Model model) {
	    User user = (User) session.getAttribute("user");
	    if (user == null) return "redirect:/";

	    List<Listings> listings = listingsRepository.findByUser(user);
	    model.addAttribute("listings", listings);
	    return "my-listings";
	}
	@GetMapping("/view-item/{id}")
	public String viewItem(
	        @PathVariable("id") int id,
	        @RequestParam(value = "source", required = false) String source,
	        HttpSession session,
	        Model model) {

	    Listings listing = listingsRepository.findById(id).orElse(null);
	    User user = (User) session.getAttribute("user");

	    boolean isAdmin = user != null && "Admin".equalsIgnoreCase(user.getRole());

	    model.addAttribute("item", listing);
	    model.addAttribute("isAdminView", isAdmin);
	    model.addAttribute("source", source); 

	    return "view-item";
	}

	@GetMapping("/edit-item")
	
	public String sellItem(@RequestParam(value = "id", required = false) Integer id, Model model) {
	    if (id == null) {
	        model.addAttribute("item", new Listings());
	    } else {
	        Listings item = listingsRepository.findById(id).orElse(null);
	        if (item == null) {
	            return "redirect:/my-listings";
	        }
	       
	        model.addAttribute("item", item);
	    }

	    return "sell-item";
	}
	


}
