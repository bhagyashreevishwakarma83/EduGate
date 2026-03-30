<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Login Check</title>
    </head>
    <body>
        <%
        String email = request.getParameter("mail");
        String pwd = request.getParameter("pwd");

        // Load admin credentials from config
        Properties dbConfig = new Properties();
        InputStream dbInput = application.getResourceAsStream("/WEB-INF/classes/config.properties");
        dbConfig.load(dbInput);

        String adminEmail = dbConfig.getProperty("admin.email");
        String adminPassword = dbConfig.getProperty("admin.password");

        if(email.equalsIgnoreCase(adminEmail) && pwd.equals(adminPassword)) {
            HttpSession hs = request.getSession(true);
            hs.setAttribute("name", "Admin");
            hs.setAttribute("email", email);
            response.sendRedirect("admin_home.jsp");
        } else {
            out.println("<h2>Invalid Password</h2>");
            RequestDispatcher rd = request.getRequestDispatcher("admin_login.html");
            rd.include(request, response);
        }
        %>
    </body>
</html>