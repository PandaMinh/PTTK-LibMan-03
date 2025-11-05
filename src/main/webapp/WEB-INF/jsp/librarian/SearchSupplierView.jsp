<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm nhà cung cấp - LibMan</title>
    <link rel="stylesheet" href="<c:url value='/css/global.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/header.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/reader.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/search-document.css'/>" type="text/css">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
    <div class="container search-page main-content mt-3">
        <!-- Search Header -->
        <div class="card">
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="menu-icon" style="background: var(--brand); width: 40px; height: 40px; font-size: 18px;">🏢</div>
                    <div>
                        <h1 style="margin: 0; color: var(--brand); font-size: 20px;">Tìm kiếm nhà cung cấp</h1>
                        <p style="margin: 2px 0 0 0; color: var(--text-medium); font-size: 13px;">Tra cứu thông tin nhà cung cấp và tạo phiếu nhập kho</p>
                    </div>
                </div>
                <a href="<c:url value='/librarian'/>" class="btn btn-outline" style="padding: 6px 12px; font-size: 14px;">← Quay lại</a>
            </div>
        </div>

        <!-- Search Form -->
        <div class="card mt-2">
            <form action="<c:url value='/searchSupplier'/>" method="get" class="search-form" onsubmit="return validateSearch()">
                <div class="form-group">
                    <label for="name" class="form-label">Tên nhà cung cấp:</label>
                    <div style="display: flex; gap: 12px; align-items: center;">
                        <input type="text" id="name" name="name" value="${param.name}" class="form-input" placeholder="Nhập tên nhà cung cấp cần tìm...">
                        <button type="submit" class="btn btn-primary" style="min-width: 120px; white-space: nowrap;">Tìm kiếm</button>
                        <a href="<c:url value='/searchSupplier'/>" class="btn btn-outline" style="white-space: nowrap;">Danh sách NCC</a>
                        <a href="<c:url value='/supplier/new'/>" class="btn btn-success" style="white-space: nowrap;">+ Thêm mới NCC</a>
                    </div>
                    <div id="search-error" style="color: #dc3545; font-size: 14px; margin-top: 8px; display: none;">
                        Vui lòng nhập tên nhà cung cấp cần tìm kiếm!
                    </div>
                </div>
            </form>
        </div>

        <!-- Results section -->
        <c:choose>
            <c:when test="${not empty suppliers}">
                <div class="card mt-2">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
                    <h2 style="margin: 0; color: var(--brand); font-size: 18px;">Kết quả tìm kiếm</h2>
                    <div class="alert alert-info" style="margin: 0; padding: 6px 10px; font-size: 13px;">
                        <c:choose>
                            <c:when test="${fn:length(suppliers) == 0}">Không tìm thấy kết quả</c:when>
                            <c:otherwise>Tìm thấy ${fn:length(suppliers)} nhà cung cấp</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="table-responsive">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Tên nhà cung cấp</th>
                                <th>Điện thoại</th>
                                <th>Địa chỉ</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${suppliers}" var="supplier">
                                <tr>
                                    <td title="${fn:escapeXml(supplier.name)}">${fn:escapeXml(supplier.name)}</td>
                                    <td title="${fn:escapeXml(supplier.tel)}">${fn:escapeXml(supplier.tel)}</td>
                                    <td title="${fn:escapeXml(supplier.address)}">${fn:escapeXml(supplier.address)}</td>
                                    <td>
                                        <a href="<c:url value='/searchSupplier?action=select&id=${supplier.id}'/>" class="view-button">Chọn NCC</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                </div>
            </div>
            </c:when>
            <c:when test="${param.name != null && empty suppliers}">
                <!-- No results found -->
                <div class="card mt-2">
                    <div style="text-align: center; padding: 40px 20px;">
                        <div style="font-size: 48px; color: var(--text-medium); margin-bottom: 16px;">🏢</div>
                        <h3 style="color: var(--brand); margin-bottom: 12px;">Không có kết quả khớp với nhà cung cấp</h3>
                        <p style="color: var(--text-medium); margin-bottom: 24px;">
                            Không tìm thấy nhà cung cấp nào có tên chứa từ khóa "<strong>${fn:escapeXml(param.name)}</strong>"
                        </p>
                        <div style="display: flex; gap: 12px; justify-content: center;">
                            <button onclick="document.getElementById('name').value=''; document.getElementById('name').focus();" 
                                    class="btn btn-primary">Thử từ khóa khác</button>
                            <a href="<c:url value='/supplier/new'/>" class="btn btn-success">Thêm nhà cung cấp mới</a>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:when test="${param.name != null && param.name.trim() == ''}">
                <!-- Empty search term -->
                <div class="card mt-2">
                    <div style="text-align: center; padding: 40px 20px;">
                        <div style="font-size: 48px; color: #f39c12; margin-bottom: 16px;">⚠️</div>
                        <h3 style="color: var(--brand); margin-bottom: 12px;">Chưa nhập từ khóa tìm kiếm</h3>
                        <p style="color: var(--text-medium); margin-bottom: 24px;">
                            Vui lòng nhập tên nhà cung cấp cần tìm kiếm hoặc xem danh sách tất cả nhà cung cấp.
                        </p>
                        <div style="display: flex; gap: 12px; justify-content: center;">
                            <button onclick="document.getElementById('name').focus();" 
                                    class="btn btn-primary">Nhập từ khóa</button>
                            <a href="<c:url value='/searchSupplier'/>" class="btn btn-outline">Xem tất cả NCC</a>
                        </div>
                    </div>
                </div>
            </c:when>
        </c:choose>
    </div>

    <script>
        function validateSearch() {
            const nameInput = document.getElementById('name');
            const errorDiv = document.getElementById('search-error');
            
            if (nameInput.value.trim() === '') {
                errorDiv.style.display = 'block';
                nameInput.focus();
                return false;
            }
            
            errorDiv.style.display = 'none';
            return true;
        }
        
        // Hide error message when user starts typing
        document.getElementById('name').addEventListener('input', function() {
            document.getElementById('search-error').style.display = 'none';
        });
    </script>
</body>
</html>
