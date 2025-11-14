<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="source" value="${param.source}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${item.title} | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .product-box-wrapper {
            max-width: 1000px;
            margin: 3rem auto;
            background-color: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .product-detail {
            display: flex;
            gap: 2rem;
            align-items: flex-start;
        }

        .product-detail img {
            width: 400px;
            height: auto;
            border-radius: 10px;
        }

        .product-info {
            flex: 1;
        }

        .price {
            font-size: 1.6rem;
            font-weight: bold;
            color: #244C45;
        }

        .btn-buy {
            background-color: #244C45;
            color: white;
            border: none;
            padding: 0.5rem 1.2rem;
            border-radius: 6px;
            text-decoration: none;
        }
    </style>
</head>
<body>

<jsp:include page="/load-sidebar" />
<div class="main-content">
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <div class="product-box-wrapper">
        <div class="product-detail">
          <img src="${pageContext.request.contextPath}/file/image/listings/${item.imageUrl}" 
                 alt="${item.title}" class="product-img"/>


            <div class="product-info">
                <h2>${item.title}</h2>
                <p class="price">₹${item.price}</p>
                <p><strong>Type:</strong> ${item.clothingType}</p>
                <p><strong>Size:</strong> ${item.size}</p>
                <p><strong>Color:</strong> ${item.color}</p>
                <p><strong>Brand:</strong> ${item.brand}</p>
                <p><strong>Material:</strong> ${item.material}</p>
                <p><strong>Gender:</strong> ${item.gender}</p>
                <p><strong>Condition:</strong> ${item.condition}</p>
                <p><strong>Description:</strong> ${item.description}</p>
                <p><strong>Seller:</strong> 
                    <c:choose>
                        <c:when test="${not empty item.user.username}">
                            ${item.user.username}
                        </c:when>
                        <c:otherwise>
                            ${fn:substringBefore(item.user.email, '@')}
                        </c:otherwise>
                    </c:choose>
                </p>

                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <c:choose>
                       
					<c:when test="${source == 'home'}">
					    <div style="display: flex; gap: 1rem;">
							
							<!-- Add to Cart -->
							<form onsubmit="event.preventDefault(); event.stopPropagation(); addToCart(${item.id});">
							    <button type="button" class="btn-buy" data-id="${item.id}" onclick="event.stopPropagation(); addToCart(${item.id});">
							        Add to Cart
							    </button>
							</form>


							<!-- Buy Now -->
							<form method="post" action="${pageContext.request.contextPath}/cart/buy-now" onclick="event.stopPropagation();">
							    <input type="hidden" name="itemId" value="${item.id}" />
							    <button type="submit" class="btn-buy">Buy Now</button>
							</form>
							<button type="button" class="btn-buy" style="background-color: #244C45;" onclick="goBackToHome()">
							    <i class="fas fa-arrow-left"></i> Back to Home
							</button>
					    </div>
					</c:when>


                        
                        <c:when test="${source == 'my-listings' && not isAdminView}">
                            <a href="${pageContext.request.contextPath}/my-listings" class="btn-buy">Back to My Listings</a>
                        </c:when>
						<c:when test="${source == 'pending' && isAdminView}">
						    <!-- Outer container: Column -->
						    <div style="display: flex; flex-direction: column; gap: 1rem; align-items: flex-start;">

						        <!-- Row: Reject and Approve side by side -->
						        <div style="display: flex; flex-direction: row; gap: 2rem; align-items: flex-start;">

						            <!-- Reject Section -->
						            <div id="rejectContainer" style="display: flex; flex-direction: column; align-items: flex-start;">
						                <button id="rejectButton" type="button" class="btn-buy" style="background-color: #e74c3c;" onclick="toggleRejectNote()">
						                    Reject
						                </button>

						                <!-- Hidden Reject Form -->
						                <form id="rejectForm" method="post" action="${pageContext.request.contextPath}/admin/reject-listing"
						                      style="display: none; margin-top: 0.5rem;">
						                    <input type="hidden" name="id" value="${item.id}" />
						                    <textarea name="note" placeholder="Enter rejection note..." rows="3"
						                              class="form-control mb-2" required style="width: 250px;"></textarea>
						                    <div style="display: flex; gap: 1rem;">
						                        <button type="button" class="btn-buy" style="background-color: #6c757d;" onclick="cancelReject()">Cancel</button>
						                        <button type="submit" class="btn-buy" style="background-color: #e74c3c;">Submit</button>
						                    </div>
						                </form>
						            </div>

						            <!-- Approve Section -->
						            <div style="display: flex; flex-direction: column; justify-content: flex-start;">
						                <form method="post" action="${pageContext.request.contextPath}/admin/approve-listing/${item.id}">
						                    <button type="submit" class="btn-buy">Approve</button>
						                </form>
						            </div>
						        </div>

						        <!-- Back to Pending Listings -->
						        <a href="${pageContext.request.contextPath}/admin/pending-listings" class="btn-buy">
						            Back to Pending Listings
						        </a>
						    </div>
						</c:when>


                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/includes/footer.jsp" %>
</div>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const contextPath = "${contextPath}";
</script>
<script>
	function goBackToHome() {
	    const scrollPos = sessionStorage.getItem('scrollPos') || 0;
	    const homeUrl = contextPath + "/home#scrollTo=" + scrollPos;
	    window.location.href = homeUrl;
	}

	function toggleRejectNote() {
	    const form = document.getElementById('rejectForm');
	    const button = document.getElementById('rejectButton');
	    const container = document.getElementById('rejectContainer');

	    form.style.display = 'block';
	    button.style.width = '250px';  // Expand only when form is shown
	}

	function cancelReject() {
	    const form = document.getElementById('rejectForm');
	    const button = document.getElementById('rejectButton');

	    form.style.display = 'none';
	    button.style.width = ''; 
	}
	function addToCart(listingId) {
	  fetch(contextPath + "/cart/add-to-cart", {
	    method: 'POST',
	    headers: {
	      'Content-Type': 'application/json'
	    },
	    body: JSON.stringify({ listingId: listingId })
	  })
	  .then(response => {
	    if (!response.ok) throw new Error("Failed to add to cart");
	    return response.text();
	  })
	  .then(msg => {
	    showPopup("Item added to cart", "success");
	  })
	  .catch(err => {
	    showPopup("Failed to add item", "error");
	  });
	}

	function showPopup(message, type = "info") {
		  const popup = document.createElement("div");
		  popup.className = `custom-popup ${type}`;
		  popup.textContent = message;

		  if (type === "success") {
		    popup.style.backgroundColor = "#244C45";  
		  } else if (type === "error") {
		    popup.style.backgroundColor = "#e74c3c";
		  }

		  document.body.appendChild(popup);

		  setTimeout(() => popup.classList.add("show"), 100);
		  setTimeout(() => {
		    popup.classList.remove("show");
		    setTimeout(() => popup.remove(), 500);
		  }, 3000);
		}


</script>

</body>
</html>
