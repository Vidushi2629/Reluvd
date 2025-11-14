package com.api.reluvd;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.client.RestTemplate;
@ServletComponentScan(basePackages = "com.api.reluvd.helper") 
@SpringBootApplication
@EnableScheduling
@EnableTransactionManagement
public class ReluvdApplication {

	public static void main(String[] args) {
		SpringApplication.run(ReluvdApplication.class, args);
	}
	@Bean
	public RestTemplate restTemplate() {
	    return new RestTemplate();
	}

}
