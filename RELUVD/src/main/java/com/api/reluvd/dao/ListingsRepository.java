package com.api.reluvd.dao;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.api.reluvd.model.Listings;
import com.api.reluvd.model.User;

import jakarta.transaction.Transactional;

public interface ListingsRepository extends JpaRepository<Listings, Integer> {
	long countByAvailability(String availability);
	long countByStatus(String status);
	List<Listings> findTop5ByOrderByCreatedAtDesc();


    List<Listings> findByStatus(String status);
    List<Listings> findByUser(User user);
   
    @Query("SELECT l FROM Listings l WHERE l.status = 'Approved' AND " +
    	       "(:query = '' OR LOWER(l.title) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
    	       "(:gender = '' OR l.gender = :gender) AND " +
    	       "(:type = '' OR l.clothingType = :type) AND " +
    	       "(:size = '' OR l.size = :size) AND " +
    	       "(:condition = '' OR l.condition = :condition) AND " +
    	       "(:material = '' OR l.material = :material) AND " +
    	       "(:color = '' OR l.color = :color) AND " +
    	       "(:brand = '' OR l.brand = :brand) AND " +
    	       "(l.availability = 'Available' OR (l.availability = 'Sold' AND l.soldAt > :oneDayAgo))")
    	Page<Listings> findFilteredListings(
    	    @Param("query") String query,
    	    @Param("gender") String gender,
    	    @Param("type") String type,
    	    @Param("size") String size,
    	    @Param("condition") String condition,
    	    @Param("material") String material,
    	    @Param("color") String color,
    	    @Param("brand") String brand,
    	    @Param("oneDayAgo") LocalDateTime oneDayAgo,
    	    Pageable pageable
    	);
    
    @Query("SELECT l FROM Listings l WHERE l.status = 'Approved' AND " +
    	       "(:query = '' OR LOWER(l.title) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
    	       "(:gender = '' OR l.gender = :gender) AND " +
    	       "(:type = '' OR l.clothingType = :type) AND " +
    	       "(:size = '' OR l.size = :size) AND " +
    	       "(:condition = '' OR l.condition = :condition) AND " +
    	       "(:material = '' OR l.material = :material) AND " +
    	       "(:color = '' OR l.color = :color) AND " +
    	       "(:brand = '' OR l.brand = :brand)")
    	List<Listings> searchListings(
    	    @Param("query") String query,
    	    @Param("gender") String gender,
    	    @Param("type") String type,
    	    @Param("size") String size,
    	    @Param("condition") String condition,
    	    @Param("material") String material,
    	    @Param("color") String color,
    	    @Param("brand") String brand
    	);
    @Query("SELECT DISTINCT l.material FROM Listings l WHERE l.status = 'Approved' AND l.availability = 'Available'")
    List<String> findDistinctMaterials();

    @Query("SELECT DISTINCT l.brand FROM Listings l WHERE l.status = 'Approved' AND l.availability = 'Available' ")
    List<String> findDistinctBrands();

    @Query("SELECT DISTINCT l.color FROM Listings l WHERE l.status = 'Approved' AND l.availability = 'Available' ")
    List<String> findDistinctColors();
    
    @Transactional
    @Modifying
    @Query("UPDATE Listings l SET l.status = :status WHERE l.id = :id")
    void updateStatus(@Param("id") int id, @Param("status") String status);

    @Transactional
    @Modifying
    @Query("UPDATE Listings l SET l.status = :status, l.rejectionNote = :note WHERE l.id = :id")
    void rejectListingWithNote(@Param("id") int id, @Param("status") String status, @Param("note") String note);

    @Modifying
    @Transactional
    @Query("UPDATE Listings l SET l.availability = 'Sold and Removed' WHERE l.availability = 'Sold' AND l.soldAt < :oneDayAgo")
    void updateOldSoldToRemoved(@Param("oneDayAgo") LocalDateTime oneDayAgo);


}
