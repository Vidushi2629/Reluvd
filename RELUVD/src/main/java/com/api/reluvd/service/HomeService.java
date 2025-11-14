package com.api.reluvd.service;

import com.api.reluvd.dao.ListingsRepository;
import com.api.reluvd.model.Listings;

import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class HomeService {

    @Autowired
    private ListingsRepository listingsRepository;

    public Page<Listings> getFilteredListingsPaginated(
            String query, String gender, String type, String size,
            String condition, String material, String color, String brand,
            String sort, int page, int sizePerPage
            
    ) {
        LocalDateTime oneDayAgo = LocalDateTime.now().minusDays(1);
    	

        if (sort == null || sort.trim().isEmpty()) {
            sort = "Newest First";
        }

        Sort sortOrder;
        switch (sort) {
            case "Price Low to High":
                sortOrder = Sort.by("price").ascending();
                break;
            case "Price High to Low":
                sortOrder = Sort.by("price").descending();
                break;
            case "Oldest First":
                sortOrder = Sort.by("createdAt").ascending();
                break;
            case "Newest First":
            default:
                sortOrder = Sort.by("createdAt").descending();
                break;
        }

        Pageable pageable = PageRequest.of(page, sizePerPage, sortOrder);

        return listingsRepository.findFilteredListings(
                (query != null && !query.isEmpty()) ? query.toLowerCase() : "",
                gender != null ? gender : "",
                type != null ? type : "",
                size != null ? size : "",
                condition != null ? condition : "",
                material != null ? material : "",
                color != null ? color : "",
                brand != null ? brand : "",
                oneDayAgo,
                pageable
        );
    }


    public List<String> getAllMaterials() {
        return listingsRepository.findDistinctMaterials();
    }

    public List<String> getAllBrands() {
        return listingsRepository.findDistinctBrands();
    }

    public List<String> getAllColors() {
        return listingsRepository.findDistinctColors();
    }
    @Scheduled(fixedRate = 86400000) // every 1 minute
    @Transactional
    public void markOldSoldItemsAsRemoved() {
        LocalDateTime oneDayAgo = LocalDateTime.now().minusMinutes(1);
        listingsRepository.updateOldSoldToRemoved(oneDayAgo);
      
    }
}