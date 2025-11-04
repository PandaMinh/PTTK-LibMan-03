<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
		Object userObj = session.getAttribute("user");
		String name = "Bạn đọc";
		String email = "";
		String tel = "";
		String address = "";
		if (userObj != null) {
				try {
						// Use reflection lightly to avoid compile dependency on model class in JSP
						java.lang.reflect.Method mName = userObj.getClass().getMethod("getName");
						java.lang.reflect.Method mEmail = userObj.getClass().getMethod("getEmail");
						java.lang.reflect.Method mTel = userObj.getClass().getMethod("getTel");
						java.lang.reflect.Method mAddress = userObj.getClass().getMethod("getAddress");
						Object n = mName.invoke(userObj);
						Object e = mEmail.invoke(userObj);
						Object t = mTel.invoke(userObj);
						Object a = mAddress.invoke(userObj);
						if (n != null) name = n.toString();
						if (e != null) email = e.toString();
						if (t != null) tel = t.toString();
						if (a != null) address = a.toString();
				} catch (Exception ex) {
						// ignore and use defaults
				}
		}
%>
<!doctype html>
<html lang="vi">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>Giao diện bạn đọc - Thư viện</title>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/css/reader.css" />
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

	<div class="container">
		<div class="card" style="margin-top:24px; border-color:#2b7a78;">
			<h2 style="margin:0;color:#2b7a78;">Chào mừng đến với Thư viện LibMan</h2>
			<p style="margin:8px 0 0 0;color:#444;">Chọn chức năng bạn muốn sử dụng</p>
		</div>

		<div class="grid" style="margin-top:24px;">
			<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/searchDocument'">
				<div style="display:flex;gap:16px;align-items:center;">
					<div class="menu-icon" style="background:#2b7a78">🔎</div>
					<div>
						<div class="menu-title">Tìm kiếm tài liệu</div>
						<div class="menu-desc">Tra cứu thông tin sách trong thư viện</div>
					</div>
				</div>
			</div>

			<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/borrowings'">
				<div style="display:flex;gap:16px;align-items:center;">
					<div class="menu-icon" style="background:#3d9970">📚</div>
					<div>
						<div class="menu-title">Sách đang mượn</div>
						<div class="menu-desc">Xem danh sách sách bạn đang mượn</div>
					</div>
				</div>
			</div>

			<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/history'">
				<div style="display:flex;gap:16px;align-items:center;">
					<div class="menu-icon" style="background:#9b59b6">🔁</div>
					<div>
						<div class="menu-title">Lịch sử mượn trả</div>
						<div class="menu-desc">Xem lịch sử mượn và trả sách</div>
					</div>
				</div>
			</div>

			<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/registerCard'">
				<div style="display:flex;gap:16px;align-items:center;">
					<div class="menu-icon" style="background:#f39c12">➕</div>
					<div>
						<div class="menu-title">Đăng ký thẻ bạn đọc</div>
						<div class="menu-desc">Đăng ký làm thẻ thư viện trực tuyến</div>
					</div>
				</div>
			</div>
		</div>

		<div class="card" style="margin-top:24px;">
			<h3 style="margin:0;color:#2b7a78;">Thông tin cá nhân</h3>
			<div class="info-grid">
				<div class="info-item">
					<div style="font-size:12px;color:#888;">Họ và tên</div>
					<div style="font-weight:600;"><%= name %></div>
				</div>
				<div class="info-item">
					<div style="font-size:12px;color:#888;">Email</div>
					<div style="font-weight:600;"><%= email %></div>
				</div>
				<div class="info-item">
					<div style="font-size:12px;color:#888;">Số điện thoại</div>
					<div style="font-weight:600;"><%= tel %></div>
				</div>
				<div class="info-item">
					<div style="font-size:12px;color:#888;">Địa chỉ</div>
					<div style="font-weight:600;"><%= address %></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
