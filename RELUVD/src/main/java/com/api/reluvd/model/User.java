package com.api.reluvd.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.*;

@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(unique = true)
    private String email;
    private String password;
    @Column(unique = true)
    private String phone;
    @Column(unique = true)
    private String username;
    private LocalDate dob;
    private String gender;
    private String profilePictureUrl;
    @Column(nullable = false)
	@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true ,fetch = FetchType.LAZY)
    private List<Address> addresses = new ArrayList<>();
    @Column(nullable = false)
    private String status = "A"; // A = Active, D = Deactivated
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

	public User(String email, String password, String phone) {
		super();
		this.email = email;
		this.password = password;
		this.phone = phone;
	}
	private String role = "User"; 
    public String getRole() {
		return role;
	}


	public void setRole(String role) {
		this.role = role;
	}


	public String getUsername() {
		return username;
	}


	public void setUsername(String username) {
		this.username = username;
	}


	public LocalDate getDob() {
		return dob;
	}


	public void setDob(LocalDate dob) {
		this.dob = dob;
	}


	public String getGender() {
		return gender;
	}


	public void setGender(String gender) {
		this.gender = gender;
	}


	public String getProfilePictureUrl() {
		return profilePictureUrl;
	}


	public void setProfilePictureUrl(String profilePictureUrl) {
		this.profilePictureUrl = profilePictureUrl;
	}


	public List<Address> getAddresses() {
		return addresses;
	}


	public void setAddresses(List<Address> addresses) {
		this.addresses = addresses;
	}


	public User() {}


	public User(int id, String email, String password, String phone, String username, LocalDate dob, String gender,
			String profilePictureUrl, List<Address> addresses) {
		super();
		this.id = id;
		this.email = email;
		this.password = password;
		this.phone = phone;
		this.username = username;
		this.dob = dob;
		this.gender = gender;
		this.profilePictureUrl = profilePictureUrl;
		this.addresses = addresses;
	}


	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	
   
}
