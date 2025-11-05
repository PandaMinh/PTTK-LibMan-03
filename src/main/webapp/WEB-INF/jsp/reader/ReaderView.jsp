<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>Giao diện bạn đọc - Thư viện LibMan</title>
	<link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css" />
	<link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css" />
	<link rel="stylesheet" href="<%= request.getContextPath() %>/css/reader.css" />
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

	<div class="container main-content">
		<!-- Main Menu -->
		<div class="card mt-3">
			<h2 style="color: var(--brand); margin-top: 0;">Chức năng chính</h2>
			<div class="grid grid-2 mt-2">
				<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/searchDocument'">
					<div style="display: flex; gap: 16px; align-items: center;">
						<div class="menu-icon" style="background: var(--brand);">🔍</div>
						<div>
							<div class="menu-title">Tìm kiếm tài liệu</div>
							<div class="menu-desc">Tra cứu thông tin sách, tạp chí và tài liệu trong thư viện</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/borrowings'">
					<div style="display: flex; gap: 16px; align-items: center;">
						<div class="menu-icon" style="background: var(--success);">📚</div>
						<div>
							<div class="menu-title">Sách đang mượn</div>
							<div class="menu-desc">Xem danh sách và trạng thái các tài liệu bạn đang mượn</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/history'">
					<div style="display: flex; gap: 16px; align-items: center;">
						<div class="menu-icon" style="background: var(--info);">📊</div>
						<div>
							<div class="menu-title">Lịch sử mượn trả</div>
							<div class="menu-desc">Xem lịch sử mượn và trả sách, thống kê cá nhân</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/reservations'">
					<div style="display: flex; gap: 16px; align-items: center;">
						<div class="menu-icon" style="background: var(--warning);">📋</div>
						<div>
							<div class="menu-title">Đặt trước tài liệu</div>
							<div class="menu-desc">Đặt trước sách đang được mượn hoặc sách mới</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/registerCard'">
					<div style="display: flex; gap: 16px; align-items: center;">
						<div class="menu-icon" style="background: #f39c12;">➕</div>
						<div>
							<div class="menu-title">Gia hạn thẻ</div>
							<div class="menu-desc">Gia hạn thẻ bạn đọc hoặc đăng ký dịch vụ mới</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='<%= request.getContextPath() %>/reader/notifications'">
					<div style="display: flex; gap: 16px; align-items: center;">
						<div class="menu-icon" style="background: #e74c3c;">🔔</div>
						<div>
							<div class="menu-title">Thông báo</div>
							<div class="menu-desc">Xem thông báo về sách sắp hết hạn, sự kiện thư viện</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Quick Actions -->
		<div class="card mt-3">
			<h3 style="color: var(--brand); margin-top: 0;">Thao tác nhanh</h3>
			<div style="display: flex; gap: 12px; flex-wrap: wrap;">
				<a href="<%= request.getContextPath() %>/reader/profile" class="btn btn-primary">Xem thông tin cá nhân</a>
				<a href="<%= request.getContextPath() %>/reader/profile/edit" class="btn btn-outline">Cập nhật thông tin</a>
				<a href="<%= request.getContextPath() %>/reader/password/change" class="btn btn-outline">Đổi mật khẩu</a>
				<a href="<%= request.getContextPath() %>/reader/borrowings" class="btn btn-outline">Xem sách đang mượn</a>
				<a href="<%= request.getContextPath() %>/library/rules" class="btn btn-outline">Quy định thư viện</a>
			</div>
		</div>
	</div>
</body>
</html>