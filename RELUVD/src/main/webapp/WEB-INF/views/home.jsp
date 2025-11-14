<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:choose>
    <c:when test="${not empty user}">
        <c:choose>
            <c:when test="${not empty user.username}">
                <c:set var="username" value="${user.username}" />
            </c:when>
            <c:otherwise>
                <c:set var="username" value="${fn:substringBefore(user.email, '@')}" />
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="username" value="User" />
    </c:otherwise>
</c:choose>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        html, body { margin: 0; padding: 0; }
        .layout-body { display: flex; flex-direction: column; min-height: 100vh; }
        .custom-header {
            display: flex; justify-content: space-between; align-items: center;
            padding: 1rem 2rem; background-color: #1f4a45; color: white;
        }
		.empty-state {
		    display: flex;
		    flex-direction: column;
		    align-items: center;
		    justify-content: center;
		    min-height: 60vh;
		    text-align: center;
		    color: #244C45;
		    margin-left: 500px;
		}


		.empty-state i {
		    font-size: 3rem;
		    margin-bottom: 1rem;
		}
		.empty-state p {
		    font-size: 1.3rem;
		}

		.main-content {
		    flex: 1 0 auto;
		}

		footer, .footer {
		    flex-shrink: 0;
		}

        .header-left { display: flex; align-items: center; gap: 1rem; }
        .logo { width: 60px; height: 60px; }
        .brand-text h1 { margin: 0; font-size: 1.5rem; }
        .brand-text p { margin: 0; font-size: 0.9rem; }
        .right { display: flex; align-items: center; gap: 0.8rem; }
        .profile-pic-icon { width: 40px; height: 40px; border-radius: 50%; }
        .profile-icon { font-size: 2rem; color: white; }
        .filters-bar {
            display: flex; flex-wrap: wrap; gap: 0.7rem;
            padding: 1rem 2rem; background-color: #fff;
            align-items: center; box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
            justify-content: center;
        }
        .filter-select {
            min-width: 50px; max-width: 120px;
            padding: 0.4rem 0.5rem; font-size: 0.85rem;
            border-radius: 4px; border: 1px solid #ccc;
        }
        .search-wrapper {
            flex: 1 1 300px; max-width: 600px; min-width: 300px;
            position: relative;
        }
        .search-input {
            width: 100%; padding: 0.5rem 2.2rem 0.5rem 0.8rem;
            font-size: 0.95rem; border-radius: 6px; border: 1px solid #ccc;
        }
        .search-button {
            position: absolute; right: 6px; top: 50%;
            transform: translateY(-50%);
            border: none; background: none; color: #244C45;
            font-size: 1rem; cursor: pointer;
        }
        .products-grid {
            display: flex; flex-wrap: wrap;
            gap: 1.5rem; justify-content: flex-start;
            padding: 2rem;
        }
        .product-card {
            display: flex; flex-direction: column; justify-content: space-between;
            width: 220px; height: 400px;
            background-color: white; border-radius: 12px;
            padding: 1rem; box-shadow: 0 0 6px rgba(0,0,0,0.1);
            cursor: pointer;
        }
        .product-img {
            height: 180px; width: 100%;
            object-fit: contain; margin-bottom: 0.5rem;
        }
        .product-info {
            flex-grow: 1; display: flex; flex-direction: column;
            align-items: center; gap: 0.3rem; text-align: center;
        }
        .product-actions {
            display: flex; flex-direction: column; gap: 0.4rem;
        }
        .product-actions form button {
            width: 100%; background-color: #244C45;
            color: white; border: none; border-radius: 4px;
            padding: 0.6rem 1.2rem; font-size: 0.85rem;
            display: flex; align-items: center; justify-content: center;
            gap: 0.4rem; cursor: pointer;
        }
        .product-actions form button:hover { background-color: #1f3d39; }
        .custom-popup.success { background-color: #2ecc71; }
		.range-slider-container {
		    width: 250px;
		    position: relative;
		    margin-bottom: 1rem;
		}

		.range-slider {
		    height: 5px;
		    position: relative;
		    background-color: #ddd;
		    border-radius: 3px;
		}

		.range-slider-track {
		    height: 100%;
		    position: absolute;
		    background-color: #007bff;
		    border-radius: 3px;
		}

		.range-slider-thumb {
		    width: 18px;
		    height: 18px;
		    background-color: #007bff;
		    border-radius: 50%;
		    position: absolute;
		    top: 50%;
		    transform: translate(-50%, -50%);
		    cursor: pointer;
		}

		.price-values {
		    display: flex;
		    justify-content: center;
		    gap: 1rem;
		    margin-top: 0.4rem;
		    font-weight: bold;
		    color: #1f4a45;
		}
		.profile-dropdown {
		    position: relative;
		    display: inline-block;
		}

		.profile-menu {
		    display: none;
		    position: absolute;
		    right: 0;
		    top: 110%;
		    background: white;
		    min-width: 180px;
		    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
		    border-radius: 10px;
		    overflow: hidden;
		    z-index: 999;
		    transform-origin: top right;
		    transform: scale(0.95);
		    opacity: 0;
		    transition: all 0.2s ease;
		}

		.profile-menu.show {
		    display: block;
		    transform: scale(1);
		    opacity: 1;
		}

		.profile-menu a {
		    color: #244C45;
		    padding: 12px 18px;
		    text-decoration: none;
		    display: flex;
		    align-items: center;
		    gap: 10px;
		    font-size: 0.95rem;
		    border-bottom: 1px solid #f1f1f1;
		    transition: background-color 0.2s ease;
		}

		.profile-menu a:last-child {
		    border-bottom: none;
		}

		.profile-menu a:hover {
		    background-color: #f9f9f9;
		}

		.profile-menu::before {
		    content: "";
		    position: absolute;
		    top: -8px;
		    right: 16px;
		    width: 14px;
		    height: 14px;
		    background: white;
		    transform: rotate(45deg);
		    box-shadow: -2px -2px 5px rgba(0,0,0,0.03);
		}

		.profile-link {
		    cursor: pointer;
		    display: flex;
		    align-items: center;
		}

    </style>
</head>

<body class="layout-body d-flex flex-column min-vh-100">
<jsp:include page="/load-sidebar" />

<div class="main-content flex-grow-1" id="mainContent">
    <header class="custom-header">
        <div class="header-left">
            <a href="${pageContext.request.contextPath}/home">
                <img src="${pageContext.request.contextPath}/images/reluvd-logo.png" alt="ReLuvd Logo" class="logo"/>
            </a>
            <div class="brand-text">
                <h1>ReLuvd</h1>
                <p>Because OLD is the new NEW!</p>
            </div>
        </div>
		<div class="right">
		    <div class="brand-text">
		        <h2 style="font-size: 1.5rem;">Hey, ${username}</h2>
		    </div>

		    <c:if test="${not empty user}">
		        <div class="profile-dropdown" id="profileDropdown">
		            <a class="profile-link" id="profileToggle">
		                <c:choose>
		                    <c:when test="${not empty user.profilePictureUrl}">
		                       <img src="${pageContext.request.contextPath}/file/image/uploads/${user.profilePictureUrl}" alt="Profile" class="profile-pic-icon"/>
							   
						   </c:when>
		                    <c:otherwise>
		                        <i class="fas fa-user-circle profile-icon"></i>
		                    </c:otherwise>
		                </c:choose>
		            </a>

		            <div class="profile-menu" id="profileMenu">
		                <a href="${pageContext.request.contextPath}/my-profile"><i class="fas fa-user"></i> My Profile</a>
		                <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
		            </div>
		        </div>
		    </c:if>

		    <c:if test="${empty user}">
		        <a href="${pageContext.request.contextPath}/login?redirect=/my-profile" class="profile-link">
		            <i class="fas fa-user-circle profile-icon"></i>
		        </a>
		    </c:if>
		</div>

    </header>

    <!-- FILTER BAR -->
    <form method="get" action="${pageContext.request.contextPath}/home" class="filters-bar">
        <div class="search-wrapper">
            <input type="text" name="query" class="search-input" placeholder="Search..." value="${param.query}" />
            <button type="submit" class="search-button"><i class="fas fa-search"></i></button>
        </div>

        <!-- All filters below, fully preserved -->
        <select class="filter-select" name="gender" onchange="this.form.submit()">
            <option value="">Gender</option>
            <option <c:if test="${param.gender == 'Men'}">selected</c:if>>Men</option>
            <option <c:if test="${param.gender == 'Women'}">selected</c:if>>Women</option>
            <option <c:if test="${param.gender == 'Unisex'}">selected</c:if>>Unisex</option>
            <option <c:if test="${param.gender == 'Kids'}">selected</c:if>>Kids</option>
        </select>

        <select class="filter-select" name="type" onchange="this.form.submit()">
            <option value="">Clothing Type</option>
            <option <c:if test="${param.type == 'Shirt'}">selected</c:if>>Shirt</option>
            <option <c:if test="${param.type == 'T-Shirt'}">selected</c:if>>T-Shirt</option>
            <option <c:if test="${param.type == 'Shorts'}">selected</c:if>>Shorts</option>
            <option <c:if test="${param.type == 'Top'}">selected</c:if>>Top</option>
            <option <c:if test="${param.type == 'Pants'}">selected</c:if>>Pants</option>
            <option <c:if test="${param.type == 'Jeans'}">selected</c:if>>Jeans</option>
            <option <c:if test="${param.type == 'Jacket'}">selected</c:if>>Jacket</option>
            <option <c:if test="${param.type == 'Dress'}">selected</c:if>>Dress</option>
            <option <c:if test="${param.type == 'Skirt'}">selected</c:if>>Skirt</option>
            <option <c:if test="${param.type == 'Saree'}">selected</c:if>>Saree</option>
            <option <c:if test="${param.type == 'Kurta'}">selected</c:if>>Kurta</option>
            <option <c:if test="${param.type == 'Hoodie'}">selected</c:if>>Hoodie</option>
            <option <c:if test="${param.type == 'Sweater'}">selected</c:if>>Sweater</option>
            <option <c:if test="${param.type == 'Sweatshirt'}">selected</c:if>>Sweatshirt</option>
        </select>

        <select class="filter-select" name="size" onchange="this.form.submit()">
            <option value="">Size</option>
            <option <c:if test="${param.size == 'XS'}">selected</c:if>>XS</option>
            <option <c:if test="${param.size == 'S'}">selected</c:if>>S</option>
            <option <c:if test="${param.size == 'M'}">selected</c:if>>M</option>
            <option <c:if test="${param.size == 'L'}">selected</c:if>>L</option>
            <option <c:if test="${param.size == 'XL'}">selected</c:if>>XL</option>
            <option <c:if test="${param.size == 'XXL'}">selected</c:if>>XXL</option>
        </select>

        <select class="filter-select" name="condition" onchange="this.form.submit()">
            <option value="">Condition</option>
            <option <c:if test="${param.condition == 'New with Tags'}">selected</c:if>>New with Tags</option>
            <option <c:if test="${param.condition == 'New without Tags'}">selected</c:if>>New without Tags</option>
            <option <c:if test="${param.condition == 'Gently Used'}">selected</c:if>>Gently Used</option>
            <option <c:if test="${param.condition == 'Good'}">selected</c:if>>Good</option>
            <option <c:if test="${param.condition == 'Fair'}">selected</c:if>>Fair</option>
        </select>

        <select class="filter-select" name="sort" onchange="this.form.submit()">
            <option value="">Sort By</option>
            <option <c:if test="${param.sort == 'Newest First'}">selected</c:if>>Newest First</option>
            <option <c:if test="${param.sort == 'Oldest First'}">selected</c:if>>Oldest First</option>
            <option <c:if test="${param.sort == 'Price Low to High'}">selected</c:if>>Price Low to High</option>
            <option <c:if test="${param.sort == 'Price High to Low'}">selected</c:if>>Price High to Low</option>
        </select>

        <select class="filter-select" name="material" onchange="this.form.submit()">
            <option value="">Material</option>
            <c:forEach var="mat" items="${materials}">
                <option value="${mat}" <c:if test="${param.material == mat}">selected</c:if>>${mat}</option>
            </c:forEach>
        </select>

        <select class="filter-select" name="color" onchange="this.form.submit()">
            <option value="">Color</option>
            <c:forEach var="color" items="${colors}">
                <option value="${color}" <c:if test="${param.color == color}">selected</c:if>>${color}</option>
            </c:forEach>
        </select>

        <select class="filter-select" name="brand" onchange="this.form.submit()">
            <option value="">Brand</option>
            <c:forEach var="brand" items="${brands}">
                <option value="${brand}" <c:if test="${param.brand == brand}">selected</c:if>>${brand}</option>
            </c:forEach>
        </select>

		

        <button type="button" class="filter-select" style="background-color: #e74c3c; color: white;"
                onclick="window.location.href='${pageContext.request.contextPath}/home'">
            Clear Filters
        </button>
    </form>

    <div class="products-grid">
        <c:forEach var="item" items="${listings}">
            <c:if test="${user == null || item.user.id != user.id}">
                <div class="product-card" onclick="window.location.href='${pageContext.request.contextPath}/view-item/${item.id}?source=home'">
                   <img src="${pageContext.request.contextPath}/file/image/listings/${item.imageUrl}" alt="${item.title}" class="product-img"/>
				   
				   <div class="product-info">
                        <h4>${item.title}</h4>
                        <p>₹${item.price}</p>
                    </div>
					<div class="product-actions">
					    <c:if test="${item.availability == 'Available'}">
					        <form onsubmit="event.preventDefault(); event.stopPropagation(); addToCart(${item.id});">
					            <button type="button" class="add-to-cart-btn" data-id="${item.id}" onclick="event.stopPropagation(); addToCart(${item.id});">
					                <i class="fas fa-cart-shopping"></i> Add to Cart
					            </button>
					        </form>
							<c:choose>
							    <c:when test="${not empty user}">
							        <form method="post" action="${pageContext.request.contextPath}/cart/buy-now" onclick="event.stopPropagation();">
							            <input type="hidden" name="itemId" value="${item.id}" />
							            <button type="submit"><i class="fas fa-bag-shopping"></i> Buy Now</button>
							        </form>
							    </c:when>
							    <c:otherwise>
							        <form method="get" action="${pageContext.request.contextPath}/login" onclick="event.stopPropagation();">
							            <input type="hidden" name="redirect" value="/cart/buy-now?itemId=${item.id}" />
							            <button type="submit"><i class="fas fa-bag-shopping"></i> Buy Now</button>
							        </form>
							    </c:otherwise>
							</c:choose>

					    </c:if>

					    <c:if test="${item.availability == 'Sold'}">
							<p style="color: red; font-weight: bold;">Sold Out</p>

					    </c:if>
					</div>

                </div>
            </c:if>
        </c:forEach>
		<c:if test="${empty listings}">
		    <div class="empty-state">
		        <i class="fas fa-box-open"></i>
		        <p>No items found. Try adjusting your filters.</p>
		    </div>
		</c:if>



    </div>


	<c:if test="${totalPages > 1}">
	    <div style="display: flex; justify-content: center; margin-bottom: 2rem;">
	        <nav>
	            <ul class="pagination" style="display: flex; gap: 0.5rem; list-style: none;">
	                <c:if test="${currentPage > 1}">
	                    <li>
	                        <a href="?page=${currentPage - 1}&query=${param.query}&gender=${param.gender}&type=${param.type}&size=${param.size}&condition=${param.condition}&sort=${param.sort}&material=${param.material}&color=${param.color}&brand=${param.brand}"
	                           style="padding: 0.5rem 0.75rem; border: 1px solid #ccc; border-radius: 4px;">&laquo; Prev</a>
	                    </li>
	                </c:if>
	                <c:forEach var="i" begin="1" end="${totalPages}">
	                    <li>
	                        <a href="?page=${i}&query=${param.query}&gender=${param.gender}&type=${param.type}&size=${param.size}&condition=${param.condition}&sort=${param.sort}&material=${param.material}&color=${param.color}&brand=${param.brand}"
	                           style="padding: 0.5rem 0.75rem; border: 1px solid #ccc; border-radius: 4px; <c:if test='${i == currentPage}'>background-color: #244C45; color: white;</c:if>">
	                            ${i}
	                        </a>
	                    </li>
	                </c:forEach>
	                <c:if test="${currentPage < totalPages}">
	                    <li>
	                        <a href="?page=${currentPage + 1}&query=${param.query}&gender=${param.gender}&type=${param.type}&size=${param.size}&condition=${param.condition}&sort=${param.sort}&material=${param.material}&color=${param.color}&brand=${param.brand}"
	                           style="padding: 0.5rem 0.75rem; border: 1px solid #ccc; border-radius: 4px;">Next &raquo;</a>
	                    </li>
	                </c:if>
	            </ul>
	        </nav>
	    </div>
	</c:if>

</div>

<div class="mt-auto">
    <%@ include file="/WEB-INF/views/includes/footer.jsp" %>
</div>
<script>
    const contextPath = "${pageContext.request.contextPath}";

	// Restore scroll position if returning from item page
	   window.addEventListener('load', function () {
	       const hash = window.location.hash;
	       if (hash.startsWith("#scrollTo=")) {
	           const y = parseInt(hash.replace("#scrollTo=", ""));
	           window.scrollTo(0, y);
	       }
	   });

	   // Save scroll position before navigating to item page
	   document.querySelectorAll('.product-card').forEach(card => {
	       card.addEventListener('click', () => {
	           sessionStorage.setItem('scrollPos', window.scrollY);
	       });
	   });
    function addToCart(listingId) {
        fetch(contextPath + "/cart/add-to-cart", {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
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
        popup.style.backgroundColor = (type === "success") ? "#244C45" : "#e74c3c";
        document.body.appendChild(popup);
        setTimeout(() => popup.classList.add("show"), 100);
        setTimeout(() => {
            popup.classList.remove("show");
            setTimeout(() => popup.remove(), 500);
        }, 3000);
    }
	const profileToggle = document.getElementById('profileToggle');
	const profileMenu = document.getElementById('profileMenu');
	const profileDropdown = document.getElementById('profileDropdown');

	if (profileToggle && profileMenu && profileDropdown) {
	    profileToggle.addEventListener('click', function (event) {
	        event.preventDefault();
	        event.stopPropagation();
	        profileMenu.classList.toggle('show');
	    });

	    document.addEventListener('click', function (event) {
	        if (!profileDropdown.contains(event.target)) {
	            profileMenu.classList.remove('show');
	        }
	    });
	}
</script>

</body>
</html>
