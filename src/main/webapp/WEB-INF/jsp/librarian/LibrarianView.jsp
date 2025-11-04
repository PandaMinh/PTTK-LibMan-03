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
	<jsp:include page="/WEB-INF/jsp/common/header.jsp" />
	<div class="container" style="margin-top:24px;">
		<h1 style="margin-bottom:24px;">Chào mừng, Thủ thư</h1>

		<c:if test="${param.success == 'true'}">
			<div class="alert success" style="margin-bottom:20px;">Thao tác thành công.</div>
		</c:if>
		<c:if test="${param.error == 'true'}">
			<div class="alert error" style="margin-bottom:20px;">Có lỗi xảy ra. Vui lòng kiểm tra lại.</div>
		</c:if>

		<div class="actions" style="margin-bottom:32px;">
			<ul style="list-style:none;padding:0;">
				<li style="margin-bottom:12px;"><a href="<c:url value='/searchSupplier'/>" style="display:inline-block;padding:8px 16px;background:#2b7a78;color:#fff;text-decoration:none;border-radius:6px;">Tìm nhà cung cấp / lập phiếu nhập</a></li>
				<li style="margin-bottom:12px;"><a href="<c:url value='/searchDocument'/>" style="display:inline-block;padding:8px 16px;background:#3d9970;color:#fff;text-decoration:none;border-radius:6px;">Tìm tài liệu</a></li>
			</ul>
		</div>

		<div class="recent" style="background:#fff;padding:20px;border-radius:8px;border:1px solid #eee;">
			<h2 style="margin-top:0;color:#2b7a78;">Các công việc thường dùng</h2>
			<p style="margin-bottom:8px;">- Tìm nhà cung cấp và chọn để tạo phiếu nhập.</p>
			<p style="margin-bottom:0;">- Tìm tài liệu để xem chi tiết hoặc thêm mới.</p>
		</div>

	</div>
</body>
</html>
