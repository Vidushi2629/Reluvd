package com.api.reluvd.controllers;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.api.reluvd.dao.UserRepository;
import com.api.reluvd.model.Address;
import com.api.reluvd.model.User;
import com.api.reluvd.service.ProfileService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class ProfileController {
	@Autowired
	private ProfileService profileService;
	 @Autowired
	    private UserRepository userRepo;

	@GetMapping("/my-profile")
	public String showProfilePage(HttpSession session, Model model) {
	    User user = profileService.loadUserProfile(session);
	    if (user == null) return "redirect:/";

	    model.addAttribute("user", user);
	    return "my-profile";
	}

	@PostMapping("/{userId}/add-address")
	public ResponseEntity<?> addAddress(@PathVariable int userId, @Valid @RequestBody Address address) {
	    return profileService.addAddress(userId, address);
	}

	@GetMapping("/{userId}/address/{addressId}")
	public ResponseEntity<?> getAddressForEdit(@PathVariable int userId, @PathVariable int addressId) {
	    return profileService.getAddressForEdit(userId, addressId);
	}

	@PostMapping("/update-profile")
	@ResponseBody
	public ResponseEntity<?> updateProfile(@RequestParam(value = "profilePic", required = false) MultipartFile file,
	                                       @RequestParam("username") String username,
	                                       @RequestParam(value = "dob", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dob,
	                                       @RequestParam(value = "gender", required = false) String gender,
	                                       HttpSession session, HttpServletRequest request) {
	    return profileService.updateProfile(file, username, dob, gender, session, request);
	}

	@GetMapping("/check-username")
	@ResponseBody
	public ResponseEntity<Boolean> checkUsername(@RequestParam("username") String username, HttpSession session) {
	    return profileService.checkUsername(username, session);
	}
	@PostMapping("/deactivate-account")
	@ResponseBody
	public Map<String, Object> deactivateAccount(HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    User user = (User) session.getAttribute("user");

	    if (user == null) {
	        response.put("success", false);
	        response.put("message", "User not logged in.");
	        return response;
	    }

	    try {
	        profileService.deactivateUser(user.getId());
	        session.invalidate();
	        response.put("success", true);
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "Failed to deactivate account.");
	    }

	    return response;
	}
	@PostMapping("/remove-profile-picture")
	@ResponseBody
	public Map<String, Object> removeProfilePic(HttpSession session) {
	    User user = (User) session.getAttribute("user");
	    Map<String, Object> result = new HashMap<>();
	    if (user != null) {
	        user.setProfilePictureUrl(null); // or delete from file system if stored locally
	        userRepo.save(user); // update DB
	        result.put("success", true);
	    } else {
	        result.put("success", false);
	    }
	    return result;
	}


}
