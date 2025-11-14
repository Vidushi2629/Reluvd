<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <style>

        .page-wrapper {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .cart-container {
            display: flex;
            gap: 2rem;
            align-items: flex-start;
            padding: 2rem;
        }

        .cart-items {
            flex: 3;
            background: #fff;
            border-radius: 10px;
            padding: 1.5rem;
        }

        .cart-summary {
            flex: 1;
            background: #f9f9f9;
            padding: 1.5rem;
            border-radius: 10px;
            border: 1px solid #ddd;
            height: fit-content;
            min-width: 300px;
            position: sticky;
            top: 100px;
        }

        .cart-item {
            border-bottom: 1px solid #eee;
            padding: 1rem 0;
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .cart-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }

        .btn {
            background-color: #244C45;
            color: white;
        }

        .btn:hover {
            background-color: #1a362f;
        }

        .promo-error {
            font-size: 0.9rem;
            color: red;
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

<div class="page-wrapper">
	
    <div class="main-content">
        <div class="container-fluid cart-container">
            <!-- Left: Cart Items -->
            <div class="cart-items">
                <h4 class="mb-4">Checkout Items</h4>

                <c:if test="${empty cartItems}">
                    <p class="text-muted text-center">Your cart is empty.</p>
                </c:if>

                <c:forEach var="item" items="${cartItems}">
                    <div class="cart-item">
                       <img src="${pageContext.request.contextPath}/file/image/listings/${item.imageUrl}" alt="${item.title}" />
					   
					   <div style="flex-grow: 1;">
                            <h6 class="fw-bold mb-1">${item.title}</h6>
                            <p class="text-muted mb-1">Colour: ${item.color}</p>
                            <p class="text-dark fw-semibold mb-0">₹${item.price}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Right: Summary Box -->
            <div class="cart-summary">
                <h5>Order Summary</h5>
                <hr/>
                <div class="d-flex justify-content-between">
                    <span>Subtotal (${cartItems.size()} items)</span>
                    <span id="subtotalValue">₹${subtotal}</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span>Discount</span>
                    <span class="text-success">-₹<span id="discountValue">0</span></span>
                </div>
                <div class="d-flex justify-content-between">
                    <span>Shipping</span>
                    <span>₹0</span>
                </div>
                <hr/>
                <div class="d-flex justify-content-between fw-bold">
                    <span>Total</span>
                    <span>₹<span id="totalValue">${total}</span></span>
                </div>

                <!-- Promo Code -->
                <div class="mt-3">
                    <input type="text" id="promoInput" class="form-control" placeholder="Enter promo code">
                    <div id="promoMessage" class="promo-error"></div>
                    <button class="btn btn-primary w-100 mt-2" onclick="applyPromo()">Apply</button>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/cart/address">
                    <c:if test="${not empty cartItems and cartItems.size() == 1}">
                        <input type="hidden" name="itemId" value="${cartItems[0].id}" />
                    </c:if>

                    <input type="hidden" name="promoCode" id="promoCodeField" value="" />
                    <input type="hidden" name="discount" id="discountField" value="0" />
                    <input type="hidden" name="total" id="totalField" value="${total}" />

                    <button type="submit" class="btn btn-success w-100 mt-3 fw-bold">Choose an Address</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    const promoCodes = {
        "SAVE10": 10,
        "FLAT50": 50,
        "RELUVD100": 100
    };

    function applyPromo() {
        const input = document.getElementById('promoInput').value.trim().toUpperCase();
        const discountAmount = promoCodes[input] || 0;
        const promoMsg = document.getElementById("promoMessage");

        const subtotalText = document.getElementById('subtotalValue').textContent.replace('₹', '');
        const subtotal = parseFloat(subtotalText) || 0;

        const discountField = document.getElementById('discountField');
        const totalField = document.getElementById('totalField');
        const promoField = document.getElementById('promoCodeField');

        if (discountAmount > 0) {
            document.getElementById("discountValue").textContent = discountAmount;
            const total = Math.max(subtotal - discountAmount, 0);
            document.getElementById("totalValue").textContent = total.toFixed(2);

            discountField.value = discountAmount;
            totalField.value = total.toFixed(2);
            promoField.value = input;

            promoMsg.textContent = "Promo code applied!";
            promoMsg.style.color = "#244C45";
        } else {
            document.getElementById("discountValue").textContent = 0;
            document.getElementById("totalValue").textContent = subtotal.toFixed(2);

            discountField.value = 0;
            totalField.value = subtotal.toFixed(2);
            promoField.value = "";

            promoMsg.textContent = "Invalid or expired promo code.";
            promoMsg.style.color = "red";
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<footer class="custom-footer">
    &copy; 2025 ReLuvd. All rights reserved.
</footer>

</body>
</html>
