package com.api.reluvd.service;

import com.api.reluvd.dao.AddressRepository;
import com.api.reluvd.dao.UserRepository;
import com.api.reluvd.helper.FileUploadHelper;
import com.api.reluvd.model.Address;
import com.api.reluvd.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.*;

@Service
public class ProfileService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private FileUploadHelper fileUploadHelper;

    public User loadUserProfile(HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) return null;

        User fullUser = userRepository.getUserById(sessionUser.getId());
        session.setAttribute("user", fullUser);
        return fullUser;
    }

    public ResponseEntity<?> addAddress(int userId, Address address) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        address.setUser(userOptional.get());
        addressRepository.save(address);

        return ResponseEntity.status(HttpStatus.CREATED).body(address);
    }

    public ResponseEntity<?> getAddressForEdit(int userId, int addressId) {
        Optional<Address> addressOpt = addressRepository.findById(addressId);
        if (addressOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Address not found");
        }

        Address address = addressOpt.get();
        if (address.getUser() == null || address.getUser().getId() != userId) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Address does not belong to user");
        }

        return ResponseEntity.ok(address);
    }

    public ResponseEntity<?> updateProfile(MultipartFile file, String username,
                                           @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dob,
                                           String gender, HttpSession session, HttpServletRequest request) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.ok().body(Map.of("redirect", request.getContextPath() + "/?error=sessionExpired"));
        }

        user = userRepository.findById(user.getId()).orElse(null);
        if (user == null) {
            return ResponseEntity.ok().body(Map.of("redirect", request.getContextPath() + "/?error=userNotFound"));
        }

        Optional<User> existingUser = userRepository.findByUsername(username);
        if (existingUser.isPresent() && existingUser.get().getId() != user.getId()) {
            return ResponseEntity.ok().body(Map.of("redirect", request.getContextPath() + "/my-profile?error=usernameTaken"));
        }

        try {
            if (file != null && !file.isEmpty() && file.getContentType().startsWith("image/")) {
                String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                boolean uploaded = fileUploadHelper.uploadFile(file, filename, "uploads");
                if (uploaded) {
                    user.setProfilePictureUrl(filename);
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (dob != null) user.setDob(dob);
        if (gender != null && !gender.equalsIgnoreCase("Select Gender")) user.setGender(gender);
        user.setUsername(username);

        // Clear and re-add addresses
        user.getAddresses().clear();
        String[] addressParams = request.getParameterValues("addresses");
        if (addressParams != null && addressParams.length > 0) {
            for (String full : addressParams) {
                full = full.trim();
                String[] parts = full.split(",\\s*");

                if (parts.length >= 11) {
                    Address addr = new Address();
                    addr.setAddressType(parts[0]);
                    addr.setFirstName(parts[1]);
                    addr.setLastName(parts[2]);
                    addr.setFlatNumber(parts[3]);
                    addr.setBuildingName(parts[4]);
                    addr.setLandmark(parts[5]);
                    addr.setStreet(parts[6]);
                    addr.setCity(parts[7]);
                    addr.setState(parts[8]);
                    addr.setZipcode(parts[9]);
                    addr.setCountry(parts[10]);
                    addr.setUser(user);
                    user.getAddresses().add(addr);
                }
            }
        }

        try {
            userRepository.save(user);
            session.setAttribute("user", user);
        } catch (DataIntegrityViolationException e) {
            return ResponseEntity.ok().body(Map.of("redirect", request.getContextPath() + "/my-profile?error=usernameTaken"));
        }

        return ResponseEntity.ok().body(Map.of("redirect", request.getContextPath() + "/my-profile"));
    }

    public ResponseEntity<Boolean> checkUsername(String username, HttpSession session) {
        try {
            Optional<User> existingUser = userRepository.findByUsername(username);
            User currentUser = (User) session.getAttribute("user");

            if (existingUser.isEmpty()) return ResponseEntity.ok(true);
            if (currentUser != null && Objects.equals(existingUser.get().getId(), currentUser.getId()))
                return ResponseEntity.ok(true);

            return ResponseEntity.ok(false);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);
        }
    }
    public void deactivateUser(int userId) {
        userRepository.deactivateUserById(userId);
    }
}
