<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Trang Thủ Thư - Library Management</title>
	<link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
</head>
<body>
	<div class="container">
		<h1>Chào mừng, Thủ thư</h1>

		<c:if test="${param.success == 'true'}">
			<div class="alert success">Thao tác thành công.</div>
		</c:if>
		<c:if test="${param.error == 'true'}">
			<div class="alert error">Có lỗi xảy ra. Vui lòng kiểm tra lại.</div>
		</c:if>

		<div class="actions">
			<ul>
				<li><a href="<c:url value='/searchSupplier'/>">Tìm nhà cung cấp / lập phiếu nhập</a></li>
				<li><a href="<c:url value='/searchDocument'/>">Tìm tài liệu</a></li>
				<li><a href="<c:url value='/user/logout'/>">Đăng xuất</a></li>
			</ul>
		</div>

		<div class="recent">
			<h2>Các công việc thường dùng</h2>
			<p>- Tìm nhà cung cấp và chọn để tạo phiếu nhập.</p>
			<p>- Tìm tài liệu để xem chi tiết hoặc thêm mới.</p>
		</div>

	</div>
</body>
</html>
