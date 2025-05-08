package com.hotel.controller;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import com.hotel.model.User;
import com.hotel.model.UserDAO;
import com.hotel.util.FileUploadUtil;
import com.hotel.util.SessionUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit tests for UserController
 */
public class UserControllerTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher dispatcher;

    @Mock
    private UserDAO userDAO;

    @Mock
    private Part filePart;

    private UserController userController;
    private StringWriter stringWriter;
    private PrintWriter writer;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        userController = new UserController();

        // Set up response writer
        stringWriter = new StringWriter();
        writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        // Set up request and session
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        // Set up userDAO
        userController.setUserDAO(userDAO);
    }

    @Test
    public void testDoGet_Login() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/login");

        // Act
        userController.doGet(request, response);

        // Assert
        verify(request).getRequestDispatcher("/login.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_Register() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/register");

        // Act
        userController.doGet(request, response);

        // Assert
        verify(request).getRequestDispatcher("/register.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_Profile_NotLoggedIn() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/profile");
        when(session.getAttribute("userId")).thenReturn(null);

        // Act
        userController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_Profile_LoggedIn() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/profile");
        when(session.getAttribute("userId")).thenReturn(1);

        User user = new User();
        user.setId(1);
        user.setName("Test User");
        user.setEmail("test@example.com");

        when(userDAO.getById(1)).thenReturn(user);

        // Act
        userController.doGet(request, response);

        // Assert
        verify(request).setAttribute("user", user);
        verify(request).getRequestDispatcher("/profile.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_Logout() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/logout");

        // Act
        userController.doGet(request, response);

        // Assert
        verify(session).invalidate();
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_AdminUsers_NotAdmin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/users");
        when(session.getAttribute("userRole")).thenReturn("USER");

        // Act
        userController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_AdminUsers_Admin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/users");
        when(session.getAttribute("userRole")).thenReturn("ADMIN");

        List<User> users = new ArrayList<>();
        users.add(new User());
        users.add(new User());

        when(userDAO.getAll()).thenReturn(users);

        // Act
        userController.doGet(request, response);

        // Assert
        verify(request).setAttribute("users", users);
        verify(request).getRequestDispatcher("/admin/users.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_Login_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/login");
        when(request.getParameter("email")).thenReturn("test@example.com");
        when(request.getParameter("password")).thenReturn("password123");

        User user = new User();
        user.setId(1);
        user.setName("Test User");
        user.setEmail("test@example.com");
        user.setRole("USER");

        when(userDAO.authenticate("test@example.com", "password123")).thenReturn(user);

        // Act
        userController.doPost(request, response);

        // Assert
        verify(session).setAttribute("userId", 1);
        verify(session).setAttribute("userName", "Test User");
        verify(session).setAttribute("userEmail", "test@example.com");
        verify(session).setAttribute("userRole", "USER");
        verify(response).sendRedirect(contains("/index.jsp"));
    }

    @Test
    public void testDoPost_Login_Failure() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/login");
        when(request.getParameter("email")).thenReturn("test@example.com");
        when(request.getParameter("password")).thenReturn("wrongpassword");

        when(userDAO.authenticate("test@example.com", "wrongpassword")).thenReturn(null);

        // Act
        userController.doPost(request, response);

        // Assert
        verify(request).setAttribute("error", "Invalid email or password");
        verify(request).getRequestDispatcher("/login.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_Register_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/register");
        when(request.getParameter("name")).thenReturn("New User");
        when(request.getParameter("email")).thenReturn("new@example.com");
        when(request.getParameter("password")).thenReturn("password123");
        when(request.getParameter("confirmPassword")).thenReturn("password123");

        when(userDAO.isEmailInUse("new@example.com")).thenReturn(false);
        when(userDAO.create(any(User.class))).thenReturn(1);

        // Act
        userController.doPost(request, response);

        // Assert
        verify(userDAO).create(any(User.class));
        verify(response).sendRedirect(contains("/login?message="));
    }

    @Test
    public void testDoPost_Register_PasswordMismatch() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/register");
        when(request.getParameter("name")).thenReturn("New User");
        when(request.getParameter("email")).thenReturn("new@example.com");
        when(request.getParameter("password")).thenReturn("password123");
        when(request.getParameter("confirmPassword")).thenReturn("differentpassword");

        // Act
        userController.doPost(request, response);

        // Assert
        verify(request).setAttribute("error", "Passwords do not match");
        verify(request).getRequestDispatcher("/register.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_Register_EmailInUse() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/register");
        when(request.getParameter("name")).thenReturn("New User");
        when(request.getParameter("email")).thenReturn("existing@example.com");
        when(request.getParameter("password")).thenReturn("password123");
        when(request.getParameter("confirmPassword")).thenReturn("password123");

        when(userDAO.isEmailInUse("existing@example.com")).thenReturn(true);

        // Act
        userController.doPost(request, response);

        // Assert
        verify(request).setAttribute("error", "Email is already registered");
        verify(request).getRequestDispatcher("/register.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_UpdateProfile_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/updateProfile");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("name")).thenReturn("Updated User");
        when(request.getParameter("email")).thenReturn("updated@example.com");

        User user = new User();
        user.setId(1);
        user.setName("Test User");
        user.setEmail("test@example.com");
        user.setRole("USER");

        when(userDAO.getById(1)).thenReturn(user);
        when(userDAO.isEmailInUseByAnother("updated@example.com", 1)).thenReturn(false);
        when(userDAO.update(any(User.class))).thenReturn(true);

        // Act
        userController.doPost(request, response);

        // Assert
        verify(userDAO).update(any(User.class));
        verify(response).sendRedirect(contains("/profile?message="));
    }
}
