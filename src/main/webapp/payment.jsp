<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Payment</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .btn-pay {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 5px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: block;
            width: 100%;
            margin-top: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-pay:hover {
            background-color: #45a049;
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .btn-pay:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Payment Section -->
    <section class="section">
        <div class="container">
            <div class="payment-container">
                <div class="payment-header">
                    <h2>Payment for Booking #${booking.id}</h2>
                    <p>Complete your payment to confirm your reservation</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 5px solid #f5c6cb;">
                        <strong><i class="fas fa-exclamation-circle"></i> Error:</strong> ${error}
                        <p style="margin-top: 10px; font-size: 14px;">If you're seeing a payment credential error, please try selecting a different payment method or refreshing the page.</p>
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-success">
                        ${message}
                    </div>
                </c:if>

                <div class="booking-details">
                    <h3>Booking Details</h3>
                    <table>
                        <tr>
                            <th>Room Type:</th>
                            <td>${room.type}</td>
                            <th>Room Number:</th>
                            <td>${room.number}</td>
                        </tr>
                        <tr>
                            <th>Check-in Date:</th>
                            <td><fmt:formatDate value="${booking.dateFrom}" pattern="yyyy-MM-dd" /></td>
                            <th>Check-out Date:</th>
                            <td><fmt:formatDate value="${booking.dateTo}" pattern="yyyy-MM-dd" /></td>
                        </tr>
                        <tr>
                            <th>Number of Nights:</th>
                            <td>${nights}</td>
                            <th>Price per Night:</th>
                            <td>$<fmt:formatNumber value="${room.price}" pattern="#,##0.00" /></td>
                        </tr>
                    </table>
                </div>

                <div class="payment-summary">
                    <h3>Payment Summary</h3>
                    <table>
                        <tr>
                            <td>Room Charge (${nights} nights):</td>
                            <td align="right">$<fmt:formatNumber value="${room.price * nights}" pattern="#,##0.00" /></td>
                        </tr>
                        <tr>
                            <td>Taxes (10%):</td>
                            <td align="right">$<fmt:formatNumber value="${room.price * nights * 0.1}" pattern="#,##0.00" /></td>
                        </tr>
                        <tr class="total">
                            <td>Total Amount:</td>
                            <td align="right">$<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00" /></td>
                        </tr>
                    </table>
                </div>

                <form action="${pageContext.request.contextPath}/processPayment" method="post" id="paymentForm">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <input type="hidden" name="amount" value="${totalAmount}">

                    <div class="payment-methods">
                        <h3>Select Payment Method</h3>

                        <div style="display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 30px;">
                            <div class="payment-option" style="flex: 1; min-width: 200px; border: 2px solid #5a3921; border-radius: 10px; padding: 20px; text-align: center; cursor: pointer; transition: all 0.3s ease;" onclick="selectPaymentMethod(this, 'CREDIT_CARD')">
                                <input type="radio" name="paymentMethod" value="CREDIT_CARD" checked style="display: none;">
                                <div style="font-size: 40px; color: #5a3921; margin-bottom: 15px;">
                                    <i class="fas fa-credit-card"></i>
                                </div>
                                <h4 style="margin-bottom: 10px; color: #5a3921;">Credit Card</h4>
                                <div style="display: flex; justify-content: center; gap: 10px;">
                                    <i class="fab fa-cc-visa fa-2x" style="color: #1a1f71;"></i>
                                    <i class="fab fa-cc-mastercard fa-2x" style="color: #eb001b;"></i>
                                    <i class="fab fa-cc-amex fa-2x" style="color: #006fcf;"></i>
                                </div>
                                <div class="selected-mark" style="position: absolute; top: 10px; right: 10px; color: #4CAF50; font-size: 20px;">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                            </div>

                            <div class="payment-option" style="flex: 1; min-width: 200px; border: 2px solid #ddd; border-radius: 10px; padding: 20px; text-align: center; cursor: pointer; transition: all 0.3s ease;" onclick="selectPaymentMethod(this, 'PAYPAL')">
                                <input type="radio" name="paymentMethod" value="PAYPAL" style="display: none;">
                                <div style="font-size: 40px; color: #003087; margin-bottom: 15px;">
                                    <i class="fab fa-paypal"></i>
                                </div>
                                <h4 style="margin-bottom: 10px; color: #333;">PayPal</h4>
                                <p style="color: #666; font-size: 14px;">Pay securely with PayPal</p>
                                <div class="selected-mark" style="position: absolute; top: 10px; right: 10px; color: #4CAF50; font-size: 20px; display: none;">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                            </div>

                            <div class="payment-option" style="flex: 1; min-width: 200px; border: 2px solid #ddd; border-radius: 10px; padding: 20px; text-align: center; cursor: pointer; transition: all 0.3s ease;" onclick="selectPaymentMethod(this, 'CASH')">
                                <input type="radio" name="paymentMethod" value="CASH" style="display: none;">
                                <div style="font-size: 40px; color: #4CAF50; margin-bottom: 15px;">
                                    <i class="fas fa-money-bill-wave"></i>
                                </div>
                                <h4 style="margin-bottom: 10px; color: #333;">Cash</h4>
                                <p style="color: #666; font-size: 14px;">Pay at hotel reception</p>
                                <div class="selected-mark" style="position: absolute; top: 10px; right: 10px; color: #4CAF50; font-size: 20px; display: none;">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="successMessage" style="display: none; background-color: #4CAF50; color: white; padding: 20px; border-radius: 10px; text-align: center; margin-bottom: 20px; animation: fadeIn 0.5s;">
                        <div style="font-size: 50px; margin-bottom: 15px;">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div style="background-color: #4CAF50; color: white; padding: 10px 20px; border-radius: 30px; display: inline-block; margin: 15px 0; font-weight: bold; font-size: 24px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
                            <i class="fas fa-check-circle"></i> PAID
                        </div>
                        <h2>Payment Successful!</h2>
                        <p>Your booking has been confirmed. Thank you for choosing Luxury Hotel.</p>
                        <div style="margin-top: 20px;">
                            <a href="${pageContext.request.contextPath}/booking?id=${booking.id}" class="btn-light" style="background-color: rgba(255,255,255,0.2); color: white; border: 2px solid white; padding: 10px 20px; border-radius: 5px; text-decoration: none; font-weight: 500; margin-right: 10px; display: inline-block;">
                                <i class="fas fa-eye"></i> View Booking
                            </a>
                            <a href="${pageContext.request.contextPath}/bookings" class="btn-light" style="background-color: rgba(255,255,255,0.2); color: white; border: 2px solid white; padding: 10px 20px; border-radius: 5px; text-decoration: none; font-weight: 500; display: inline-block;">
                                <i class="fas fa-list"></i> My Bookings
                            </a>
                        </div>
                    </div>

                    <button type="button" id="payNowBtn" class="btn-pay">Pay Now $<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00" /></button>
                    <noscript>
                        <!-- Fallback for when JavaScript is disabled -->
                        <button type="submit" class="btn-pay" style="margin-top: 10px; background-color: #5a3921;">Submit Payment (JavaScript Disabled)</button>
                    </noscript>
                </form>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        function selectPaymentMethod(element, method) {
            // Reset all payment options
            const paymentOptions = document.querySelectorAll('.payment-option');
            paymentOptions.forEach(option => {
                option.style.border = '2px solid #ddd';
                option.querySelector('input[type="radio"]').checked = false;
                option.querySelector('.selected-mark').style.display = 'none';
                option.querySelector('h4').style.color = '#333';
            });

            // Select the clicked option
            element.style.border = '2px solid #5a3921';
            element.querySelector('input[type="radio"]').checked = true;
            element.querySelector('.selected-mark').style.display = 'block';
            element.querySelector('h4').style.color = '#5a3921';
        }

        document.addEventListener('DOMContentLoaded', function() {
            const paymentForm = document.getElementById('paymentForm');
            const payNowBtn = document.getElementById('payNowBtn');
            const successMessage = document.getElementById('successMessage');

            // Add CSS for animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fadeIn {
                    from { opacity: 0; transform: translateY(-20px); }
                    to { opacity: 1; transform: translateY(0); }
                }

                @keyframes pulse {
                    0% { transform: scale(1); }
                    50% { transform: scale(1.05); }
                    100% { transform: scale(1); }
                }

                .success-icon-pulse {
                    animation: pulse 1.5s infinite;
                }
            `;
            document.head.appendChild(style);

            // Handle Pay Now button click
            payNowBtn.addEventListener('click', function() {
                const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
                if (!selectedMethod) {
                    alert('Please select a payment method');
                    return;
                }

                // Show a simple confirmation dialog
                if (!confirm('Confirm payment of $${totalAmount}?')) {
                    return;
                }

                // Show success message with animation
                payNowBtn.style.display = 'none';
                successMessage.style.display = 'block';

                // Add pulse animation to the success icon
                const successIcon = successMessage.querySelector('i.fa-check-circle');
                successIcon.classList.add('success-icon-pulse');

                // Make sure the selected payment method is set
                const paymentMethodValue = selectedMethod.value;
                const paymentMethodInput = document.querySelector('input[name="paymentMethod"]');
                if (paymentMethodInput) {
                    paymentMethodInput.value = paymentMethodValue;
                }

                // Submit the form after a delay to allow the user to see the success message
                setTimeout(function() {
                    paymentForm.submit();
                }, 3000); // 3 seconds delay
            });

            // Form validation (as a backup)
            paymentForm.addEventListener('submit', function(e) {
                const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
                if (!selectedMethod) {
                    e.preventDefault();
                    alert('Please select a payment method');
                    return;
                }
            });
        });
    </script>
</body>
</html>
