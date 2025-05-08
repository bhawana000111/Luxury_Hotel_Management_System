/**
 * Main JavaScript file for Luxury Hotel Management System
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize any components that need JavaScript
    initializeComponents();
    
    // Add event listeners
    addEventListeners();
});

/**
 * Initialize components
 */
function initializeComponents() {
    // Initialize profile tabs if they exist
    const profileTabs = document.querySelectorAll('.profile-tabs .tab');
    if (profileTabs.length > 0) {
        profileTabs.forEach(tab => {
            tab.addEventListener('click', function() {
                // Remove active class from all tabs
                profileTabs.forEach(t => t.classList.remove('active'));
                
                // Add active class to clicked tab
                this.classList.add('active');
                
                // Show corresponding tab content
                const tabId = this.getAttribute('data-tab');
                const tabContents = document.querySelectorAll('.profile-content .tab-content');
                tabContents.forEach(content => {
                    content.classList.remove('active');
                    if (content.getAttribute('id') === tabId) {
                        content.classList.add('active');
                    }
                });
            });
        });
    }
    
    // Initialize date pickers if they exist
    const datePickers = document.querySelectorAll('input[type="date"]');
    if (datePickers.length > 0) {
        datePickers.forEach(datePicker => {
            // Set min date to today for check-in dates
            if (datePicker.id === 'dateFrom') {
                const today = new Date().toISOString().split('T')[0];
                datePicker.setAttribute('min', today);
                
                // Add event listener to update check-out min date
                datePicker.addEventListener('change', function() {
                    const checkOut = document.getElementById('dateTo');
                    if (checkOut) {
                        checkOut.setAttribute('min', this.value);
                        
                        // If check-out date is before check-in date, update it
                        if (checkOut.value && checkOut.value < this.value) {
                            checkOut.value = this.value;
                        }
                    }
                });
            }
        });
    }
    
    // Initialize alerts to auto-dismiss after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });
    }
}

/**
 * Add event listeners
 */
function addEventListeners() {
    // Add event listener for booking form submission
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        bookingForm.addEventListener('submit', function(e) {
            const dateFrom = document.getElementById('dateFrom').value;
            const dateTo = document.getElementById('dateTo').value;
            
            if (dateFrom >= dateTo) {
                e.preventDefault();
                alert('Check-out date must be after check-in date');
            }
        });
    }
    
    // Add event listener for registration form submission
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match');
            }
        });
    }
    
    // Add event listener for profile update form submission
    const updateProfileForm = document.getElementById('updateProfileForm');
    if (updateProfileForm) {
        updateProfileForm.addEventListener('submit', function(e) {
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            
            if (!name || !email) {
                e.preventDefault();
                alert('Name and email are required');
            }
        });
    }
    
    // Add event listener for password update form submission
    const updatePasswordForm = document.getElementById('updatePasswordForm');
    if (updatePasswordForm) {
        updatePasswordForm.addEventListener('submit', function(e) {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!currentPassword || !newPassword || !confirmPassword) {
                e.preventDefault();
                alert('All password fields are required');
            } else if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('New passwords do not match');
            }
        });
    }
    
    // Add event listener for feedback form submission
    const feedbackForm = document.getElementById('feedbackForm');
    if (feedbackForm) {
        feedbackForm.addEventListener('submit', function(e) {
            const message = document.getElementById('message').value;
            const rating = document.querySelector('input[name="rating"]:checked');
            
            if (!message || !rating) {
                e.preventDefault();
                alert('Message and rating are required');
            }
        });
    }
    
    // Add event listener for contact form submission
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value;
            
            if (!name || !email || !subject || !message) {
                e.preventDefault();
                alert('All fields are required');
            }
        });
    }
}
