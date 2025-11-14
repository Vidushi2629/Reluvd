<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f9f9f9;
        }

        .main-content {
            flex: 1;
        }

        .dashboard-wrapper {
            max-width: 1000px;
            margin: 3rem auto;
            background-color: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
		.order-block {
		    border: none;
		    border-bottom: 2px solid #244C45; 
		    margin-bottom: 2rem;
		    padding-bottom: 1.5rem;
		    background: none;
		}
        .order-header {
            font-weight: bold;
            color: #244C45;
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }

        .order-item {
            display: flex;
            gap: 1.5rem;
            padding: 1rem 0;
            border-bottom: 1px solid #ddd;
            align-items: center;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }

        .item-info {
            flex-grow: 1;
        }

        .item-price-status {
            text-align: right;
            min-width: 120px;
        }

        .item-price-status p {
            margin: 0;
        }

        .order-total {
            text-align: right;
            font-weight: bold;
            margin-top: 1rem;
            color: #244C45;
        }

        h2 {
            text-align: center;
            margin-bottom: 2rem;
            color: #244C45;
        }

        footer {
            background-color: #244C45;
            color: white;
            text-align: center;
            padding: 1rem 0;
            margin-top: auto;
        }
    </style>
</head>

<body>

<!-- Sidebar -->
<jsp:include page="/load-sidebar" />

<!-- Main Content -->
<div class="main-content">
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <div class="dashboard-wrapper">
        <h2 class="text-center">My Orders</h2>

        <c:if test="${empty orders}">
            <p class="text-muted text-center">You haven't placed any orders yet.</p>
        </c:if>

        <c:forEach var="order" items="${orders}">
            <div class="order-block">
                <div class="order-header">Checkout ID: ${order.checkoutId}</div>

                <c:forEach var="item" items="${order.checkoutItems}">
                    <c:set var="listingId" value="${item.listing.id}" />
                    <div class="order-item">
                        <img src="${pageContext.request.contextPath}/file/image/listings/${item.listing.imageUrl}" alt="${item.listing.title}" />
						
						<div class="item-info">
                            <h6>${item.listing.title}</h6>
                            <p class="text-muted">Colour: ${item.listing.color}</p>
                        </div>
                        <div class="item-price-status">
                            <p>₹${item.listing.price}</p>
                            <p class="text-muted">
                                <c:choose>
                                    <c:when test="${deliveryStatusMap[listingId] != null}">
                                        ${deliveryStatusMap[listingId]}
                                    </c:when>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </c:forEach>

                <div class="order-total">Total: ₹${order.total}</div>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
