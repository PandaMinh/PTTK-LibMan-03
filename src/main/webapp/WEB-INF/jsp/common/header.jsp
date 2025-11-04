<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object userObj = session.getAttribute("user");
    String displayName = "Khách";
    String role = "";
    if (userObj != null) {
        try {
            java.lang.reflect.Method mName = userObj.getClass().getMethod("getName");
            java.lang.reflect.Method mRole = userObj.getClass().getMethod("getRole");
            Object n = mName.invoke(userObj);
            Object r = mRole.invoke(userObj);
            if (n != null) displayName = n.toString();
            if (r != null) role = r.toString();
        } catch (Exception e) {
            // ignore
        }
    }
%>
<div class="topbar">
  <div class="container header-flex">
    <div style="display:flex;align-items:center;gap:12px;">
      <div class="avatar" style="width:44px;height:44px;border-radius:8px;display:flex;align-items:center;justify-content:center;">📚</div>
      <div>
        <div class="system-title">Hệ thống Quản lý Thư viện - LibMan</div>
        <div class="text-muted" style="font-size:12px;">Quản lý tài nguyên thư viện</div>
      </div>
    </div>

    <div style="display:flex;align-items:center;gap:24px;">
      <div style="text-align:right;margin-right:16px;">
        <div style="font-weight:600;color:#2b7a78;">Xin chào, <%= displayName %></div>
        <div class="text-muted" style="font-size:12px;"> <%= role == null || role.isEmpty() ? "Khách" : role.toString() %> </div>
      </div>
  <a href="<%= request.getContextPath() %>/user/logout" class="btn-logout">Đăng xuất</a>
    </div>
  </div>
</div>
