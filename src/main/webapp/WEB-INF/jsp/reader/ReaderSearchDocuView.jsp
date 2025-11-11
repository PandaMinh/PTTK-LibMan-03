<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm tài liệu - LibMan</title>
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
                    <div class="menu-icon" style="background: var(--brand); width: 40px; height: 40px; font-size: 18px;">🔍</div>
                    <div>
                        <h1 style="margin: 0; color: var(--brand); font-size: 20px;">Tìm kiếm tài liệu</h1>
                        <p style="margin: 2px 0 0 0; color: var(--text-medium); font-size: 13px;">Tra cứu thông tin sách, tạp chí và tài liệu trong thư viện</p>
                    </div>
                </div>
                <a href="<c:url value='/reader'/>" class="btn btn-outline" style="padding: 6px 12px; font-size: 14px;">← Quay lại</a>
            </div>
        </div>

        <!-- Search Form -->
        <div class="card mt-2">
            <form action="<c:url value='/searchDocument'/>" method="get" class="search-form" onsubmit="return validateSearch()">
                <div class="form-group">
                    <label for="title" class="form-label">Tiêu đề tài liệu:</label>
                    <div style="display: flex; gap: 12px; align-items: center;">
                        <input type="text" id="title" name="title" value="${param.title}" class="form-input" placeholder="Nhập tiêu đề sách cần tìm...">
                        <button type="submit" class="btn btn-primary" style="min-width: 120px; white-space: nowrap;">Tìm kiếm</button>
                    </div>
                    <div id="search-error" style="color: #dc3545; font-size: 14px; margin-top: 8px; display: none;">
                        Vui lòng nhập tiêu đề tài liệu cần tìm kiếm!
                    </div>
                </div>
            </form>
        </div>

        <!-- Results section -->
        <c:choose>
            <c:when test="${not empty documents}">
                <div class="card mt-2">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
                    <h2 style="margin: 0; color: var(--brand); font-size: 18px;">Kết quả tìm kiếm</h2>
                    <div class="alert alert-info" style="margin: 0; padding: 6px 10px; font-size: 13px;">
                        <c:choose>
                            <c:when test="${totalItems == 0}">Không tìm thấy kết quả</c:when>
                            <c:otherwise>Tìm thấy ${totalItems} tài liệu</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Controls: page info and page size (server-side) -->
                <c:set var="page" value="${page != null ? page : 1}" />
                <!-- Change default page size to 10 for better visibility -->
                <c:set var="pageSize" value="${pageSize != null ? pageSize : 10}" />
                <c:set var="totalItems" value="${totalItems != null ? totalItems : 0}" />
                <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
                <c:set var="actualItemsCount" value="${fn:length(documents)}" />
                
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
                        <form method="get" action="<c:url value='/searchDocument'/>" style="display:flex;align-items:center;gap:6px;">
                            <input type="hidden" name="title" value="${param.title}" />
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
                                <th>Tiêu đề</th>
                                <th>Tác giả</th>
                                <th>Thể loại</th>
                                <th>Năm</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="results-tbody">
                            <c:forEach items="${documents}" var="document">
                                <tr>
                                    <td title="${fn:escapeXml(document.title)}">${fn:escapeXml(document.title)}</td>
                                    <td title="${fn:escapeXml(document.author)}">${fn:escapeXml(document.author)}</td>
                                    <td title="${fn:escapeXml(document.category)}">${fn:escapeXml(document.category)}</td>
                                    <td>${document.yearPublic}</td>
                                    <td>
                                        <a href="<c:url value='/searchDocument?type=detail&id=${document.id}'/>" class="view-button">Xem chi tiết</a>
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
                        <c:url var="baseUrl" value="/searchDocument" />

                        <!-- Previous button -->
                        <c:choose>
                            <c:when test="${hasPrevPage}">
                                <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${page-1}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">← Trước</a>
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
                            <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=1&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">1</a>
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
                                    <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${p}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">${p}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Show ellipsis + last page if needed -->
                        <c:if test="${endPage < totalPages}">
                            <c:if test="${endPage < totalPages - 1}">
                                <span style="color: var(--text-medium); padding: 0 4px;">...</span>
                            </c:if>
                            <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${totalPages}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">${totalPages}</a>
                        </c:if>

                        <!-- Next button -->
                        <c:choose>
                            <c:when test="${hasNextPage}">
                                <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${page+1}&amp;pageSize=${pageSize}" class="btn btn-sm btn-outline">Sau →</a>
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
            <c:when test="${param.title != null && empty documents}">
                <!-- No results found -->
                <div class="card mt-2">
                    <div style="text-align: center; padding: 40px 20px;">
                        <div style="font-size: 48px; color: var(--text-medium); margin-bottom: 16px;">📚</div>
                        <h3 style="color: var(--brand); margin-bottom: 12px;">Không có kết quả khớp với tài liệu</h3>
                        <p style="color: var(--text-medium); margin-bottom: 24px;">
                            Không tìm thấy tài liệu nào có tiêu đề chứa từ khóa "<strong>${fn:escapeXml(param.title)}</strong>"
                        </p>
                        <div style="display: flex; gap: 12px; justify-content: center;">
                            <button onclick="document.getElementById('title').value=''; document.getElementById('title').focus();" 
                                    class="btn btn-primary">Thử từ khóa khác</button>
                            <a href="<c:url value='/reader'/>" class="btn btn-outline">Quay lại trang chủ</a>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:when test="${param.title != null && param.title.trim() == ''}">
                <!-- Empty search term -->
                <div class="card mt-2">
                    <div style="text-align: center; padding: 40px 20px;">
                        <div style="font-size: 48px; color: #f39c12; margin-bottom: 16px;">⚠️</div>
                        <h3 style="color: var(--brand); margin-bottom: 12px;">Chưa nhập từ khóa tìm kiếm</h3>
                        <p style="color: var(--text-medium); margin-bottom: 24px;">
                            Vui lòng nhập tiêu đề tài liệu cần tìm kiếm.
                        </p>
                        <div style="display: flex; gap: 12px; justify-content: center;">
                            <button onclick="document.getElementById('title').focus();" 
                                    class="btn btn-primary">Nhập từ khóa</button>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- First time visit - show instruction -->
                <div class="card mt-2">
                    <div style="text-align: center; padding: 40px 20px;">
                        <div style="font-size: 48px; color: var(--brand); margin-bottom: 16px;">🔍</div>
                        <h3 style="color: var(--brand); margin-bottom: 12px;">Tìm kiếm tài liệu</h3>
                        <p style="color: var(--text-medium); margin-bottom: 24px;">
                            Nhập tiêu đề tài liệu cần tìm và click "Tìm kiếm" để xem kết quả.
                        </p>
                        <button onclick="document.getElementById('title').focus();" 
                                class="btn btn-primary">Bắt đầu tìm kiếm</button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function validateSearch() {
            const titleInput = document.getElementById('title');
            const errorDiv = document.getElementById('search-error');
            
            if (titleInput.value.trim() === '') {
                errorDiv.style.display = 'block';
                titleInput.focus();
                return false;
            }
            
            errorDiv.style.display = 'none';
            return true;
        }
        
        // Hide error message when user starts typing
        document.getElementById('title').addEventListener('input', function() {
            document.getElementById('search-error').style.display = 'none';
        });
    </script>

    <!-- Server-side pagination implemented; no client-side pagination script needed -->
</body>
</html>