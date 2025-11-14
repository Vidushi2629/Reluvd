package com.api.reluvd.service;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.api.reluvd.dao.UserRepository;
import com.api.reluvd.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.util.Base64;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class LoginService {

    @Autowired
    private UserRepository userRepository;
    private KeyPair keyPair;

    private final Map<String, String> otpStore = new ConcurrentHashMap<>();

    public void generateRSAKeys(HttpSession session) throws Exception {
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        keyPair = keyGen.generateKeyPair();

        session.setAttribute("keyPair", keyPair);
        session.setAttribute("publicKey", getPublicKeyBase64());
    }

    public ResponseEntity<?> register(String email, String password, String phone) {
        if (userRepository.existsByEmail(email)) {
            return ResponseEntity.status(400).body(
                Map.of("success", false, "message", "Email already registered")
            );
        }
        
        String hashedPassword = new BCryptPasswordEncoder().encode(password);
        User user = new User(email.toLowerCase(), hashedPassword, phone);
        saveUser(user); 

        return ResponseEntity.ok(Map.of("success", true, "message", "User registered"));
    }
    public ResponseEntity<?> login(Map<String, String> payload, HttpSession session) {
        keyPair = (KeyPair) session.getAttribute("keyPair");

        String email = decrypt(payload.get("email"));
        String password = decrypt(payload.get("password"));

        if (!userRepository.existsByEmail(email)) {
            return ResponseEntity.ok(Map.of(
                "success", false,
                "message", "Email not registered. Please sign up."
            ));
        }

        User user = userRepository.findByEmail(email);

        if ("D".equals(user.getStatus())) {
            session.setAttribute("deactivatedEmail", email);
            return ResponseEntity.ok(Map.of(
                "success", false,
                "reactivate", true,
                "message", "Account deactivated. Do you want to reactivate?"
            ));
        }
        
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        if (!encoder.matches(password, user.getPassword())) {
            return ResponseEntity.ok(Map.of(
                "success", false,
                "message", "Incorrect password."
            ));
        }

        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());
        return ResponseEntity.ok(Map.of("success", true));
    }

    public ResponseEntity<?> resetPassword(String email, String newPassword) {
        if (!userRepository.existsByEmail(email)) {
            return ResponseEntity.status(404).body(
                Map.of("success", false, "message", "Email not found")
            );
        }

        User user = userRepository.findByEmail(email);
        user.setPassword(new BCryptPasswordEncoder().encode(newPassword));
        userRepository.save(user);

        otpStore.remove(email);

        return ResponseEntity.ok(Map.of("success", true, "message", "Password updated successfully"));
    }

    public String decrypt(String encryptedBase64) {
        try {
            Cipher cipher = Cipher.getInstance("RSA");
            cipher.init(Cipher.DECRYPT_MODE, getPrivateKey());
            byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedBase64));
            return new String(decryptedBytes, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "error occured while decrypt";
        }
    }

    public String getPublicKeyBase64() {
        return Base64.getEncoder().encodeToString(keyPair.getPublic().getEncoded());
    }

    public PrivateKey getPrivateKey() {
        return keyPair.getPrivate();
    }
    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public void saveUser(User user) {
    	 if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
    	        String email = user.getEmail();
    	        if (email != null && email.contains("@")) {
    	            String generatedUsername = email.substring(0, email.indexOf("@"));
    	            user.setUsername(generatedUsername);
    	        }
    	    }

        userRepository.save(user);
    }


}
