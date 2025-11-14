package com.api.reluvd.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.api.reluvd.model.DeliveryStatus;



@RestController
@RequestMapping("/api")
public class StatusController {
    @PostMapping("/update-status")
    public ResponseEntity<String> receiveDeliveryStatus(@RequestBody DeliveryStatus status) {
    	 System.out.println("Received delivery status for listing ID: " + status.getListingId() + " with status: " + status.getStatus());
        return ResponseEntity.ok("Status received");
    }
}
