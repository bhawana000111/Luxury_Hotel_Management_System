// Main JavaScript file for Luxury Hotel Management System

document.addEventListener('DOMContentLoaded', function() {
    // Add hover effects to navigation links
    const navLinks = document.querySelectorAll('.navbar ul li a');
    navLinks.forEach(link => {
        link.addEventListener('mouseenter', function() {
            this.style.transition = 'all 0.3s ease';
        });
    });

    // Add hover effects to buttons
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
        });
        button.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });

    // Add hover effects to room cards
    const roomCards = document.querySelectorAll('.room-card');
    roomCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 8px 20px rgba(0, 0, 0, 0.15)';
        });
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.1)';
        });
    });

    // Mobile menu toggle
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (mobileMenuToggle && navMenu) {
        mobileMenuToggle.addEventListener('click', function() {
            navMenu.classList.toggle('active');
        });
    }

    // User dropdown menu
    const userInfo = document.querySelector('.user-info');
    const userDropdown = document.querySelector('.user-dropdown');
    
    if (userInfo && userDropdown) {
        userInfo.addEventListener('click', function() {
            userDropdown.classList.toggle('active');
        });
    }

    // Admin dropdown menu
    const adminUserInfo = document.querySelector('.admin-user-info');
    const adminDropdownMenu = document.querySelector('.admin-dropdown-menu');
    
    if (adminUserInfo && adminDropdownMenu) {
        adminUserInfo.addEventListener('click', function() {
            adminDropdownMenu.classList.toggle('active');
        });
    }

    // Close dropdowns when clicking outside
    document.addEventListener('click', function(event) {
        if (userInfo && userDropdown && !userInfo.contains(event.target)) {
            userDropdown.classList.remove('active');
        }
        
        if (adminUserInfo && adminDropdownMenu && !adminUserInfo.contains(event.target)) {
            adminDropdownMenu.classList.remove('active');
        }
    });
});
