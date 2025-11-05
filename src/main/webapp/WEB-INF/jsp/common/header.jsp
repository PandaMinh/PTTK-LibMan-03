<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object userObj = session.getAttribute("user");
    String displayName = "Khách";
    String userRole = "Khách";
    if (userObj != null) {
        try {
            java.lang.reflect.Method mName = userObj.getClass().getMethod("getName");
            java.lang.reflect.Method mRole = userObj.getClass().getMethod("getRole");
            Object n = mName.invoke(userObj);
            Object r = mRole.invoke(userObj);
            if (n != null) displayName = n.toString();
            if (r != null) {
                String roleStr = r.toString();
                switch(roleStr.toLowerCase()) {
                    case "reader":
                        userRole = "Bạn đọc";
                        break;
                    case "librarian":
                        userRole = "Thủ thư";
                        break;
                    case "manager":
                        userRole = "Quản lý";
                        break;
                    default:
                        userRole = roleStr;
                }
            }
        } catch (Exception e) {
            // ignore
        }
    }
%>
<header class="main-header">
    <div class="header-container">
        <div class="header-content">
            <!-- Logo và Tên hệ thống -->
            <div class="header-brand">
                <div class="brand-icon">
                    <svg class="library-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M3 6.5C3 5.11929 4.11929 4 5.5 4H19" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M21 4V18.5C21 19.8807 19.8807 21 18.5 21H5.5C4.11929 21 3 19.8807 3 18.5V6.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <div class="brand-text">
                    <h1 class="brand-title">Hệ thống Quản lý Thư viện - LibMan</h1>
                </div>
            </div>

            <!-- Thông tin người dùng và Logout -->
            <div class="header-user">
                <div class="user-info">
                    <span class="user-name"><%= displayName %></span>
                    <span class="user-role"><%= userRole %></span>
                </div>
                
                <!-- Mobile view - chỉ hiển thị tên -->
                <div class="user-info-mobile">
                    <span class="user-name-mobile"><%= displayName %></span>
                </div>

                <a href="<%= request.getContextPath() %>/user/logout" class="logout-btn">
                    <svg class="logout-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <polyline points="16,17 21,12 16,7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <line x1="21" y1="12" x2="9" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <span class="logout-text">Đăng xuất</span>
                    <span class="logout-text-mobile">Thoát</span>
                </a>
            </div>
        </div>
    </div>
</header>
