<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
	<meta charset="UTF-8">
	<title>Trang Thủ Thư - LibMan</title>
	<link rel="stylesheet" href="<c:url value='/css/global.css'/>" type="text/css">
	<link rel="stylesheet" href="<c:url value='/css/header.css'/>" type="text/css">
	<link rel="stylesheet" href="<c:url value='/css/reader.css'/>" type="text/css">
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/common/header.jsp" />
	<div class="container main-content mt-3">
		<!-- Welcome Banner -->
		<div class="card">
			<div style="display: flex; align-items: center; justify-content: space-between;">
				<div style="display: flex; align-items: center; gap: 12px;">
					<div class="menu-icon" style="background: var(--brand); width: 40px; height: 40px; font-size: 18px;">👨‍💼</div>
					<div>
						<h1 style="margin: 0; color: var(--brand); font-size: 20px;">Chào mừng, Thủ thư</h1>
						<p style="margin: 2px 0 0 0; color: var(--text-medium); font-size: 13px;">Quản lý nhập kho và tài liệu thư viện</p>
					</div>
				</div>
			</div>
		</div>

		<c:if test="${param.success == 'true'}">
			<div class="alert alert-success mt-2">Thao tác thành công.</div>
		</c:if>
		<c:if test="${param.error == 'true'}">
			<div class="alert alert-error mt-2">Có lỗi xảy ra. Vui lòng kiểm tra lại.</div>
		</c:if>

		<!-- Main Functions -->
		<div class="card mt-2">
			<h2 style="margin: 0 0 16px 0; color: var(--brand); font-size: 18px;">Chức năng chính</h2>
			<div class="grid grid-2">
				<div class="menu-card card" onclick="location.href='${pageContext.request.contextPath}/searchSupplier'">
					<div style="display: flex; align-items: center; gap: 12px;">
						<div class="menu-icon" style="background: var(--brand); width: 40px; height: 40px; font-size: 18px;">🏢</div>
						<div>
							<div class="menu-title" style="font-size: 16px;">Quản lý nhà cung cấp</div>
							<div class="menu-desc" style="font-size: 13px;">Tìm kiếm nhà cung cấp và tạo phiếu nhập kho</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='${pageContext.request.contextPath}/searchDocument'">
					<div style="display: flex; align-items: center; gap: 12px;">
						<div class="menu-icon" style="background: var(--success); width: 40px; height: 40px; font-size: 18px;">📚</div>
						<div>
							<div class="menu-title" style="font-size: 16px;">Quản lý tài liệu</div>
							<div class="menu-desc" style="font-size: 13px;">Tìm kiếm, thêm mới và chỉnh sửa tài liệu</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='${pageContext.request.contextPath}/librarian/importingInvoices'">
					<div style="display: flex; align-items: center; gap: 12px;">
						<div class="menu-icon" style="background: var(--info); width: 40px; height: 40px; font-size: 18px;">📋</div>
						<div>
							<div class="menu-title" style="font-size: 16px;">Phiếu nhập kho</div>
							<div class="menu-desc" style="font-size: 13px;">Xem danh sách và quản lý các phiếu nhập</div>
						</div>
					</div>
				</div>

				<div class="menu-card card" onclick="location.href='${pageContext.request.contextPath}/librarian/reports'">
					<div style="display: flex; align-items: center; gap: 12px;">
						<div class="menu-icon" style="background: var(--warning); width: 40px; height: 40px; font-size: 18px;">📊</div>
						<div>
							<div class="menu-title" style="font-size: 16px;">Báo cáo thống kê</div>
							<div class="menu-desc" style="font-size: 13px;">Xem báo cáo nhập kho và tồn kho</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Quick Actions -->
		<div class="card mt-2">
			<h3 style="color: var(--brand); margin: 0 0 12px 0; font-size: 18px;">Thao tác nhanh</h3>
			<div style="display: flex; gap: 12px; flex-wrap: wrap;">
				<a href="${pageContext.request.contextPath}/searchSupplier" class="btn btn-primary" style="padding: 6px 12px; font-size: 14px;">Tạo phiếu nhập mới</a>
				<a href="${pageContext.request.contextPath}/searchDocument" class="btn btn-outline" style="padding: 6px 12px; font-size: 14px;">Tìm tài liệu</a>
				<a href="${pageContext.request.contextPath}/librarian/importingInvoices" class="btn btn-outline" style="padding: 6px 12px; font-size: 14px;">Xem phiếu nhập</a>
			</div>
		</div>

	</div>
</body>
</html>
