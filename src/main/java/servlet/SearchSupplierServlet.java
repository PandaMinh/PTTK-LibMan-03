package servlet;

import dao.SupplierDAO;
import model.Supplier;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/searchSupplier")
public class SearchSupplierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplierDAO supplierDAO;
    
    public void init() {
        supplierDAO = new SupplierDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            // Show search form
            request.getRequestDispatcher("/WEB-INF/jsp/librarian/SearchSupplierView.jsp")
                  .forward(request, response);
            return;
        }
        
        if (action.equals("select")) {
            // Select supplier and move to invoice page
            int supplierId = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            
            if (supplier != null) {
                request.setAttribute("supplier", supplier);
                request.getRequestDispatcher("/WEB-INF/jsp/librarian/ImportingInvoiceView.jsp")
                      .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            // Search by name
            String name = request.getParameter("name");
            if (name != null && !name.trim().isEmpty()) {
                List<Supplier> suppliers = supplierDAO.searchSupplierByName(name);
                request.setAttribute("suppliers", suppliers);
            }
            
            request.getRequestDispatcher("/WEB-INF/jsp/librarian/SearchSupplierView.jsp")
                  .forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
