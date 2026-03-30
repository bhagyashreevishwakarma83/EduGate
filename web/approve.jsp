<%@page import="Mailer.Mailer"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Faculty Approval</title>
        <link rel="stylesheet" href="css.css">
    </head>
    <body>
        <div class="page-container">
        <%
            Properties dbConfig = new Properties();
            InputStream dbInput = application.getResourceAsStream("/WEB-INF/classes/config.properties");
            dbConfig.load(dbInput);
            String dbUrl = dbConfig.getProperty("db.url");
            String dbUser = dbConfig.getProperty("db.user");
            String dbPassword = dbConfig.getProperty("db.password");

            String email = "";
            try {
                email = request.getParameter("email");

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

               PreparedStatement ps = cn.prepareStatement("update faculty set status=?, is_blocked=? where email=?");
ps.setBoolean(1, true);
ps.setBoolean(2, false);
ps.setString(3, email);

                boolean b = ps.execute();
                if (!b) {
        %>
                    <div class="approve-success-msg">✅ Updated successfully</div>
        <%
                }

                String to = request.getParameter("email");
                String sub = "Approval Successful";
                String msg = "YOU ARE APPROVED BY THE ADMIN. YOU CAN LOGIN NOW, CLICK TO LOGIN\n" +
                             "http://localhost:8080/EDUCATION_HUB/f_login.html?email=" + to;

                try {
                    Mailer.send(to, sub, msg);
        %>
                    <div class="approve-success-msg">📧 Mail sent to: <%= to %></div>
        <%
                } catch (Exception ex) {
        %>
                    <div class="approve-error-msg">❌ Mail error: <%= ex.toString() %></div>
        <%
                }

                cn.close();
            } catch (Exception ex) {
        %>
                <div class="approve-error-msg">❌ Error: <%= ex.toString() %></div>
        <%
            }
        %>
        </div>
    </body>
</html>