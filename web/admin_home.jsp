<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="css.css"> <!-- Link to external CSS -->
    </head>
    <body id="admin-theme-body">

        <%
            HttpSession hs = request.getSession(false);

            if (hs != null) {
                String name = (String) hs.getAttribute("name");
                String email = (String) hs.getAttribute("email");

                if (name != null && email != null) {
        %>

        <!-- Logout button at top-right corner -->
        <a class="admin-theme-logout-btn" href="admin_logout.html">Logout</a>

        <div class="admin-theme-dashboard-container">
            <h2 class="admin-theme-dashboard-heading">Welcome, <%= name %></h2>
            <p class="admin-theme-dashboard-email">Email: <strong><%= email %></strong></p>
            <a class="admin-theme-dashboard-btn" href="approve_faculty.jsp">Approve Faculty</a>
        </div>

        <%
                } else {
                    response.sendRedirect("admin_login.html");
                }
            } else {
                response.sendRedirect("admin_login.html");
            }
        %>

    </body>
</html>
