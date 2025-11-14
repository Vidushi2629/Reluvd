<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
        }

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

        .page-center-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #FAF7F2;
            min-height: 100vh;
            padding: 2rem;
        }
		

		.payment-box {
		    background-color: #fff;
		    border-radius: 15px;
		    padding: 3rem;
		    box-shadow: 0 0 10px rgba(0,0,0,0.1);
		    width: 100%;
		    max-width: 850px;
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
    <div class="payment-box">
        <h2 class="mb-4 text-center">Payment Method</h2>

        <!-- Summary -->
        <ul class="list-group mb-4">
            <c:set var="subtotal" value="${total + discount}" />
            <li class="list-group-item d-flex justify-content-between">Subtotal <span>₹${subtotal}</span></li>
            <li class="list-group-item d-flex justify-content-between">Discount <span>₹${discount}</span></li>
            <li class="list-group-item d-flex justify-content-between">Shipping <span>₹0</span></li>
            <li class="list-group-item d-flex justify-content-between fw-bold">Total <span>₹${total}</span></li>
        </ul>

		<form id="paymentForm" action="${pageContext.request.contextPath}/cart/payment" method="post">


            <!-- Hidden fields -->
            <input type="hidden" name="promoCode" value="${promoCode}" />
            <input type="hidden" name="discount" value="${discount}" />
            <input type="hidden" name="total" value="${total}" />
            <input type="hidden" name="addressId" value="${addressId}" />
            <input type="hidden" name="deliveryInstructions" value="${deliveryInstructions}" />
            <c:if test="${not empty itemId}">
                <input type="hidden" name="itemId" value="${itemId}" />
            </c:if>

			<button type="button" onclick="paymentStart()" class="btn btn-success w-100 mt-3">Pay Now</button>

        </form>
    </div>
</div>

<footer class="custom-footer">
    &copy; 2025 ReLuvd. All rights reserved.
</footer>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<script>
	function paymentStart() {
		const amount = ${total};

	    const amountPaise = Math.round(parseFloat(amount) * 100);

		fetch("${pageContext.request.contextPath}/cart/create-order", {
		    method: "POST",
		    headers: {
		        'Content-Type': 'application/json'
		    },
		    body: JSON.stringify({ amount: amountPaise })
		})

	    .then(res => res.json())
	    .then(data => {
	        const options = {
	            key: "rzp_test_eMM0dZQkGmn9wv",
	            amount: data.amount,
	            currency: data.currency,
	            name: "ReLuvd",
	            order_id: data.orderId,
	            
				handler: function (res) {
	                const form = document.querySelector('form');
	                ['razorpay_payment_id','razorpay_order_id','razorpay_signature'].forEach(k => {
	                    let inp = document.createElement('input');
	                    inp.type = 'hidden';
	                    inp.name = k;
	                    inp.value = res[k];
	                    form.appendChild(inp);
	                });
	                form.submit();
	            },
	            theme: {
	                color: "#244C45"
	            }
	        };
	        const rzp = new Razorpay(options);
	        rzp.on('payment.failed', function (resp){
	            alert(resp.error.description);
	        });
	        rzp.open();
	    });
	}

</script>
	
</body>
</html>
