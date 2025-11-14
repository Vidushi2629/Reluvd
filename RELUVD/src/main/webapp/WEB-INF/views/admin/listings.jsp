<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Listings | ReLuvd</title>
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
        <h2 class="text-center mb-4">All Listings</h2>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Size</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Availability</th>
                        <th>Delivery Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="listing" items="${listings}">
                        <tr>
                            <td>${listing.id}</td>
                            <td>
                               <img src="${pageContext.request.contextPath}/file/image/listings/${listing.imageUrl}"
                                     width="60"
                                     height="60"
                                     class="img-thumbnail"
                                     alt="${listing.title}" />

                            </td>
                            <td>${listing.title}</td>
                            <td>${listing.clothingType}</td>
                            <td>${listing.size}</td>
                            <td>₹${listing.price}</td>
                            <td>${listing.status}</td>
                            <td>${listing.availability}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty listing.deliveryStatus}">
                                        ${listing.deliveryStatus}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">N/A</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listings}">
                        <tr><td colspan="9" class="text-center">No listings available</td></tr>
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
