package com.api.reluvd.dao;


import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.api.reluvd.model.Address;
import com.api.reluvd.model.User;


public interface AddressRepository extends CrudRepository<Address,Integer> {
	List<Address> findByUser(User user);
	Address findByIdAndUser(int id, User user);
}
