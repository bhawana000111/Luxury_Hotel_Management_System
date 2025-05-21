<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Contact Submissions</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
    <!-- Include Admin Header -->
    <jsp:include page="partials/header.jsp" />
    
    <div class="admin-container">
        <!-- Include Admin Sidebar -->
        <jsp:include page="partials/sidebar.jsp" />
        
        <div class="admin-content">
            <div class="admin-content-header">
                <h2>Contact Submissions</h2>
                <p>View and manage contact form submissions</p>
            </div>
            
            <c:if test="${not empty param.message}">
                <div class="alert alert-success">
                    ${param.message}
                </div>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    ${param.error}
                </div>
            </c:if>
            
            <div class="admin-card">
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Subject</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="contact" items="${contacts}">
                                <tr>
                                    <td>${contact.id}</td>
                                    <td>${contact.name}</td>
                                    <td>${contact.email}</td>
                                    <td>${contact.subject}</td>
                                    <td>${contact.createdAt}</td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-info view-message" data-id="${contact.id}" data-message="${contact.message}">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/deleteContact?id=${contact.id}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this contact submission?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty contacts}">
                                <tr>
                                    <td colspan="6" class="text-center">No contact submissions found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Message Modal -->
    <div id="messageModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>Message Details</h3>
            <div id="messageContent"></div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Get the modal
            const modal = document.getElementById('messageModal');
            
            // Get the <span> element that closes the modal
            const span = document.getElementsByClassName('close')[0];
            
            // Get all view message buttons
            const viewButtons = document.querySelectorAll('.view-message');
            
            // When the user clicks on a view button, open the modal
            viewButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const message = this.getAttribute('data-message');
                    document.getElementById('messageContent').textContent = message;
                    modal.style.display = 'block';
                });
            });
            
            // When the user clicks on <span> (x), close the modal
            span.onclick = function() {
                modal.style.display = 'none';
            }
            
            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function(event) {
                if (event.target == modal) {
                    modal.style.display = 'none';
                }
            }
        });
    </script>
</body>
</html>
