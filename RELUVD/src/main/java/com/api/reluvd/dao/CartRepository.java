package com.api.reluvd.dao;

import com.api.reluvd.model.Cart;
import com.api.reluvd.model.User;
import com.api.reluvd.model.Listings; // changed from Product to Listing
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CartRepository extends JpaRepository<Cart, Integer> {
    
    List<Cart> findByUserAndIsSavedForLater(User user, boolean isSavedForLater);
    
    Cart findByUserAndListing(User user, Listings listing);
    
    void deleteByUserAndListing(User user, Listings listing);

}
