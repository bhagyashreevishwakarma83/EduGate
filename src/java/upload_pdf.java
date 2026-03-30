import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.Properties;

@WebServlet("/upload_pdf")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 20
)
public class upload_pdf extends HttpServlet {
    private static final String UPLOAD_DIR = "education_pdf";

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

                String topic = request.getParameter("topic");
                Part pdfPart = request.getPart("pdf");
                String pdfName = extractFileName(pdfPart);

                if (pdfName == null || pdfName.isEmpty()) {
                    out.println("<h3>Error: No PDF selected.</h3>");
                    return;
                }

                String pdfPath = uploadPath + File.separator + pdfName;
                pdfPart.write(pdfPath);

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                PreparedStatement stmt = cn.prepareStatement(
                    "INSERT INTO data(faculty_id, topic, video, pdf) VALUES (?, ?, ?, ?)");
                stmt.setInt(1, fid);
                stmt.setString(2, topic);
                stmt.setString(3, null);
                stmt.setString(4, pdfName);

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    out.println("<h3>PDF uploaded successfully!</h3>");
                } else {
                    out.println("<h3>Failed to upload PDF.</h3>");
                }

                cn.close();
            } else {
                out.println("<h3>Session expired. Please log in again.</h3>");
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