<%@include file="student_login.html" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Student Register</title>
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
            String password = request.getParameter("pwd");
            String gender = request.getParameter("gender");
            String mobile = request.getParameter("mobile");
            String course = request.getParameter("course");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            PreparedStatement ps = cn.prepareStatement(
                "INSERT INTO student (name, email, password, gender, mobile, course) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, gender);
            ps.setString(5, mobile);
            ps.setString(6, course);

            boolean b = ps.execute();
            if (b == false) {
                response.sendRedirect("student_login.html");
            }
            cn.close();

        } catch (SQLIntegrityConstraintViolationException ex) {
        %>
            <div style="display:flex; justify-content:center; margin-top:30px;">
                <div class="faculty-error">
                    ⚠️ This email is already registered. Please use a different email.
                    <br><br>
                    <a href="student_register.html">Go Back</a>
                </div>
            </div>
        <%
        } catch (Exception ex) {
            out.println(ex.toString());
        }
        %>
    </body>
</html>