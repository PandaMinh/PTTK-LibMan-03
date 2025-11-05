package servlet;

import dao.UserDAO;
import model.Librarian;
import model.Reader;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/user/Login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

    // ensure required fields are provided
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("username", username); // preserve entered username
            request.setAttribute("error", "Vui lòng nhập tên đăng nhập và mật khẩu");
            request.getRequestDispatcher("/WEB-INF/jsp/user/Login.jsp").forward(request, response);
            return;
        }

        User u = new User();
        u.setUsername(username.trim());
        u.setPassword(password);

        boolean ok;
        try {
            ok = userDAO.checkLogin(u);
        } catch (java.sql.SQLException ex) {
            // database error during login attempt
            ex.printStackTrace();
            request.setAttribute("username", username);
            request.setAttribute("error", "Hệ thống hiện đang gặp sự cố. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/jsp/user/Login.jsp").forward(request, response);
            return;
        }

        if (!ok) {
            // invalid credentials
            request.setAttribute("username", username);
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/WEB-INF/jsp/user/Login.jsp").forward(request, response);
            return;
        }

        // login successful: normalize role to lower-case for routing
        String role = u.getRole() == null ? "" : u.getRole().toLowerCase();

        // if librarian, try to get Librarian object but do not fail login if librarian tables are missing
        if ("librarian".equalsIgnoreCase(role)) {
            try {
                Librarian lib = userDAO.getLibrarianByUserId(u);
                if (lib != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", lib);
                    response.sendRedirect(request.getContextPath() + "/librarian");
                    return;
                }
            } catch (java.sql.SQLException ex) {
                ex.printStackTrace();
            }
        }

        else if ("reader".equalsIgnoreCase(role)) {
            try {
                Reader reader = userDAO.getReaderByUserId(u);
                if (reader != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", reader);
                    response.sendRedirect(request.getContextPath() + "/reader");
                    return;
                }
            } catch (java.sql.SQLException ex) {
                ex.printStackTrace();
            }
        }

        // default: store User and redirect based on role
        HttpSession session = request.getSession();
        session.setAttribute("user", u);
        switch (role) {
            case "manager":
                response.sendRedirect(request.getContextPath() + "/manager");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/");
                break;
        }
    }
}
