<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

	<style>
		.custom-header {
		    background-color: #244C45;
		    color: white;
		    padding: 1rem 2rem;
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		}

		.custom-header .logo {
		    height: 60px;
		    margin-right: 1rem;
		}

		.brand-text h1 {
		    margin: 0;
		    font-size: 1.8rem;
		}

		.brand-text p {
		    margin: 0;
		    font-size: 0.9rem;
		    color: #ccc;
		}

		.custom-footer {
		    background-color: #244C45;
		    color: white;
		    text-align: center;
		    padding: 1rem;
		    margin-top: auto;
		}

        .confirmation-wrapper {
            max-width: 700px;
            margin: auto;
            padding: 3rem 1rem;
            text-align: center;
        }
        .checkmark {
            font-size: 4rem;
            color: #244C45;
        }
        .order-summary {
            text-align: left;
            margin-top: 2rem;
        }
        .btn-home {
            margin-top: 2rem;
            background-color: #244C45;
            color: white;
        }
        .btn-home:hover {
            background-color: #1a362f;
        }
    </style>
</head>
<body>
	<header class="custom-header">
			    <div style="display: flex; align-items: center;">
			        <img src="${pageContext.request.contextPath}/images/reluvd-logo.png" alt="ReLuvd Logo" class="logo"/>
			        <div class="brand-text">
			            <h1>ReLuvd</h1>
			            <p>Because OLD is the new NEW!</p>
			        </div>
			    </div>
			</header>
<div class="container confirmation-wrapper">
	<div class="checkmark"><i class="fas fa-check-circle"></i></div>

    <h2 class="my-3">Order Placed Successfully!</h2>
    <p class="text-muted">Thank you for shopping with ReLuvd. Your order is being processed.</p>

    <!-- Optional Order Summary -->
    <div class="order-summary">
        <h5>Order Summary:</h5>
        <ul class="list-group">
            <li class="list-group-item d-flex justify-content-between">Promo Code <span>${promoCode}</span></li>
            <li class="list-group-item d-flex justify-content-between">Discount <span>₹${discount}</span></li>
            <li class="list-group-item d-flex justify-content-between">Shipping <span>₹0</span></li>
            <li class="list-group-item d-flex justify-content-between fw-bold">Total Paid <span>₹${total}</span></li>
        </ul>

        <!-- Delivery Address -->
<div class="mt-3">
    <strong>Delivery Address:</strong><br/>
    ${address.addressType}, ${address.firstName} ${address.lastName}, ${address.flatNumber}, ${address.buildingName},
    <c:if test="${not empty address.landmark}">${address.landmark},</c:if> ${address.street}, ${address.city},
    ${address.state}, ${address.zipcode}, ${address.country}
    <br/><span class="text-muted">${instructions}</span>
</div>

    </div>

    <a href="${pageContext.request.contextPath}/home" class="btn btn-home mt-4">Continue Shopping</a>
</div>
<footer class="custom-footer">
    &copy; 2025 ReLuvd. All rights reserved.
</footer>
</body>
</html>
