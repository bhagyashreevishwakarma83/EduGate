import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;

@WebServlet("/Upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class Upload extends HttpServlet {
    private static final String UPLOAD_DIR = "education_video";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        try {
            HttpSession hs = request.getSession(false);
            if (hs != null && hs.getAttribute("fid") != null) {
                int fid = (Integer) hs.getAttribute("fid");

                // Load config
                Properties dbConfig = new Properties();
                InputStream dbInput = getClass().getClassLoader()
                    .getResourceAsStream("config.properties");
                dbConfig.load(dbInput);
                String dbUrl = dbConfig.getProperty("db.url");
                String dbUser = dbConfig.getProperty("db.user");
                String dbPassword = dbConfig.getProperty("db.password");

                Part filePart = request.getPart("vdio");
                String fileName = extractFileName(filePart);

                if (fileName == null || fileName.isEmpty()) {
                    out.println("<h3>Error: No file selected.</h3>");
                    return;
                }

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                String topic = request.getParameter("topic");
                PreparedStatement stmt = cn.prepareStatement(
                    "INSERT INTO data(faculty_id, topic, video) VALUES (?, ?, ?)");
                stmt.setInt(1, fid);
                stmt.setString(2, topic);
                stmt.setString(3, fileName);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<h3>Video uploaded successfully!</h3>");
                } else {
                    out.println("<h3>Failed to upload video.</h3>");
                }

                cn.close();
            } else {
                out.println("<h3>Session has expired. Please login again.</h3>");
            }
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
            e.printStackTrace(out);
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String content : contentDisp.split(";")) {
                if (content.trim().startsWith("filename")) {
                    String fileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                    return new File(fileName).getName();
                }
            }
        }
        return null;
    }
}