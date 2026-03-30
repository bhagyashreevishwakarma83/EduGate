<%-- 
    Document   : admin_logout
    Created on : Jul 15, 2025, 11:24:31 PM
    Author     : ASUS
--%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
      
<%
    HttpSession hs = request.getSession(false);
    if (hs != null) {
        hs.invalidate();
    }
    response.sendRedirect("admin_login.html");
%>

    
           
    </body>
</html>
