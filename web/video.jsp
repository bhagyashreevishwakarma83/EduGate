<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.Properties" %>
<%@page import="java.io.InputStream" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Uploaded Videos</title>
    <style>
        body {
            background: linear-gradient(to right, #fff3e0, #ffe0b2);
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .video-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 12px;
            border: 2px solid #ff9800;
            box-shadow: 0 0 15px rgba(255, 152, 0, 0.3);
            text-align: center;
        }
        .video-heading {
            color: #e65100;
            font-size: 28px;
            margin-bottom: 20px;
        }
        .video-box {
            margin: 15px;
            display: inline-block;
        }
        video {
            border: 2px solid #ff9800;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="video-container">
        <h2 class="video-heading">Uploaded Videos</h2>

        <%
        try {
            HttpSession hs = request.getSession(false);
            if (hs != null && hs.getAttribute("fid") != null) {
                int fid = (Integer) hs.getAttribute("fid");

                Properties dbConfig = new Properties();
                InputStream dbInput = application.getResourceAsStream("/WEB-INF/classes/config.properties");
                dbConfig.load(dbInput);
                String dbUrl = dbConfig.getProperty("db.url");
                String dbUser = dbConfig.getProperty("db.user");
                String dbPassword = dbConfig.getProperty("db.password");

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                PreparedStatement ps = cn.prepareStatement("select * from data where faculty_id=?");
                ps.setInt(1, fid);

                ResultSet rs = ps.executeQuery();
                boolean found = false;
                while (rs.next()) {
                    String fileName = rs.getString("video");
                    if (fileName != null && !fileName.trim().isEmpty()) {
                        found = true;
        %>
                        <div class="video-box">
                            <video width="320" height="240" controls>
                                <source src="education_video/<%=fileName%>" type="video/mp4">
                                Your browser does not support the video tag.
                            </video>
                        </div>
        <%
                    }
                }
                if (!found) {
                    out.println("<p>No videos uploaded yet.</p>");
                }
                cn.close();
            } else {
                out.println("<h3>Session has expired. Please login again.</h3>");
            }
        } catch (Exception ex) {
            out.println("<p style='color:red;'>" + ex.toString() + "</p>");
        }
        %>
    </div>
</body>
</html>