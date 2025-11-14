package com.api.reluvd.controllers;

import java.util.List;
import java.util.Map;

import com.api.reluvd.dao.UserRepository;
import com.api.reluvd.model.Listings;
import com.api.reluvd.model.User;
import com.api.reluvd.service.LoginService;
import com.api.reluvd.service.CartService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class LoginController {

    @Autowired
    private LoginService loginService;
   
    @Autowired
    private CartService cartService;

    @GetMapping("/")
    public String redirectToHome(HttpServletRequest request) {
        return "redirect:/home";
    }

  
    @GetMapping("/login")
    public String showLoginPage(HttpSession session, Model model,
                                 @RequestParam(value = "redirect", required = false) String redirect,
                                 @RequestParam(value = "reactivate", required = false) Boolean reactivate) {
        try {
            loginService.generateRSAKeys(session);
            if (redirect != null) {
                session.setAttribute("redirectAfterLogin", redirect);
            }
            model.addAttribute("publicKey", session.getAttribute("publicKey"));
            model.addAttribute("reactivate", Boolean.TRUE.equals(reactivate));

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "login";
    }


    @PostMapping("/register")
    @ResponseBody
    public ResponseEntity<?> registerUser(@RequestParam String email,
                                          @RequestParam String password,
                                          @RequestParam String phone) {
        return loginService.register(email, password, phone);
    }
    @PostMapping("/check-login")
    @ResponseBody
    public ResponseEntity<?> checkLogin(@RequestBody Map<String, String> payload,
                                        HttpSession session,
                                        HttpServletRequest request) {
        ResponseEntity<?> response = loginService.login(payload, session);

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return response; 
        }

        List<Listings> guestCart = (List<Listings>) session.getAttribute("guestCart");
        cartService.mergeGuestCartIntoUserCart(guestCart, user);
        session.removeAttribute("guestCart");

        List<Listings> guestSaved = (List<Listings>) session.getAttribute("guestSaved");
        cartService.mergeGuestSavedIntoUserSaved(guestSaved, user);
        session.removeAttribute("guestSaved");

        String contextPath = request.getContextPath();
        String redirect = (String) session.getAttribute("redirectAfterLogin");

        if (redirect == null || redirect.isEmpty()) {
            redirect = user != null && "Admin".equals(user.getRole())
                ? contextPath + "/admin/dashboard"
                : contextPath + "/home";
        } else if (!redirect.startsWith(contextPath)) {
            redirect = contextPath + redirect;
        }

        session.removeAttribute("redirectAfterLogin");

        return ResponseEntity.ok(Map.of("success", true, "redirect", redirect));
    }
    
    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() {
        return "forgot-password";
    }

    @PostMapping("/reset-password")
    @ResponseBody
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> data) {
        return loginService.resetPassword(data.get("email").toLowerCase(), data.get("newPassword"));
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    @PostMapping("/reactivate")
    @ResponseBody
    public ResponseEntity<?> reactivateAccount(HttpSession session) {
        String email = (String) session.getAttribute("deactivatedEmail");
        if (email == null) {
            return ResponseEntity.status(400).body(Map.of("success", false, "message", "No deactivated session found."));
        }

        User user = loginService.getUserByEmail(email);
        if (user == null) {
            return ResponseEntity.status(404).body(Map.of("success", false, "message", "User not found."));
        }

        user.setStatus("A");
        loginService.saveUser(user);
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());
        session.removeAttribute("deactivatedEmail");

        return ResponseEntity.ok(Map.of("success", true, "message", "Account reactivated"));
    }

}
