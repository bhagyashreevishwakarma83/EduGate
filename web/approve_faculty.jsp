<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>

<%
    HttpSession hs = request.getSession(false);
    if (hs == null || hs.getAttribute("email") == null) {
        response.sendRedirect("admin_login.html");
        return;
    }

    Properties dbConfig = new Properties();
    InputStream dbInput = application.getResourceAsStream("/WEB-INF/classes/config.properties");
    dbConfig.load(dbInput);
    String dbUrl = dbConfig.getProperty("db.url");
    String dbUser = dbConfig.getProperty("db.user");
    String dbPassword = dbConfig.getProperty("db.password");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Approve Faculty</title>
    <link rel="stylesheet" type="text/css" href="css.css">
</head>
<body id="admin-approve-body">

    <div class="logout-container">
        <a class="logout-btn" href="admin_logout.html">Logout</a>
    </div>

    <div class="admin-approve-container">
        <h2 class="admin-approve-heading">Pending Faculty Approval</h2>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                PreparedStatement ps = cn.prepareStatement("SELECT * FROM faculty WHERE status=false");
                ResultSet rs = ps.executeQuery();
        %>

        <table class="admin-approve-table">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Mobile</th>
                <th>Approve</th>
                <th>Block</th>
            </tr>

            <%
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    String id = rs.getString(1);
                    String name = rs.getString(2);
                    String email = rs.getString(3);
                    String mobile = rs.getString(4);
            %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= email %></td>
                <td><%= mobile %></td>
                <td class="admin-approve-action">
                    <a class="approve" href="approve.jsp?email=<%= email %>">Approve</a>
                </td>
                <td class="admin-approve-action">
                    <a class="block" href="block.jsp?email=<%= email %>">Block</a>
                </td>
            </tr>
            <%
                }
                if (!found) {
            %>
                <tr><td colspan="6">No pending faculty approvals.</td></tr>
            <%
                }
                cn.close();
            } catch (Exception ex) {
                out.println("<p style='color:red;'>Error: " + ex.toString() + "</p>");
            }
        %>
        </table>
    </div>

</body>
</html>