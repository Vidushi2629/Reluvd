<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Orders | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .dashboard-wrapper {
            max-width: 1000px;
            margin: 3rem auto;
            background-color: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100">

<!-- Sidebar -->
<jsp:include page="/load-sidebar" />

<!-- Main Content -->
<div class="main-content flex-grow-1">
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <div class="dashboard-wrapper">
        <h2 class="text-center mb-4">Manage Orders</h2>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Checkout ID</th>
                        <th>Listing ID</th>
                        <th>Placed At</th>
                        <th>Seller</th>
                        <th>Buyer</th>
                        <th>Price</th>
                        <th>Delivery Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <c:forEach var="item" items="${order.checkoutItems}">
                            <tr>
                                <td>${order.checkoutId}</td>
                                <td>${item.listing.id}</td>
                                <td>${order.placedAt}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.listing.user.username}">
                                            ${item.listing.user.username}
                                        </c:when>
                                        <c:otherwise>
                                            ${fn:substringBefore(item.listing.user.email, '@')}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty order.user.username}">
                                            ${order.user.username}
                                        </c:when>
                                        <c:otherwise>
                                            ${fn:substringBefore(order.user.email, '@')}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>₹${item.listing.price}</td>
                                <td>
                                    <c:out value="${item.listing.deliveryStatus}" default="Placed"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr><td colspan="7" class="text-center">No orders found</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="mt-auto">
    <%@ include file="/WEB-INF/views/includes/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
