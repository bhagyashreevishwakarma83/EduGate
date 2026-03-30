import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Properties;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/f_check_login")
public class f_check_login extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            PreparedStatement ps = cn.prepareStatement(
                "select * from faculty where email=? and binary password=?");
            ps.setString(1, email);
            ps.setString(2, pwd);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                boolean status = rs.getBoolean("status");
                boolean isBlocked = rs.getBoolean("is_blocked");

                if (isBlocked) {
                    // Faculty is blocked by admin
                    out.println("<!DOCTYPE html><html><head>");
                    out.println("<link rel='stylesheet' href='css.css'>");
                    out.println("</head><body>");
                    out.println("<div style='display:flex; justify-content:center; margin-top:30px;'>");
                    out.println("<div class='faculty-error'>");
                    out.println("🚫 Your account has been blocked by the Admin.");
                    out.println("<br>Please contact the Admin for further details.");
                    out.println("<br><br><a href='f_login.html'>Go Back</a>");
                    out.println("</div></div></body></html>");
                    return;
                }

                if (!status) {
                    // Faculty registered but not approved yet
                    out.println("<!DOCTYPE html><html><head>");
                    out.println("<link rel='stylesheet' href='css.css'>");
                    out.println("</head><body>");
                    out.println("<div style='display:flex; justify-content:center; margin-top:30px;'>");
                    out.println("<div class='faculty-error'>");
                    out.println("⏳ Your account is not approved yet.");
                    out.println("<br>Please wait for Admin approval.");
                    out.println("<br><br><a href='f_login.html'>Go Back</a>");
                    out.println("</div></div></body></html>");
                    return;
                }

                // Status is true and not blocked — approved faculty
                HttpSession hs = request.getSession(true);
                hs.setAttribute("fid", rs.getInt("id"));
                hs.setAttribute("name", rs.getString("name"));
                hs.setAttribute("email", rs.getString("email"));
                hs.setAttribute("mobile", rs.getString("mobile"));
                hs.setAttribute("qualification", rs.getString("qualification"));
                hs.setAttribute("subject", rs.getString("subject"));

                RequestDispatcher rd = request.getRequestDispatcher("F_Home");
                rd.forward(request, response);

            } else {
                out.println("Invalid credentials. Try again.");
                RequestDispatcher rd = request.getRequestDispatcher("f_login.html");
                rd.include(request, response);
            }

            cn.close();

        } catch (Exception ex) {
            ex.printStackTrace(out);
        }
    }
}