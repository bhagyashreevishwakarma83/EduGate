<%@page import="Mailer.Mailer"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page import="blockk.Block"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Block Status</title>
        <link rel="stylesheet" href="css.css">
    </head>
    <body>
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

               PreparedStatement ps = cn.prepareStatement("UPDATE faculty SET status=?, is_blocked=? WHERE email=?");
               ps.setBoolean(1, false);
               ps.setBoolean(2, true);
               ps.setString(3, email);

                boolean b = ps.execute();
                if (!b) {
        %>
                    <div class="block-success-msg">❌ Blocked successfully</div>
        <%
                }

                String to = request.getParameter("email");
                String sub = "Block Alert";
                String msg = "YOU ARE BLOCKED BY THE ADMIN. CONTACT ADMIN FOR FURTHER DETAILS\n"
                           + "http://localhost:8080/EDUCATION_HUB/f_login.html?email=" + to;

                Block.send(to, sub, msg);
        %>
                <div class="block-success-msg">📧 Mail sent to: <%= to %></div>
        <%
                cn.close();
            } catch (Exception ex) {
        %>
                <div class="block-success-msg">⚠️ Error: <%= ex.toString() %></div>
        <%
            }
        %>
    </body>
</html>