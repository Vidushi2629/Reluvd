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

<style>
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

    .profile-pic-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
    }

    .profile-icon {
        font-size: 2rem;
        color: white;
    }

    .profile-link {
        cursor: pointer;
        display: flex;
        align-items: center;
    }
</style>

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

        <div class="profile-dropdown" id="profileDropdown">
            <a class="profile-link" id="profileToggle">
                <c:choose>
                    <c:when test="${not empty user and not empty user.profilePictureUrl}">
                       <!-- <img src="${pageContext.request.contextPath}/file/image/uploads/${user.profilePictureUrl}" 
                             alt="Profile" class="profile-pic-icon"/>-->
							 <img src="${user.profilePictureUrl}" alt="Profile" class="profile-pic-icon"/>

                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-user-circle profile-icon"></i>
                    </c:otherwise>
                </c:choose>
            </a>

            <div class="profile-menu" id="profileMenu">
                <c:choose>
                    <c:when test="${not empty user}">
                        <a href="${pageContext.request.contextPath}/my-profile">
                            <i class="fas fa-user"></i> My Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login?redirect=my-profile">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>

<script>
    const profileToggle = document.getElementById('profileToggle');
    const profileMenu = document.getElementById('profileMenu');
    const profileDropdown = document.getElementById('profileDropdown');

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
</script>
