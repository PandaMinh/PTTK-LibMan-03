package servlet;

import dao.UserDAO;
import model.Librarian;
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
    
//    public void init() {
//        userDAO = new UserDAO();
//    }
    
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
        
        User user = userDAO.checkLogin(username, password);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect based on user role
            switch (user.getRole()) {
                case "reader":
                    response.sendRedirect(request.getContextPath() + "/reader");
                    break;
                case "librarian":
                    if (user instanceof Librarian) {
                        response.sendRedirect(request.getContextPath() + "/librarian");
                    }
                    break;
                case "manager":
                    response.sendRedirect(request.getContextPath() + "/manager");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/");
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/WEB-INF/jsp/user/Login.jsp").forward(request, response);
        }
    }
}
