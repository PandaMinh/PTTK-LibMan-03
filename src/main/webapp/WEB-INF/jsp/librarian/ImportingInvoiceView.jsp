<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Importing Invoice - Library Management System</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
    <div class="container">
        <h2>Importing Invoice</h2>
        
        <div class="supplier-info">
            <h3>Supplier Information</h3>
            <div class="detail-group">
                <label>Name:</label>
                <span>${supplier.name}</span>
            </div>
            <div class="detail-group">
                <label>Telephone:</label>
                <span>${supplier.tel}</span>
            </div>
            <div class="detail-group">
                <label>Address:</label>
                <span>${supplier.address}</span>
            </div>
        </div>
        
        <div class="document-search">
            <h3>Search Documents</h3>
            <form action="<c:url value='/addImportingInvoice'/>" method="get">
                <div class="form-group">
                    <label for="documentName">Document Name:</label>
                    <input type="text" id="documentName" name="documentName" required>
                    <button type="submit">Search</button>
                </div>
            </form>
            
            <c:if test="${not empty documents}">
                <div class="document-list">
                    <table>
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Author</th>
                                <th>Category</th>
                                <th>Year</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${documents}" var="document">
                                <tr>
                                    <form action="<c:url value='/addImportingInvoice'/>" method="post">
                                        <input type="hidden" name="action" value="addDetail">
                                        <input type="hidden" name="documentId" value="${document.id}">
                                        <td>${document.title}</td>
                                        <td>${document.author}</td>
                                        <td>${document.category}</td>
                                        <td>${document.yearPublic}</td>
                                        <td><input type="number" name="price" step="0.01" required></td>
                                        <td><input type="number" name="quantity" required></td>
                                        <td><button type="submit">Add</button></td>
                                    </form>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
        
        <c:if test="${not empty sessionScope.importingDetails}">
            <div class="invoice-details">
                <h3>Invoice Details</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Document Title</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${sessionScope.importingDetails}" var="detail">
                            <tr>
                                <td>${detail.document.title}</td>
                                <td>${detail.price}</td>
                                <td>${detail.quantity}</td>
                                <td>${detail.price * detail.quantity}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="invoice-submit">
                <form action="<c:url value='/addImportingInvoice'/>" method="post">
                    <input type="hidden" name="action" value="submit">
                    <input type="hidden" name="supplierId" value="${supplier.id}">
                    
                    <div class="form-group">
                        <label for="typePay">Payment Type:</label>
                        <select id="typePay" name="typePay" required>
                            <option value="cash">Cash</option>
                            <option value="bank">Bank Transfer</option>
                        </select>
                    </div>
                    
                    <div class="form-group bank-details" style="display:none;">
                        <label for="bank">Bank Details:</label>
                        <input type="text" id="bank" name="bank">
                    </div>
                    
                    <div class="form-group">
                        <button type="submit">Print Invoice</button>
                    </div>
                </form>
            </div>
        </c:if>
        
        <div class="navigation">
            <a href="<c:url value='/searchSupplier'/>" class="back-button">Back to Supplier Search</a>
            <a href="<c:url value='/librarian'/>" class="home-button">Back to Librarian Page</a>
        </div>
    </div>
    
    <script>
        document.getElementById('typePay').addEventListener('change', function() {
            var bankDetails = document.querySelector('.bank-details');
            if (this.value === 'bank') {
                bankDetails.style.display = 'block';
                document.getElementById('bank').required = true;
            } else {
                bankDetails.style.display = 'none';
                document.getElementById('bank').required = false;
            }
        });
    </script>
</body>
</html>