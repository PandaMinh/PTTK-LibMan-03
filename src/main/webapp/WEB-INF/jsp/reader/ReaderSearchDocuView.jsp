<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Documents - Library Management System</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
</head>
<body>
    <div class="container">
        <h2>Search Documents</h2>
        <div class="search-form">
            <form action="<c:url value='/searchDocument'/>" method="get">
                <div class="form-group">
                    <label for="title">Document Title:</label>
                    <input type="text" id="title" name="title" value="${param.title}" required>
                </div>
                <div class="form-group">
                    <button type="submit">Search</button>
                </div>
            </form>
        </div>
        
        <c:if test="${not empty documents}">
            <div class="search-results">
                <h3>Search Results</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Year</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${documents}" var="document">
                            <tr>
                                <td>${document.title}</td>
                                <td>${document.author}</td>
                                <td>${document.category}</td>
                                <td>${document.yearPublic}</td>
                                <td>
                                    <a href="<c:url value='/searchDocument?type=detail&id=${document.id}'/>" class="view-button">View Detail</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        
        <div class="navigation">
            <a href="<c:url value='/reader'/>" class="back-button">Back to Reader Page</a>
        </div>
    </div>
</body>
</html>