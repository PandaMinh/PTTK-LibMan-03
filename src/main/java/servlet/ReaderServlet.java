package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/reader")
public class ReaderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Simple session / role guard: require logged-in user with role READER (or allow LIBRARIAN)
        Object userObj = request.getSession().getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // userObj is expected to be a model.User or subclass
        String role = null;
        try {
            java.lang.reflect.Method m = userObj.getClass().getMethod("getRole");
            Object r = m.invoke(userObj);
            if (r != null) role = r.toString();
        } catch (Exception ex) {
            // ignore - treat as no role
        }

        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        role = role.toLowerCase();
        if ("reader".equals(role) || "librarian".equals(role)) {
            request.getRequestDispatcher("/WEB-INF/jsp/reader/ReaderView.jsp").forward(request, response);
            return;
        }

        // If manager or other roles, redirect to appropriate area or home
        if ("manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/manager");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/");
    }
}
