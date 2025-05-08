<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Rooms</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Page Header -->
    <section class="page-header" style="background-image: url('https://wallpaperaccess.com/full/2690623.jpg');">
        <div class="container">
            <h1>Our Rooms</h1>
        </div>
    </section>

    <!-- Rooms Section -->
    <section class="section">
        <div class="container">
            <!-- Advanced Search -->
            <div class="search-container">
                <button class="btn btn-primary" id="toggleSearch"><i class="fas fa-search"></i> Advanced Search</button>

                <div class="advanced-search" id="advancedSearch">
                    <form action="${pageContext.request.contextPath}/rooms" method="get">
                        <div class="search-row">
                            <div class="search-group">
                                <label for="type">Room Type:</label>
                                <select id="type" name="type" class="form-control">
                                    <option value="">All Types</option>
                                    <c:forEach var="type" items="${roomTypes}">
                                        <option value="${type}" ${selectedType eq type ? 'selected' : ''}>${type}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="search-group">
                                <label for="checkIn">Check-in Date:</label>
                                <input type="date" id="checkIn" name="checkIn" class="form-control" value="${checkIn}" min="${java.time.LocalDate.now()}">
                            </div>

                            <div class="search-group">
                                <label for="checkOut">Check-out Date:</label>
                                <input type="date" id="checkOut" name="checkOut" class="form-control" value="${checkOut}" min="${java.time.LocalDate.now().plusDays(1)}">
                            </div>
                        </div>

                        <div class="search-row">
                            <div class="search-group price-range">
                                <label>Price Range:</label>
                                <div class="price-slider-container">
                                    <input type="range" id="minPriceSlider" min="${minPriceRange}" max="${maxPriceRange}" step="10" value="${minPrice != null ? minPrice : minPriceRange}">
                                    <input type="range" id="maxPriceSlider" min="${minPriceRange}" max="${maxPriceRange}" step="10" value="${maxPrice != null ? maxPrice : maxPriceRange}">
                                    <div class="price-values">
                                        <span>$<input type="number" id="minPrice" name="minPrice" value="${minPrice != null ? minPrice : minPriceRange}" min="${minPriceRange}" max="${maxPriceRange}"></span>
                                        <span>$<input type="number" id="maxPrice" name="maxPrice" value="${maxPrice != null ? maxPrice : maxPriceRange}" min="${minPriceRange}" max="${maxPriceRange}"></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="search-actions">
                            <button type="submit" class="btn btn-primary">Search</button>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">Reset</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Room Cards -->
            <div class="room-cards">
                <c:forEach var="room" items="${rooms}">
                    <div class="room-card">
                        <c:choose>
                            <c:when test="${not empty room.imagePath}">
                                <img src="${pageContext.request.contextPath}/${room.imagePath}" alt="${room.type} Room">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/${room.type.toLowerCase()}_room.jpg" alt="${room.type} Room">
                            </c:otherwise>
                        </c:choose>
                        <div class="room-card-content">
                            <h3>${room.type} Room</h3>
                            <p>${room.description}</p>
                            <div class="price">$${room.price} / night</div>
                            <div class="room-features">
                                <span><i class="fas fa-bed"></i> King Bed</span>
                                <span><i class="fas fa-wifi"></i> Free WiFi</span>
                                <span><i class="fas fa-tv"></i> Smart TV</span>
                            </div>
                            <div class="room-actions">
                                <a href="${pageContext.request.contextPath}/room?id=${room.id}" class="btn btn-primary">View Details</a>
                                <c:if test="${room.availability}">
                                    <a href="${pageContext.request.contextPath}/bookRoom?roomId=${room.id}" class="btn btn-secondary">Book Now</a>
                                </c:if>
                                <c:if test="${!room.availability}">
                                    <span class="btn btn-danger disabled">Not Available</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Fallback if no rooms are loaded -->
                <c:if test="${empty rooms}">
                    <div class="no-results">
                        <h3>No rooms available</h3>
                        <p>Please try a different room type or check back later.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle advanced search
            const toggleSearch = document.getElementById('toggleSearch');
            const advancedSearch = document.getElementById('advancedSearch');

            // Check if search parameters are present to show the search form
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('checkIn') || urlParams.has('checkOut') ||
                urlParams.has('minPrice') || urlParams.has('maxPrice')) {
                advancedSearch.classList.add('active');
            }

            toggleSearch.addEventListener('click', function() {
                advancedSearch.classList.toggle('active');
            });

            // Price range sliders
            const minPriceSlider = document.getElementById('minPriceSlider');
            const maxPriceSlider = document.getElementById('maxPriceSlider');
            const minPriceInput = document.getElementById('minPrice');
            const maxPriceInput = document.getElementById('maxPrice');

            // Update input when slider changes
            minPriceSlider.addEventListener('input', function() {
                minPriceInput.value = this.value;
                // Ensure min doesn't exceed max
                if (parseInt(this.value) > parseInt(maxPriceSlider.value)) {
                    maxPriceSlider.value = this.value;
                    maxPriceInput.value = this.value;
                }
            });

            maxPriceSlider.addEventListener('input', function() {
                maxPriceInput.value = this.value;
                // Ensure max doesn't go below min
                if (parseInt(this.value) < parseInt(minPriceSlider.value)) {
                    minPriceSlider.value = this.value;
                    minPriceInput.value = this.value;
                }
            });

            // Update slider when input changes
            minPriceInput.addEventListener('input', function() {
                minPriceSlider.value = this.value;
                // Ensure min doesn't exceed max
                if (parseInt(this.value) > parseInt(maxPriceInput.value)) {
                    maxPriceInput.value = this.value;
                    maxPriceSlider.value = this.value;
                }
            });

            maxPriceInput.addEventListener('input', function() {
                maxPriceSlider.value = this.value;
                // Ensure max doesn't go below min
                if (parseInt(this.value) < parseInt(minPriceInput.value)) {
                    minPriceInput.value = this.value;
                    minPriceSlider.value = this.value;
                }
            });

            // Date validation
            const checkInDate = document.getElementById('checkIn');
            const checkOutDate = document.getElementById('checkOut');

            checkInDate.addEventListener('change', function() {
                // Set minimum check-out date to check-in date + 1 day
                const date = new Date(this.value);
                date.setDate(date.getDate() + 1);
                const minCheckOut = date.toISOString().split('T')[0];
                checkOutDate.min = minCheckOut;

                // If check-out date is before new minimum, update it
                if (checkOutDate.value && checkOutDate.value < minCheckOut) {
                    checkOutDate.value = minCheckOut;
                }
            });
        });
    </script>
</body>
</html>
