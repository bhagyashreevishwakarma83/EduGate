<%@page import="java.sql.*"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty Upload Details</title>
    <link rel="stylesheet" type="text/css" href="css.css">
</head>
<body class="faculty-upload-theme">
<%
    String fid = request.getParameter("f_id");
    if (fid == null || fid.trim().isEmpty()) {
        out.println("<h3>Faculty ID is missing in the URL.</h3>");
    } else {
        try {
            Properties dbConfig = new Properties();
            InputStream dbInput = application.getResourceAsStream("/WEB-INF/classes/config.properties");
            dbConfig.load(dbInput);
            String dbUrl = dbConfig.getProperty("db.url");
            String dbUser = dbConfig.getProperty("db.user");
            String dbPassword = dbConfig.getProperty("db.password");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // VIDEO SECTION
            PreparedStatement psVideo = cn.prepareStatement(
                "SELECT topic, video FROM data WHERE faculty_id = ? AND video IS NOT NULL");
            psVideo.setInt(1, Integer.parseInt(fid));
            ResultSet rsVideo = psVideo.executeQuery();
%>
    <div class="faculty-container">
        <h2>Uploaded Videos</h2>
        <table class="faculty-table">
            <tr>
                <th>Topic</th>
                <th>Video File</th>
                <th>Preview</th>
            </tr>
<%
            boolean hasVideo = false;
            while (rsVideo.next()) {
                hasVideo = true;
                String topic = rsVideo.getString("topic");
                String video = rsVideo.getString("video");
%>
            <tr>
                <td><%= topic %></td>
                <td><%= video %></td>
                <td>
                    <video width="300" controls>
                        <source src="education_video/<%= video %>" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                </td>
            </tr>
<%
            }
            if (!hasVideo) {
%>
            <tr><td colspan="3">No videos uploaded.</td></tr>
<%
            }

            // PDF SECTION
            PreparedStatement psPdf = cn.prepareStatement(
                "SELECT topic, pdf FROM data WHERE faculty_id = ? AND pdf IS NOT NULL");
            psPdf.setInt(1, Integer.parseInt(fid));
            ResultSet rsPdf = psPdf.executeQuery();
%>
        </table>
        <br><br>
        <h2>Uploaded PDFs</h2>
        <table class="faculty-table">
            <tr>
                <th>Topic</th>
                <th>PDF File</th>
                <th>Action</th>
            </tr>
<%
            boolean hasPdf = false;
            while (rsPdf.next()) {
                hasPdf = true;
                String topic = rsPdf.getString("topic");
                String pdf = rsPdf.getString("pdf");
%>
            <tr>
                <td><%= topic %></td>
                <td><%= pdf %></td>
                <td>
                    <a class="faculty-link" href="education_pdf/<%= pdf %>" target="_blank">View</a> |
                    <a class="faculty-link" href="education_pdf/<%= pdf %>" download>Download</a>
                </td>
            </tr>
<%
            }
            if (!hasPdf) {
%>
            <tr><td colspan="3">No PDFs uploaded.</td></tr>
<%
            }
            cn.close();
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
%>
    </table>
    </div>
</body>
</html>