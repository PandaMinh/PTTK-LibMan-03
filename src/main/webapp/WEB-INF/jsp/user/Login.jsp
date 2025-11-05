<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
        <meta charset="UTF-8">
        <title>Đăng nhập - Hệ thống Quản lý Thư viện LibMan</title>
        <link rel="stylesheet" href="<c:url value='/css/login.css'/>" type="text/css">
</head>
<body>
        <div class="login-page">
            <div class="card">
                <div class="card-header">
                    <div class="logo-circle" aria-hidden="true">
                        <!-- simple book icon SVG -->
                        <svg class="book-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                            <path d="M3 6.5C3 5.11929 4.11929 4 5.5 4H19" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                            <path d="M21 4V18.5C21 19.8807 19.8807 21 18.5 21H5.5C4.11929 21 3 19.8807 3 18.5V6.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                    <h1 class="card-title">Hệ thống Quản lý Thư viện - LibMan</h1>
                </div>

                <div class="card-content">
                    <c:if test="${not empty error}">
                        <div class="error-box">${error}</div>
                    </c:if>

                    <form action="<c:url value='/login'/>" method="post" class="login-form" id="loginForm">
                        <div class="field">
                            <label for="username">Tên đăng nhập</label>
                              <input type="text" id="username" name="username" required placeholder="Nhập tên đăng nhập" value="${username}" />
                        </div>

                        <div class="field">
                            <label for="password">Mật khẩu</label>
                              <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu" />
                        </div>

                        <button type="submit" id="btnLogin" class="btn-primary">Đăng nhập</button>
                    </form>

                      <div class="card-footer">© 2025 Thư viện Trường Đại học LibMan</div>
                </div>
            </div>
        </div>
</body>
</html>