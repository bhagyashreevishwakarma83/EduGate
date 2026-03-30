import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(urlPatterns = {"/student_check_login"})
public class student_check_login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("mail");
        String pwd = request.getParameter("pwd");

        try {
            // Load config
            Properties config = new Properties();
            InputStream input = getClass().getClassLoader()
                .getResourceAsStream("config.properties");
            config.load(input);

            String dbUrl = config.getProperty("db.url");
            String dbUser = config.getProperty("db.user");
            String dbPassword = config.getProperty("db.password");

            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // Prepare SQL query
            PreparedStatement ps = cn.prepareStatement(
                "select * from student where email=? and binary password=?");
            ps.setString(1, email);
            ps.setString(2, pwd);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession hs = request.getSession(true);
                hs.setAttribute("sid", rs.getInt("id"));
                hs.setAttribute("name", rs.getString("name"));
                hs.setAttribute("email", rs.getString("email"));

                RequestDispatcher rd = request.getRequestDispatcher("student_home.jsp");
                rd.forward(request, response);

            } else {
                out.println("Invalid credentials. Try again.");
                RequestDispatcher rd = request.getRequestDispatcher("student_login.html");
                rd.include(request, response);
            }

            cn.close();

        } catch (Exception ex) {
            ex.printStackTrace(out);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Student Login Check";
    }
}