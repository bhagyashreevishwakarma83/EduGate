<%@page import="java.sql.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Faculty Subject Details</title>
        <link rel="stylesheet" href="css.css">
    </head>
    <body id="view-subject-body">
        <div class="view-subject-container">
            <%
                try {
                    Properties dbConfig = new Properties();
                    InputStream dbInput = application.getResourceAsStream("/WEB-INF/classes/config.properties");
                    dbConfig.load(dbInput);
                    String dbUrl = dbConfig.getProperty("db.url");
                    String dbUser = dbConfig.getProperty("db.user");
                    String dbPassword = dbConfig.getProperty("db.password");

                    String subject = request.getParameter("subject");
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                    PreparedStatement ps = cn.prepareStatement(
                        "select * from faculty where subject=? and status=true");
                    ps.setString(1, subject);
                    ResultSet rs = ps.executeQuery();
            %>

            <h2>Faculty Details for "<%= subject %>"</h2>
            <table class="view-subject-table">
                <tr>
                    <th>ID</th>
                    <th>Faculty Name</th>
                    <th>Qualification</th>
                    <th>Detail</th>
                </tr>

                <%
                    boolean found = false;
                    while (rs.next()) {
                        found = true;
                        String f_id = rs.getString(1);
                        String f_name = rs.getString(2);
                        String f_qualification = rs.getString(5);
                %>
                <tr>
                    <td><%= f_id %></td>
                    <td><%= f_name %></td>
                    <td><%= f_qualification %></td>
                    <td><a href="details.jsp?f_id=<%= f_id %>" class="view-subject-link">Details</a></td>
                </tr>
                <%
                    }
                    if (!found) {
                %>
                    <tr><td colspan="4">No approved faculty found for this subject.</td></tr>
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