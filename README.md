<<<<<<< HEAD
# Hotel_Management_System
=======
# Hotel Management System

A comprehensive Hotel Management System built using Java (JSP/Servlets), JDBC, MySQL, and MVC architecture.

## Features

### Admin Portal
- Dashboard with statistics and recent activities
- User management (CRUD operations)
- Room management (CRUD operations)
- Booking management
- Staff management
- Event management
- Blog management
- Feedback viewing

### Guest Portal
- User registration and login
- Room browsing and booking
- Booking management
- Feedback submission
- Blog reading
- Event viewing
- Profile management

## Technologies Used

- **Frontend**: HTML, CSS, JavaScript, JSP
- **Backend**: Java Servlets
- **Database**: MySQL
- **Architecture**: MVC (Model-View-Controller)
- **Security**: BCrypt for password hashing
- **Additional Libraries**: JSTL, JBCrypt

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── hotel/
│   │           ├── controller/    # Servlet controllers
│   │           ├── model/         # Entity classes and DAOs
│   │           └── util/          # Utility classes
│   └── webapp/
│       ├── admin/                 # Admin portal JSPs
│       ├── assets/                # CSS, JS, images
│       ├── error/                 # Error pages
│       ├── partials/              # Reusable JSP components
│       ├── WEB-INF/
│       │   ├── sql/               # Database scripts
│       │   └── web.xml            # Web configuration
│       └── *.jsp                  # Main JSP pages
```

## Setup Instructions

### Prerequisites
- Java Development Kit (JDK) 17 or higher
- Apache Tomcat 10 or higher
- MySQL 8.0 or higher
- Maven (optional, for dependency management)

### Database Setup
1. Open MySQL Command Line Client and log in with your root credentials
2. Run the following commands to create the database and user:
   ```sql
   CREATE DATABASE hotel_db;
   CREATE USER 'hotel_user'@'localhost' IDENTIFIED BY 'hotel_password';
   GRANT ALL PRIVILEGES ON hotel_db.* TO 'hotel_user'@'localhost';
   FLUSH PRIVILEGES;
   ```
3. Run the SQL script located at `src/main/webapp/WEB-INF/sql/hotel_db.sql` or `database_setup.sql` to create the tables and sample data

### Configuration
1. Update the database connection settings in `src/main/java/com/hotel/util/DBConnection.java` if needed

### Deployment
1. Build the project using Maven or your IDE
2. Deploy the WAR file to Tomcat
3. Access the application at `http://localhost:8080/hotel-management-system`

## Default Admin Credentials
- Email: admin@hotel.com
- Password: admin123

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements
- [Bootstrap](https://getbootstrap.com/) - Frontend framework
- [Font Awesome](https://fontawesome.com/) - Icons
- [BCrypt](https://github.com/patrickfav/bcrypt) - Password hashing
- [JSTL](https://jakarta.ee/specifications/tags/3.0/) - JSP Standard Tag Library
>>>>>>> f3e4a03 (Initial commit: All project files added from scratch)
