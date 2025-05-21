package com.hotel.filter;

import com.hotel.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filter to protect admin pages
 */
@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code, if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Check if the user is an admin
        if (SessionUtil.isAdmin(httpRequest)) {
            // User is an admin, proceed with the request
            chain.doFilter(request, response);
        } else {
            // User is not an admin, redirect to admin login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/adminpanel");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
}
-