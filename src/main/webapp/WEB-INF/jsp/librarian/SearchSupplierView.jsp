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
                        <button type="submit" class="btn btn-primary" style="white-space: nowrap; padding: 6px 12px; min-width: 100px; font-size: 14px;">Tìm kiếm</button>
                        <button type="button" class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/searchSupplier'" style="white-space: nowrap; padding: 6px 12px; min-width: 100px; font-size: 14px;">Danh sách</button>
                        <button type="button" class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/supplier/new'" style="white-space: nowrap; padding: 6px 12px; min-width: 100px; font-size: 14px;">+ Thêm mới</button>
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
                            <c:when test="${totalItems == 0}">Không tìm thấy kết quả</c:when>
                            <c:otherwise>Tìm thấy ${totalItems} nhà cung cấp</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Controls: page info and page size -->
                <c:set var="page" value="${page != null ? page : 1}" />
                <c:set var="pageSize" value="${pageSize != null ? pageSize : 10}" />
                <c:set var="totalItems" value="${totalItems != null ? totalItems : 0}" />
                <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
                <c:set var="actualItemsCount" value="${fn:length(suppliers)}" />
                
                <!-- Simple pagination logic based on current page and total pages -->
                <c:set var="hasNextPage" value="${page < totalPages}" />
                <c:set var="hasPrevPage" value="${page > 1}" />

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;gap:12px;padding:8px;background:var(--brand-light);border-radius:8px;">
                    <div id="page-info" class="text-muted" style="font-size: 12px;">
                        <c:choose>
                            <c:when test="${totalItems == 0}">Hiển thị 0 kết quả</c:when>
                            <c:otherwise>Hiển thị ${actualItemsCount} kết quả của ${totalItems} (trang ${page}/${totalPages})</c:otherwise>
                        </c:choose>
                    </div>
                    <div style="display:flex;align-items:center;gap:6px;">
                        <span class="text-small" style="font-size: 12px;">Hiển thị:</span>
                        <form method="get" action="<c:url value='/searchSupplier'/>" style="display:flex;align-items:center;gap:6px;">
                            <input type="hidden" name="name" value="${param.name}" />
                            <label for="pageSize" style="font-size: 12px;">Kích thước trang:</label>
                            <select id="pageSize" name="pageSize" onchange="this.form.submit()" class="page-size-select" style="font-size: 12px; padding: 4px 6px;">
                                <option value="5" ${pageSize==5 ? 'selected' : ''}>5</option>
                                <option value="10" ${pageSize==10 ? 'selected' : ''}>10</option>
                                <option value="15" ${pageSize==15 ? 'selected' : ''}>15</option>
                            </select>
                            <input type="hidden" name="page" value="1" />
                        </form>
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

                <!-- Pagination controls - show exact page numbers based on total results -->
                <c:if test="${totalPages > 1}">
                <div id="pagination-controls" style="display:flex;justify-content:space-between;align-items:center;margin-top:16px;padding-top:16px;border-top:1px solid var(--border-light);">
                    <div style="display:flex;align-items:center;gap:8px;">
                        <c:url var="baseUrl" value="/searchSupplier" />

                        <!-- Previous button -->
                        <c:choose>
                            <c:when test="${hasPrevPage}">
                                <a href="${baseUrl}?name=${fn:escapeXml(param.name)}&amp;page=${page-1}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">← Trước</a>
                            </c:when>
                            <c:otherwise>
                                <span class="btn btn-sm btn-disabled">← Trước</span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Show page numbers around current page -->
                        <c:set var="startPage" value="${page - 2}" />
                        <c:if test="${startPage < 1}">
                            <c:set var="startPage" value="1" />
                        </c:if>
                        <c:set var="endPage" value="${page + 2}" />
                        <c:if test="${endPage > totalPages}">
                            <c:set var="endPage" value="${totalPages}" />
                        </c:if>

                        <!-- Show first page + ellipsis if needed -->
                        <c:if test="${startPage > 1}">
                            <a href="${baseUrl}?name=${fn:escapeXml(param.name)}&amp;page=1&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">1</a>
                            <c:if test="${startPage > 2}">
                                <span style="color: var(--text-medium); padding: 0 4px;">...</span>
                            </c:if>
                        </c:if>

                        <!-- Page numbers window -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="p">
                            <c:choose>
                                <c:when test="${p == page}">
                                    <span class="btn btn-sm btn-primary">${p}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${baseUrl}?name=${fn:escapeXml(param.name)}&amp;page=${p}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">${p}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Show ellipsis + last page if needed -->
                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <span style="color: var(--text-medium); padding: 0 4px;">...</span>
                            </c:if>
                            <a href="${baseUrl}?name=${fn:escapeXml(param.name)}&amp;page=${totalPages}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">${totalPages}</a>
                        </c:if>

                        <!-- Next button -->
                        <c:choose>
                            <c:when test="${hasNextPage}">
                                <a href="${baseUrl}?name=${fn:escapeXml(param.name)}&amp;page=${page+1}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">Sau →</a>
                            </c:when>
                            <c:otherwise>
                                <span class="btn btn-sm btn-disabled">Sau →</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="text-muted" style="font-size: 14px;">Trang ${page} / ${totalPages}</div>
                </div>
                </c:if>
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
