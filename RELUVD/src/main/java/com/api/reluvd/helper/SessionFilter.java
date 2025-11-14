package com.api.reluvd.helper;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.api.reluvd.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class SessionFilter implements Filter {

    private static final List<String> PUBLIC = List.of(
        "/", "/home", "/login", "/register", "/forgot-password", "/reset-password",
        "/check-login", "/send-otp", "/send-reset-otp", "/verify-otp"
    );

    private static final List<String> GUEST = List.of(
        "/cart", "/cart/add-to-cart", "/cart/save", "/cart/delete", "/cart/move-to-cart"
    );

    private static final Map<String, String> ROLE_PATHS = Map.ofEntries(
        Map.entry("/admin", "admin"),
        Map.entry("/my-orders", "user"),
        Map.entry("/my-listings", "user"),
        Map.entry("/sell-item", "user"),
        Map.entry("/my-messages", "user")
    );

    private static final List<String> SHARED_PATHS = List.of(
        "/my-profile", "/logout"
    );

    private static final List<String> STATIC_EXTENSIONS = List.of(
    	    ".css", ".js", ".png", ".jpg", ".jpeg", ".webp"
    	);

    private boolean isStaticResource(String path) {
        String lower = path.toLowerCase();
        return lower.matches(".*(\\.css|\\.js|\\.png|\\.jpg|\\.jpeg|\\.webp)$")
            || lower.startsWith("/css/")
            || lower.startsWith("/js/")
            || lower.startsWith("/images/");
    }


    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String path = request.getRequestURI().substring(contextPath.length());
        String pathLower = path.toLowerCase();

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        String role = (user == null || user.getRole() == null) ? "" : user.getRole().toLowerCase();

        if (isStaticResource(path)) {
            chain.doFilter(req, res);
            return;
        }
        if (pathLower.startsWith("/admin") && !"admin".equals(role)) {
            response.sendRedirect(contextPath + "/access-denied");
            return;
        }
        if ((pathLower.startsWith("/my-orders") ||
             pathLower.startsWith("/my-listings") ||
             pathLower.startsWith("/sell-item") ||
             pathLower.startsWith("/my-messages")) &&
            (!"user".equals(role) && !"admin".equals(role))) {
            response.sendRedirect(contextPath + "/access-denied");
            return;
        }
        if (PUBLIC.stream().anyMatch(pathLower::startsWith)) {
            chain.doFilter(req, res);
            return;
        }
        if (GUEST.stream().anyMatch(pathLower::startsWith)) {
            chain.doFilter(req, res);
            return;
        }

        if (user == null) {
            response.sendRedirect(contextPath + "/access-denied");
            return;
        }

        boolean isRolePath = ROLE_PATHS.keySet().stream().anyMatch(pathLower::startsWith);
        if (isRolePath) {
            String requiredRole = ROLE_PATHS.entrySet().stream()
                    .filter(e -> pathLower.startsWith(e.getKey()))
                    .map(Map.Entry::getValue)
                    .findFirst().orElse("");

            if ("user".equals(requiredRole) && !"user".equals(role)) {
                response.sendRedirect(contextPath + "/access-denied");
                return;
            }

            if ("admin".equals(requiredRole) && !"admin".equals(role)) {
                response.sendRedirect(contextPath + "/access-denied");
                return;
            }
        }

        if (SHARED_PATHS.stream().anyMatch(pathLower::startsWith)) {
            if (!"user".equals(role) && !"admin".equals(role)) {
                response.sendRedirect(contextPath + "/access-denied");
                return;
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void destroy() {}
}