<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Listings | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .pending-wrapper {
            max-width: 1200px;
            margin: 3rem auto;
            background-color: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .product-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            justify-content: flex-start;
        }

        .product-card {
            width: 260px;
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .product-card h5 {
            margin: 10px 0 5px;
            font-size: 1.1rem;
        }

        .product-card p {
            margin: 0 0 10px;
            color: #444;
        }

        .btn-view {
            background-color: #244C45;
            color: #fff;
            padding: 0.5rem 1rem;
            margin-bottom: 1rem;
            border: none;
            border-radius: 6px;
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100">
    <jsp:include page="/load-sidebar" />

    <div class="main-content flex-grow-1">
        <%@ include file="/WEB-INF/views/includes/header.jsp" %>

        <div class="pending-wrapper">
            <h2 class="text-center mb-4">Pending Listings for Approval</h2>

            <c:if test="${empty pendingListings}">
                <p class="text-center text-muted">No pending listings found.</p>
            </c:if>

            <c:if test="${not empty pendingListings}">
                <div class="product-grid">
                    <c:forEach var="listing" items="${pendingListings}">
                        <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/view-item/${listing.id}?source=pending'">
                           <img src="${pageContext.request.contextPath}/file/image/listings/${listing.imageUrl}" alt="${listing.title}" />
						  

                            <h5>${listing.title}</h5>
                            <p>₹${listing.price}</p>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

    <div class="mt-auto">
        <%@ include file="/WEB-INF/views/includes/footer.jsp" %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
