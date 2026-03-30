import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/F_Home"})
public class F_Home extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession hs = request.getSession(false);

        if (hs != null) {
            Integer fid = (Integer) hs.getAttribute("fid");

            // Get your app's context path for correct CSS link
            String contextPath = request.getContextPath();

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Faculty Home</title>");
            out.println("<link rel='stylesheet' href='" + contextPath + "/css.css'>");
            out.println("</head>");
            out.println("<body class='faculty-home'>");  // 👈 Changed class name here
            out.println("<center>");
            out.println("<div class='main-box'>");
            out.println("<h2>Welcome Faculty</h2><br>");
            out.println("<a href='upload.jsp'>Click to Upload Video</a><br><br>");
            out.println("<a href='upload_pdf.jsp'>Click to Upload PDF</a><br><br>");
            out.println("<a href='video.jsp'>Show Video</a>");
            out.println("</div>");
            out.println("</center>");
            out.println("</body>");
            out.println("</html>");
        } else {
            response.sendRedirect("f_login.html");
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
        return "Faculty Home Page with CSS applied";
    }
}
