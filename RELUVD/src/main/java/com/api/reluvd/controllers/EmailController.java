package com.api.reluvd.controllers;

import com.api.reluvd.dao.UserRepository;
import com.api.reluvd.model.EmailRequest;
import com.api.reluvd.service.EmailService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Controller
public class EmailController {
	 @Autowired
	    private EmailService emailService;

	    @Autowired
	    private UserRepository userRepository;

	    private final Map<String, String> otpStore = new ConcurrentHashMap<>();
	//Send OTP to email for verification
    @PostMapping("/sendemail")
    @ResponseBody
    public ResponseEntity<?> sendEmail(@RequestBody EmailRequest request) {
        String to = request.getTo().toLowerCase();

        //Check if email is already registered
        if (userRepository.existsByEmail(to)) {
            return ResponseEntity.status(400).body(
                Map.of("success", false, "message", "Email already registered")
            );
        }

        //Generate 4-digit OTP
        String otpStr = String.valueOf((int)(Math.random() * 9000) + 1000);
        otpStore.put(to, otpStr);

        //Compose email
        String message = "Your OTP Code for ReLuvd Verification\n\n" +
                "Hi,\n\n" +
                "Thank you for signing up on ReLuvd!\n\n" +
                "Your One-Time Password (OTP) is: " + otpStr + "\n\n" +
                "Please enter this code on the website to complete your verification.\n\n" +
                "If you didn’t request this, you can ignore this message.\n\n" +
                "Regards,\n" +
                "ReLuvd Team\n" +
                "Because OLD is the new NEW!";

        boolean result = emailService.sendEmail(
                "Your OTP Code for ReLuvd Verification",
                message,
                to
        );

        return result
                ? ResponseEntity.ok(Map.of("success", true))
                : ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "Email sending failed")
                );
    }

    //Verify OTP
    @PostMapping("/verify-otp")
    @ResponseBody
    public ResponseEntity<?> verifyOtp(@RequestBody Map<String, String> data) {
        String email = data.get("email").toLowerCase();
        String enteredOtp = data.get("otp");

        if (email == null || enteredOtp == null) {
            return ResponseEntity.badRequest().body(
                Map.of("success", false, "message", "Email or OTP missing")
            );
        }

        String storedOtp = otpStore.get(email);
        if (storedOtp != null && storedOtp.equals(enteredOtp)) {
            return ResponseEntity.ok(
                Map.of("success", true, "message", "OTP verified")
            );
        } else {
            return ResponseEntity.status(400).body(
                Map.of("success", false, "message", "Invalid OTP")
            );
        }
    }
    @PostMapping("/send-reset-otp")
    @ResponseBody
    public ResponseEntity<?> sendResetOtp(@RequestBody EmailRequest request) {
        String to = request.getTo().toLowerCase();

        // Check if user exists
        if (!userRepository.existsByEmail(to)) {
            return ResponseEntity.status(404).body(
                    Map.of("success", false, "message", "Email not found")
            );
        }

        // Generate 4-digit OTP
        String otpStr = String.valueOf((int)(Math.random() * 9000) + 1000);
        otpStore.put(to, otpStr);

        // Compose email message
        String message = "Your OTP for ReLuvd Password Reset\n\n" +
                "Hi,\n\n" +
                "We received a request to reset your password.\n\n" +
                "Your OTP is: " + otpStr + "\n\n" +
                "If you didn’t request this, please ignore it.\n\n" +
                "Regards,\n" +
                "ReLuvd Team\n" +
                "Because OLD is the new NEW!";

        // Send email
        boolean result = emailService.sendEmail(
                "Password Reset OTP - ReLuvd",
                message,
                to
        );

        if (result) {
            return ResponseEntity.ok(
                    Map.of("success", true, "message", "OTP sent successfully")
            );
        } else {
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "Email sending failed")
            );
        }
    }
}
