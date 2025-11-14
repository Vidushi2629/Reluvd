# Reluvd
My Wipro Internship Project that is a E-commerce platform for thirfting clothes
ReLuvd – Thrift E-Commerce & Delivery Platform

ReLuvd is a full-stack thrift e-commerce platform built to promote sustainable shopping by enabling users to buy and sell pre-loved products. The project includes ReLuvd Delivery, an integrated delivery management system that handles real-time order allocation, tracking, and status updates.
The platform was developed during my internship at Wipro Ltd., Mumbai, Maharashtra (15 May 2025 – 5 July 2025).

🚀 Project Overview

ReLuvd aims to create a digital marketplace where users can sell and purchase thrift items securely and efficiently.
The platform consists of:

Buyer portal for browsing items, adding to cart, and placing orders

Seller portal for uploading products, managing inventory, and tracking orders

Delivery partner module to handle pickup and delivery workflows

Admin functionality for overseeing the system (if required)

This platform promotes sustainability, reduces waste, and supports circular economy practices.

✨ Key Features
Buyer Features

Browse and search pre-loved items

Advanced filtering & category-based search

Add to cart, wishlist, and checkout

Secure online payments with Razorpay

Order history and real-time order tracking

Seller Features

Seller authentication and onboarding

Product upload (images, description, price, condition)

Manage listings, update items, track sales

View order status and earnings

Delivery Partner Features (ReLuvd Delivery)

Delivery partner login

Accept or reject assigned orders

Live status updates: Picked Up → Out for Delivery → Delivered

Delivery history and earnings overview

System Features

JWT-based authentication

Real-time mail notifications

Payment gateway integration

REST API-based microservice-like architecture

Scalable backend with modular design

🛠️ Tech Stack
Frontend

HTML

CSS

JavaScript

Bootstrap

Backend

Java

Spring Boot

Spring MVC

Spring Data JPA

Spring Security

JWT Authentication

Database

MySQL

MySQL Workbench

APIs & Integrations

REST APIs

Razorpay Payment Gateway

Email API

Tools & Utilities

Git

GitHub

Postman

Maven

Deployment

Render

Apache Tomcat

📥 Inputs

User details (sign-up and login)

Product details (name, price, category, images, condition)

Order information (address, payment preference, contact)

Delivery partner actions (accept/reject delivery)

Payment confirmation inputs from Razorpay

📤 Outputs

Successful authentication tokens

Product listings and search results

Order placement confirmation

Email notifications (order placed, shipped, delivered)

Delivery partner’s real-time updates

Payment verification response

Seller dashboard analytics

📡 System Architecture Overview

User interacts with frontend UI

Frontend communicates with backend via REST APIs

Spring Boot handles business logic and interacts with MySQL

Spring Security & JWT manage authentication

Email API sends updates & notifications

Razorpay handles secure payment processing

Delivery module updates order status in real-time

⚔️ Challenges Faced

Designing a scalable and modular architecture

Integrating Razorpay securely into checkout workflow

Implementing JWT authentication and role-based access

Ensuring smooth communication between buyer, seller, and delivery modules

Handling image uploads and storing product metadata

Building real-time order tracking mechanisms

📈 Learnings

End-to-end full-stack development with Spring Boot

Building secure authentication systems

Creating production-grade REST APIs

Payment gateway integration

Managing relational databases efficiently

Deploying full-stack applications on Render
