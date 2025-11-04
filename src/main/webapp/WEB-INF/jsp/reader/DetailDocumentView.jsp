<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Document Details - Library Management System</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
</head>
<body>
    <div class="container">
        <h2>Document Details</h2>
        
        <div class="document-details">
            <c:if test="${not empty document}">
                <div class="detail-group">
                    <label>Title:</label>
                    <span>${document.title}</span>
                </div>
                <div class="detail-group">
                    <label>Author:</label>
                    <span>${document.author}</span>
                </div>
                <div class="detail-group">
                    <label>Category:</label>
                    <span>${document.category}</span>
                </div>
                <div class="detail-group">
                    <label>Year Published:</label>
                    <span>${document.yearPublic}</span>
                </div>
                <div class="detail-group">
                    <label>Description:</label>
                    <p>${document.description}</p>
                </div>
                <div class="detail-group">
                    <label>Content:</label>
                    <p>${document.content}</p>
                </div>
            </c:if>
            
            <c:if test="${empty document}">
                <p class="error-message">Document not found.</p>
            </c:if>
        </div>
        
        <div class="navigation">
            <a href="javascript:history.back()" class="back-button">Back to Search Results</a>
            <a href="<c:url value='/reader'/>" class="home-button">Back to Reader Page</a>
        </div>
    </div>
</body>
</html>
