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
                    <div class="alert alert-danger">
                        ${error}
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

                        <div class="payment-method selected">
                            <div class="payment-method-header">
                                <label>
                                    <input type="radio" name="paymentMethod" value="CREDIT_CARD" checked>
                                    Credit Card
                                </label>
                                <div>
                                    <i class="fab fa-cc-visa fa-2x" style="color: #1a1f71;"></i>
                                    <i class="fab fa-cc-mastercard fa-2x" style="color: #eb001b;"></i>
                                    <i class="fab fa-cc-amex fa-2x" style="color: #006fcf;"></i>
                                </div>
                            </div>
                            <div class="payment-method-details" style="margin-top: 15px;">
                                <div class="form-group">
                                    <label for="cardNumber">Card Number</label>
                                    <input type="text" id="cardNumber" class="form-control" placeholder="1234 5678 9012 3456" maxlength="19">
                                </div>
                                <div style="display: flex; gap: 15px;">
                                    <div class="form-group" style="flex: 1;">
                                        <label for="expiryDate">Expiry Date</label>
                                        <input type="text" id="expiryDate" class="form-control" placeholder="MM/YY" maxlength="5">
                                    </div>
                                    <div class="form-group" style="flex: 1;">
                                        <label for="cvv">CVV</label>
                                        <input type="text" id="cvv" class="form-control" placeholder="123" maxlength="3">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="cardName">Name on Card</label>
                                    <input type="text" id="cardName" class="form-control" placeholder="John Doe">
                                </div>
                            </div>
                        </div>

                        <div class="payment-method">
                            <div class="payment-method-header">
                                <label>
                                    <input type="radio" name="paymentMethod" value="PAYPAL">
                                    PayPal
                                </label>
                                <div>
                                    <i class="fab fa-paypal fa-2x" style="color: #003087;"></i>
                                </div>
                            </div>
                            <div class="payment-method-details" style="margin-top: 15px; display: none;">
                                <p>You will be redirected to PayPal to complete your payment.</p>
                            </div>
                        </div>

                        <div class="payment-method">
                            <div class="payment-method-header">
                                <label>
                                    <input type="radio" name="paymentMethod" value="BANK_TRANSFER">
                                    Bank Transfer
                                </label>
                                <div>
                                    <i class="fas fa-university fa-2x" style="color: #333;"></i>
                                </div>
                            </div>
                            <div class="payment-method-details" style="margin-top: 15px; display: none;">
                                <p>Please transfer the total amount to the following bank account:</p>
                                <p><strong>Bank Name:</strong> Luxury Bank</p>
                                <p><strong>Account Name:</strong> Luxury Hotel</p>
                                <p><strong>Account Number:</strong> 1234567890</p>
                                <p><strong>SWIFT Code:</strong> LUXURYBANK</p>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-pay">Pay Now $<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00" /></button>
                </form>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Payment method selection
            const paymentMethods = document.querySelectorAll('.payment-method');
            const paymentForm = document.getElementById('paymentForm');

            paymentMethods.forEach(method => {
                method.addEventListener('click', function() {
                    // Unselect all methods
                    paymentMethods.forEach(m => {
                        m.classList.remove('selected');
                        m.querySelector('input[type="radio"]').checked = false;
                        const details = m.querySelector('.payment-method-details');
                        if (details) details.style.display = 'none';
                    });

                    // Select clicked method
                    this.classList.add('selected');
                    this.querySelector('input[type="radio"]').checked = true;
                    const details = this.querySelector('.payment-method-details');
                    if (details) details.style.display = 'block';
                });
            });

            // Format card number with spaces
            const cardNumber = document.getElementById('cardNumber');
            if (cardNumber) {
                cardNumber.addEventListener('input', function(e) {
                    let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
                    let formattedValue = '';

                    for (let i = 0; i < value.length; i++) {
                        if (i > 0 && i % 4 === 0) {
                            formattedValue += ' ';
                        }
                        formattedValue += value[i];
                    }

                    e.target.value = formattedValue;
                });
            }

            // Format expiry date with slash
            const expiryDate = document.getElementById('expiryDate');
            if (expiryDate) {
                expiryDate.addEventListener('input', function(e) {
                    let value = e.target.value.replace(/\D/g, '');

                    if (value.length > 2) {
                        value = value.substring(0, 2) + '/' + value.substring(2, 4);
                    }

                    e.target.value = value;
                });
            }

            // Form validation
            paymentForm.addEventListener('submit', function(e) {
                const selectedMethod = document.querySelector('.payment-method.selected');
                if (!selectedMethod) {
                    e.preventDefault();
                    alert('Please select a payment method');
                    return;
                }

                const methodValue = selectedMethod.querySelector('input[type="radio"]').value;

                if (methodValue === 'CREDIT_CARD') {
                    const cardNum = cardNumber.value.replace(/\s+/g, '');
                    const expiry = expiryDate.value;
                    const cvvValue = document.getElementById('cvv').value;
                    const name = document.getElementById('cardName').value;

                    if (!cardNum || cardNum.length < 16) {
                        e.preventDefault();
                        alert('Please enter a valid card number');
                        return;
                    }

                    if (!expiry || expiry.length < 5) {
                        e.preventDefault();
                        alert('Please enter a valid expiry date');
                        return;
                    }

                    if (!cvvValue || cvvValue.length < 3) {
                        e.preventDefault();
                        alert('Please enter a valid CVV');
                        return;
                    }

                    if (!name) {
                        e.preventDefault();
                        alert('Please enter the name on the card');
                        return;
                    }
                }

                // In a real application, you would validate the card details with a payment gateway
                // For this demo, we'll just submit the form
            });
        });
    </script>
</body>
</html>
