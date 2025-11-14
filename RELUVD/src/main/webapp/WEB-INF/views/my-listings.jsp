<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Listings | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Styles -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        html, body { height: 100%; margin: 0; padding: 0; }
       
        
        .products-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
            gap: 1.5rem;
            margin-left: 1rem;
        }

        .product-card {
			display: flex;
			   flex-direction: column;
			   justify-content: space-between; /* Push button to bottom */
			   align-items: center;
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 1rem;
            background-color: #fff;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            width: 260px;
			
        }
		.product-card p {
		    margin: 10px 0;
		    font-weight: bold;
		}

        .product-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
        }

        .btn {
            background-color: #244C45;
            color: white;
            border-radius: 8px;
            padding: 0.5rem 1rem;
        }
		.product-card h4 {
			margin-top: 10px;
			   font-size: 1.1rem;
			   min-height: 48px;
			   line-height: 1.2;
			   display: flex;
			   align-items: center;
			   justify-content: center;
			   text-align: center;
		}

    </style>
</head>
<body>

<!-- Sidebar and Header -->
<jsp:include page="/load-sidebar" />
<div class="main-content">
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <!-- Page Heading -->
    <div class="mb-4" style="margin-left: 1rem;">
        <h2 class="fw-bold">My Listings</h2>
        <p class="text-muted">Manage and view all the items you've listed</p>
    </div>

    <!-- Product Grid -->
    <div style="margin-left: 1rem;">
        <div class="products-grid">
			<c:forEach var="item" items="${listings}">
			    <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/view-item/${item.id}?source=my-listings'">
			        <img src="${pageContext.request.contextPath}/file/image/listings/${item.imageUrl}" 
			             alt="${item.title}" class="product-img"/>
			        <h4 class="mt-2">${item.title}</h4>
			        <p class="fw-semibold">₹${item.price}</p>
					<c:choose>
					            <c:when test="${item.availability == 'Available'}">
					                <p style="color: green; font-weight: bold;">Available</p>
					            </c:when>
					            <c:when test="${item.availability == 'Sold'}">
					                <p class="text-warning mt-2 fw-bold">Sold Out</p>
					            </c:when>
					            <c:when test="${item.availability == 'Sold and Removed'}">
					                <p style="color: red; font-weight: bold;">Sold Out and Removed</p>
					            </c:when>
					        </c:choose>
					<c:if test="${item.availability == 'Available'}">
			        <!-- Buttons with stopPropagation -->
			        <button class="btn mt-2" onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/edit-item?id=${item.id}'">Modify Product</button>
					</c:if>
			        <c:choose>
			            <c:when test="${item.status == 'Approved'}">
			                <p class="text-success mt-2 fw-semibold">Approved</p>
			            </c:when>
						<c:when test="${item.status == 'Rejected'}">
						    <div style="margin-top: 0.5rem;">
						        <span class="fw-semibold" style="color: red; font-size: 1rem;">
						            Rejected
						            <i class="fas fa-question-circle" 
						               style="cursor: pointer; color: #888; margin-left: 5px;" 
						               onclick="event.stopPropagation(); toggleNote(${item.id})"></i>
						        </span>

						        <p id="note-${item.id}" style="display: none; color: red; font-size: 0.9rem; margin-top: 4px;">
						            ${item.rejectionNote}
						        </p>
						    </div>
						</c:when>


			            <c:otherwise>
			                <p class="text-warning mt-2 fw-semibold">Approval Pending</p>
			            </c:otherwise>
			        </c:choose>
			    </div>
			</c:forEach>

        </div>
    </div>
	

	<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleNote(id) {
        const note = document.getElementById('note-' + id);
        note.style.display = (note.style.display === 'none') ? 'block' : 'none';
    }
</script>

</body>
</html>
