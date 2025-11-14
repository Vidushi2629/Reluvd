<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Cart | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <style>
        html, body {
            height: 100%;
            margin: 0;
        }

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

        footer {
            background-color: #244C45;
            color: white;
            text-align: center;
            padding: 1rem;
        }

        .cart-container {
            flex: 1;
            display: flex;
            gap: 2rem;
            align-items: flex-start;
            padding: 1rem;
        }

        .cart-items, .saved-items {
            flex: 9;
            background: #fff;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 2rem;
        }

        .cart-summary {
            flex: 1;
            background: #f9f9f9;
            padding: 1rem;
            border-radius: 10px;
            border: 1px solid #ddd;
            height: fit-content;
            min-width: 300px;
            position: sticky;
            top: 100px;
            align-self: flex-start;
            margin-right: 1.5rem;
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

        .btn, .btn-success, .btn-primary {
            background-color: #244C45 !important;
            border: none !important;
        }

        .btn-danger {
            background-color: #D64545 !important;
            color: #fff !important;
        }

        .promo-error {
            color: red;
            font-size: 0.9rem;
            margin-top: 0.3rem;
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="/load-sidebar"/>

    <div class="main-content">
        <%@ include file="/WEB-INF/views/includes/header.jsp" %>

        <form method="post" action="${pageContext.request.contextPath}/cart/proceed-to-buy">
            <div class="container-fluid cart-container">
                <div class="w-100">
                    <div class="cart-items">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4>Shopping Cart</h4>
                            <div>
                                <label class="form-check-label">
                                    <input class="form-check-input me-1" type="checkbox" id="selectAllCheckbox">
                                    Select all items
                                </label>
                            </div>
                        </div>

                        <c:if test="${empty cartItems}">
                            <p class="text-muted text-center">No items in your shopping cart.</p>
                        </c:if>

                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item">
                                <input type="checkbox" class="form-check-input itemCheckbox" name="selectedItems" value="${item.id}" checked />
                                <img src="${pageContext.request.contextPath}/file/image/listings/${item.imageUrl}" alt="${item.title}" />
								
								<div style="flex-grow:1;">
                                    <h6>${item.title}</h6>
                                    <p class="text-muted">Colour: ${item.color}</p>
                                </div>
                                <div style="display: flex; flex-direction: column; align-items: flex-end; width: 140px;">
                                    <p>₹${item.price}</p>
                                    <form method="post" action="${pageContext.request.contextPath}/cart/save" style="width: 100%;">
                                        <input type="hidden" name="listingId" value="${item.id}" />
                                        <button class="btn btn-success btn-sm fw-bold w-100" type="submit">Save for later</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/cart/delete" style="width: 100%;">
                                        <input type="hidden" name="listingId" value="${item.id}" />
                                        <button class="btn btn-danger btn-sm fw-bold w-100" type="submit">Delete</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="saved-items">
                        <h5>Saved for Later</h5>
                        <c:if test="${empty savedItems}">
                            <p class="text-muted text-center">No items in your saved list.</p>
                        </c:if>

                        <c:forEach var="item" items="${savedItems}">
                            <div class="cart-item">
                                <img src="${pageContext.request.contextPath}/file/image/listings/${item.imageUrl}" alt="${item.title}" />
								
                                 <div style="flex-grow:1;">
                                    <h6>${item.title}</h6>
                                    <p class="text-muted">Colour: ${item.color}</p>
                                </div>
                                <div style="display: flex; flex-direction: column; align-items: flex-end; width: 140px;">
                                    <p>₹${item.price}</p>
                                    <form method="post" action="${pageContext.request.contextPath}/cart/move-to-cart" style="width: 100%;">
                                        <input type="hidden" name="listingId" value="${item.id}" />
                                        <button class="btn btn-primary btn-sm fw-bold w-100" type="submit">Move to Cart</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/cart/delete" style="width: 100%;">
                                        <input type="hidden" name="listingId" value="${item.id}" />
                                        <button class="btn btn-danger btn-sm fw-bold w-100" type="submit">Delete</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

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
                    <button type="submit" class="btn btn-success w-100 mt-3 fw-bold" onclick="return removeUnchecked()">Proceed to Buy</button>
                </div>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const selectAll = document.getElementById("selectAllCheckbox");
        const itemCheckboxes = document.querySelectorAll(".itemCheckbox");

        selectAll.checked = true;
        itemCheckboxes.forEach(cb => cb.checked = true);

        selectAll.addEventListener("change", function () {
            const isChecked = this.checked;
            itemCheckboxes.forEach(cb => cb.checked = isChecked);
        });

        itemCheckboxes.forEach(cb => {
            cb.addEventListener("change", () => {
                const allChecked = Array.from(itemCheckboxes).every(cb => cb.checked);
                selectAll.checked = allChecked;
            });
        });
    });

    function removeUnchecked() {
        document.querySelectorAll(".itemCheckbox").forEach(cb => {
            if (!cb.checked) {
                cb.parentNode.removeChild(cb);
            }
        });
        return true;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
