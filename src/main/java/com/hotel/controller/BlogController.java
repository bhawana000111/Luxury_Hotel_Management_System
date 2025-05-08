package com.hotel.controller;

import com.hotel.model.Blog;
import com.hotel.model.BlogDAO;
import com.hotel.util.FileUploadUtil;
import com.hotel.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for blog-related operations
 */
@WebServlet(name = "BlogController", urlPatterns = {
    "/blog", "/blogPost", "/admin/blog", "/admin/addBlog", "/admin/editBlog", "/admin/deleteBlog"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 10 * 1024 * 1024,   // 10 MB
    maxRequestSize = 20 * 1024 * 1024 // 20 MB
)
public class BlogController extends HttpServlet {
    
    private BlogDAO blogDAO;
    
    @Override
    public void init() {
        blogDAO = new BlogDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/blog":
                listBlogPosts(request, response);
                break;
            case "/blogPost":
                showBlogPost(request, response);
                break;
            case "/admin/blog":
                listBlogPostsAdmin(request, response);
                break;
            case "/admin/addBlog":
                showAddBlogForm(request, response);
                break;
            case "/admin/editBlog":
                showEditBlogForm(request, response);
                break;
            case "/admin/deleteBlog":
                deleteBlogPost(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/admin/addBlog":
                addBlogPost(request, response);
                break;
            case "/admin/editBlog":
                editBlogPost(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    /**
     * List all blog posts for guests
     */
    private void listBlogPosts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Blog> blogs = blogDAO.getAll();
        request.setAttribute("blogs", blogs);
        request.getRequestDispatcher("/blog.jsp").forward(request, response);
    }
    
    /**
     * Show a specific blog post
     */
    private void showBlogPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int blogId = Integer.parseInt(idParam);
                Blog blog = blogDAO.getById(blogId);
                
                if (blog != null) {
                    request.setAttribute("blog", blog);
                    request.getRequestDispatcher("/blog_post.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/blog?error=Blog post not found");
    }
    
    /**
     * List all blog posts for admin
     */
    private void listBlogPostsAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        List<Blog> blogs = blogDAO.getAll();
        request.setAttribute("blogs", blogs);
        request.getRequestDispatcher("/admin/blog.jsp").forward(request, response);
    }
    
    /**
     * Show add blog form (admin only)
     */
    private void showAddBlogForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        request.getRequestDispatcher("/admin/add_blog.jsp").forward(request, response);
    }
    
    /**
     * Add a new blog post (admin only)
     */
    private void addBlogPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String videoUrl = request.getParameter("videoUrl");
        
        // Validate input
        if (title == null || title.trim().isEmpty() ||
            content == null || content.trim().isEmpty()) {
            
            request.setAttribute("error", "Title and content are required");
            request.getRequestDispatcher("/admin/add_blog.jsp").forward(request, response);
            return;
        }
        
        // Create blog post
        String author = (String) request.getSession().getAttribute("userName");
        Blog blog = new Blog(title, content, author);
        blog.setVideoUrl(videoUrl);
        
        // Upload blog image if provided
        try {
            String imagePath = FileUploadUtil.uploadFile(request, "blogImage", "images");
            if (imagePath != null) {
                blog.setImagePath(imagePath);
            }
        } catch (Exception e) {
            // Ignore if file upload fails
        }
        
        int blogId = blogDAO.create(blog);
        
        if (blogId > 0) {
            response.sendRedirect(request.getContextPath() + 
                                 "/admin/blog?message=Blog post added successfully");
        } else {
            request.setAttribute("error", "Failed to add blog post");
            request.getRequestDispatcher("/admin/add_blog.jsp").forward(request, response);
        }
    }
    
    /**
     * Show edit blog form (admin only)
     */
    private void showEditBlogForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int blogId = Integer.parseInt(idParam);
                Blog blog = blogDAO.getById(blogId);
                
                if (blog != null) {
                    request.setAttribute("blog", blog);
                    request.getRequestDispatcher("/admin/edit_blog.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/blog?error=Blog post not found");
    }
    
    /**
     * Edit a blog post (admin only)
     */
    private void editBlogPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int blogId = Integer.parseInt(idParam);
                Blog blog = blogDAO.getById(blogId);
                
                if (blog != null) {
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String videoUrl = request.getParameter("videoUrl");
                    
                    // Validate input
                    if (title == null || title.trim().isEmpty() ||
                        content == null || content.trim().isEmpty()) {
                        
                        request.setAttribute("error", "Title and content are required");
                        request.setAttribute("blog", blog);
                        request.getRequestDispatcher("/admin/edit_blog.jsp").forward(request, response);
                        return;
                    }
                    
                    // Update blog post
                    blog.setTitle(title);
                    blog.setContent(content);
                    blog.setVideoUrl(videoUrl);
                    
                    // Upload blog image if provided
                    try {
                        String imagePath = FileUploadUtil.uploadFile(request, "blogImage", "images");
                        if (imagePath != null) {
                            blog.setImagePath(imagePath);
                        }
                    } catch (Exception e) {
                        // Ignore if file upload fails
                    }
                    
                    boolean updated = blogDAO.update(blog);
                    
                    if (updated) {
                        response.sendRedirect(request.getContextPath() + 
                                             "/admin/blog?message=Blog post updated successfully");
                    } else {
                        request.setAttribute("error", "Failed to update blog post");
                        request.setAttribute("blog", blog);
                        request.getRequestDispatcher("/admin/edit_blog.jsp").forward(request, response);
                    }
                    
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/blog?error=Blog post not found");
    }
    
    /**
     * Delete a blog post (admin only)
     */
    private void deleteBlogPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int blogId = Integer.parseInt(idParam);
                boolean deleted = blogDAO.delete(blogId);
                
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/blog?message=Blog post deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/blog?error=Failed to delete blog post");
                }
                
                return;
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/blog?error=Blog post not found");
    }
}
