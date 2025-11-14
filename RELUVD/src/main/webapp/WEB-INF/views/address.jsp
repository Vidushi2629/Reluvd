<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delivery Address | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
			
        }

		.page-center-wrapper {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    height: 100vh;
		    background-color: #FAF7F2;
		    padding: 1rem;
		}


        .address-box {
            background-color: #fff;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 800px;
        }

        .address-box h2 {
            font-weight: bold;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .address-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .address-item {
            background-color: #f8f9fa;
            padding: 1rem;
            border: 1px solid #ccc;
            border-radius: 10px;
            display: flex;
            gap: 1rem;
            align-items: center;
            width: 100%;
        }

        .address-item input[type="text"] {
            flex-grow: 1;
        }

		.btn-success {
		    font-weight: bold;
		    background-color: #244C45;
		    border-color: #244C45;
		}

		.btn-success:hover,
		.btn-success:focus,
		.btn-success:active {
		    background-color: #244C45 !important;
		    border-color: #244C45 !important;
		    color: white;
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

<div class="page-center-wrapper">
    <div class="address-box">
        <h2>Select Delivery Address</h2>

		<form action="${pageContext.request.contextPath}/cart/go-to-payment" method="post">

            <div class="address-list" id="addressList">
                <c:forEach var="addr" items="${addresses}">
                    <div class="address-item">
                        <input class="form-check-input me-2" type="radio" name="addressId" value="${addr.id}" required />
                        <input type="text" value="${addr.addressType}, ${addr.firstName}, ${addr.lastName}, ${addr.flatNumber}, ${addr.buildingName}, ${addr.landmark}, ${addr.street}, ${addr.city}, ${addr.state}, ${addr.zipcode}, ${addr.country}" readonly class="form-control" />
                    </div>
                </c:forEach>
            </div>

            <div class="mb-3 mt-4">
                <label for="deliveryInstructions" class="form-label fw-bold">Delivery Instructions</label>
                <textarea class="form-control" name="deliveryInstructions" rows="3" placeholder="Optional notes for delivery..."></textarea>
            </div>

			<input type="hidden" name="itemId" value="${itemId}" />

            <input type="hidden" name="promoCode" value="${param.promoCode}" />
            <input type="hidden" name="discount" value="${param.discount}" />
            <input type="hidden" name="total" value="${param.total}" />
            <input type="hidden" id="userId" value="${user.id}" />

            <button type="submit" class="btn btn-success w-100 mt-3">Choose Payment Method</button>
        </form>
    </div>
</div>

<footer class="custom-footer">
    &copy; 2025 ReLuvd. All rights reserved.
</footer>
</body>
</html>
