<%@include file="f_login.html" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Faculty Register</title>
        <link rel="stylesheet" href="css.css">
    </head>
    <body>
        <%
        try {
            Properties dbConfig = new Properties();
            InputStream dbInput = application.getResourceAsStream("/WEB-INF/classes/config.properties");
            dbConfig.load(dbInput);
            String dbUrl = dbConfig.getProperty("db.url");
            String dbUser = dbConfig.getProperty("db.user");
            String dbPassword = dbConfig.getProperty("db.password");

            String name = request.getParameter("name");
            String email = request.getParameter("mail");
            String mobile = request.getParameter("mob");
            String qualification = request.getParameter("qualification");
            String subject = request.getParameter("subject");
            String pwd = request.getParameter("pwd");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            PreparedStatement ps = cn.prepareStatement(
                "INSERT INTO faculty (name, email, mobile, qualification, subject, password, status) VALUES (?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, mobile);
            ps.setString(4, qualification);
            ps.setString(5, subject);
            ps.setString(6, pwd);
            ps.setBoolean(7, false);

            boolean b = ps.execute();
            if (b == false) {
                response.sendRedirect("f_login.html");
            }
            cn.close();

        } catch (SQLIntegrityConstraintViolationException ex) {
        %>
            <div style="display:flex; justify-content:center; margin-top:30px;">
                <div class="faculty-error">
                    ⚠️ This email is already registered. Please use a different email.
                    <br><br>
                    <a href="f_register.html">Go Back</a>
                </div>
            </div>
        <%
        } catch (Exception ex) {
            out.println(ex.toString());
        }
        %>
    </body>
</html>