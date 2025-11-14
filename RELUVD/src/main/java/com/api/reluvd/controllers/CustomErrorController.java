package com.api.reluvd.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CustomErrorController {

	  @GetMapping("/access-denied")
	    public String accessDenied() {
	        return "error/access-denied";
	    }
}
