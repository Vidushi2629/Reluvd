<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<div class="sidebar">
    <c:forEach var="menu" items="${menus}">
        <a href="${pageContext.request.contextPath}${menu.url}">
            <i class="${menu.icon}"></i>
            <span>${menu.name}</span>
        </a>
    </c:forEach>
</div>
