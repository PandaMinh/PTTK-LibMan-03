<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Supplier - Library Management System</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
</head>
<body>
    <div class="container">
        <h2>Search Supplier</h2>
        
        <div class="search-form">
            <form action="<c:url value='/searchSupplier'/>" method="get">
                <div class="form-group">
                    <label for="name">Supplier Name:</label>
                    <input type="text" id="name" name="name" value="${param.name}" required>
                </div>
                <div class="form-group">
                    <button type="submit">Search</button>
                </div>
            </form>
        </div>
        
        <c:if test="${not empty suppliers}">
            <div class="search-results">
                <h3>Search Results</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Telephone</th>
                            <th>Address</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${suppliers}" var="supplier">
                            <tr>
                                <td>${supplier.name}</td>
                                <td>${supplier.tel}</td>
                                <td>${supplier.address}</td>
                                <td>
                                    <a href="<c:url value='/searchSupplier?action=select&id=${supplier.id}'/>" class="select-button">Select</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        
        <div class="navigation">
            <a href="<c:url value='/librarian'/>" class="back-button">Back to Librarian Page</a>
        </div>
    </div>
</body>
</html>
