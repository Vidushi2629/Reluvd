<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sell an Item | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Fonts & Styles -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        html, body { height: 100%; margin: 0; padding: 0; }
        .form-container { padding-left: 1rem; max-width: 100%; }
        .form-box { width: 100%; max-width: 2000px; }
    </style>
	
</head>
<body>

<!-- Sidebar and Header -->
<jsp:include page="/load-sidebar" />

<div class="main-content">
	<%@ include file="/WEB-INF/views/includes/header.jsp" %>
    

    <div class="mb-4" style="margin-left: 1rem;">
        <h2 class="fw-bold">Sell an Item</h2>
        <p class="text-muted">
            <c:choose>
                <c:when test="${not empty item.id}">Edit your item listing below</c:when>
                <c:otherwise>Fill in the details to list your item for sale</c:otherwise>
            </c:choose>
        </p>
    </div>

    <div class="form-container">
        <div class="card shadow-lg form-box">
            <div class="card-body px-4 py-5">
                <form method="post" action="${pageContext.request.contextPath}/submit-item" enctype="multipart/form-data">

                    <c:if test="${not empty item.id}">
                        <input type="hidden" name="id" value="${item.id}" />
                    </c:if>

                    <c:if test="${not empty item.imageUrl}">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Current Image</label><br>
                           <img src="${pageContext.request.contextPath}/file/image/listings/${item.imageUrl}"
                                 alt="Item Image" style="max-width: 200px; border-radius: 8px;" />
                        </div>
                    </c:if>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Upload Image</label>
                        <input type="file" class="form-control" name="image" accept="image/*"
                               <c:if test="${empty item.id}">required</c:if>>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Item Title</label>
                        <input type="text" class="form-control" name="title" value="${item.title}" placeholder="e.g. Blue Denim Jacket" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Clothing Type</label>
                        <select class="form-select" name="clothingType" required>
                            <option value="">-- Select Clothing Type --</option>
                            <c:forEach var="type" items="${['Shirt','T-Shirt','Top','Shorts','Pants','Jeans','Jacket','Dress','Skirt','Saree','Kurta','Hoodie','Sweater','Sweatshirt']}">
                                <option value="${type}" <c:if test="${item.clothingType eq type}">selected</c:if>>${type}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Size</label>
                        <select class="form-select" name="size" required>
                            <option value="">-- Select Size --</option>
                            <c:forEach var="sz" items="${['XS','S','M','L','XL','XXL','Free Size']}">
                                <option value="${sz}" <c:if test="${item.size eq sz}">selected</c:if>>${sz}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Item Color</label>
                        <input type="text" class="form-control" name="color" value="${item.color}" placeholder="e.g. Blue" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Brand</label>
                        <input type="text" class="form-control" name="brand" value="${item.brand}" placeholder="e.g. Zara, H&M, Local Designer" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Material</label>
                        <input type="text" class="form-control" name="material" value="${item.material}" placeholder="e.g. Cotton, Denim, Silk" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Gender</label>
                        <select class="form-select" name="gender" required>
                            <option value="">-- Select --</option>
                            <c:forEach var="g" items="${['Men','Women','Unisex','Kids']}">
                                <option value="${g}" <c:if test="${item.gender eq g}">selected</c:if>>${g}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Condition</label>
                        <div class="d-flex flex-wrap gap-3">
                            <c:forEach var="cond" items="${['New with Tags','New without Tags','Gently Used','Good','Fair']}">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="condition" value="${cond}" 
                                           <c:if test="${item.condition eq cond}">checked</c:if> required>
                                    <label class="form-check-label">${cond}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Price (Rs)</label>
                        <input type="number" class="form-control" name="price" min="0" step="0.01" value="${item.price}" placeholder="e.g. 999" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea class="form-control" name="description" rows="4" placeholder="Details like material, brand, etc." required>${item.description}</textarea>
                    </div>

                    <button type="submit" class="save-btn w-100 mt-5" style="border-radius: 14px;height: 52px;">
                        <i class="bi bi-upload me-2"></i>
                        <c:choose>
                            <c:when test="${not empty item.id}">Update Item</c:when>
                            <c:otherwise>Post Item</c:otherwise>
                        </c:choose>
                    </button>
                </form>
            </div>
        </div>
    </div>
	<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
