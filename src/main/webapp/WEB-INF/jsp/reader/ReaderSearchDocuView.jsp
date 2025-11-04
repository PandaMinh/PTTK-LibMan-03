<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm tài liệu - Hệ thống Quản lý Thư viện</title>
    <!-- shared header/styles -->
    <link rel="stylesheet" href="<c:url value='/css/reader.css'/>" type="text/css">
    <!-- page-specific styles -->
    <link rel="stylesheet" href="<c:url value='/css/search-document.css'/>" type="text/css">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
    <div class="container search-page" style="margin-top:24px;">
    <h2 style="margin-bottom:20px;">Tìm kiếm tài liệu</h2>
        <div class="search-form" style="margin-bottom:20px;">
            <form action="<c:url value='/searchDocument'/>" method="get">
                <div class="form-group">
                    <label for="title">Tiêu đề tài liệu:</label>
                    <input type="text" id="title" name="title" value="${param.title}" required>
                    <button type="submit">Tìm kiếm</button>
                </div>
            </form>
        </div>

        <c:if test="${not empty documents}">
            <div class="search-results">
                <h3>Kết quả tìm kiếm</h3>

                <!-- Controls: page info and page size (server-side) -->
                <c:set var="page" value="${page != null ? page : 1}" />
                <!-- reduce default page size to avoid long scrolling -->
                <c:set var="pageSize" value="${pageSize != null ? pageSize : 5}" />
                <c:set var="totalItems" value="${totalItems != null ? totalItems : 0}" />
                <c:set var="totalPages" value="${(totalItems + pageSize - 1) / pageSize}" />

                <c:set var="startIndex" value="${((page-1)*pageSize)+1}" />
                <c:choose>
                    <c:when test="${page*pageSize > totalItems}">
                        <c:set var="endIndex" value="${totalItems}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="endIndex" value="${page*pageSize}" />
                    </c:otherwise>
                </c:choose>

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;gap:12px;">
                    <div id="page-info" class="text-muted">
                        <c:choose>
                            <c:when test="${totalItems == 0}">Hiển thị 0 - 0 / 0 kết quả</c:when>
                            <c:otherwise>Hiển thị ${startIndex} - ${endIndex} / ${totalItems} kết quả</c:otherwise>
                        </c:choose>
                    </div>
                    <div style="display:flex;align-items:center;gap:8px;">
                        <form method="get" action="<c:url value='/searchDocument'/>" style="display:flex;align-items:center;gap:8px;">
                            <input type="hidden" name="title" value="${param.title}" />
                            <label for="pageSize">Kích thước trang:</label>
                            <select id="pageSize" name="pageSize" onchange="this.form.submit()" class="page-size-select">
                                <option value="5" ${pageSize==5 ? 'selected' : ''}>5</option>
                                <option value="8" ${pageSize==8 ? 'selected' : ''}>8</option>
                                <option value="10" ${pageSize==10 ? 'selected' : ''}>10</option>
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
                                    <td class="truncate-long" title="${fn:escapeXml(document.title)}">${fn:escapeXml(document.title)}</td>
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

                <!-- Pagination controls (server-rendered) -->
                <div id="pagination-controls" style="display:flex;justify-content:space-between;align-items:center;margin-top:12px;">
                    <div>
                        <c:url var="baseUrl" value="/searchDocument" />
                        <!-- pagination window: show current +/-2 pages with ellipses -->
                        <c:set var="startPage" value="${page - 2}" />
                        <c:if test="${startPage lt 1}">
                            <c:set var="startPage" value="1" />
                        </c:if>
                        <c:set var="endPage" value="${page + 2}" />
                        <c:if test="${endPage gt totalPages}">
                            <c:set var="endPage" value="${totalPages}" />
                        </c:if>

                        <c:choose>
                            <c:when test="${page > 1}">
                                <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${page-1}&amp;pageSize=${pageSize}">Trước</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">Trước</span>
                            </c:otherwise>
                        </c:choose>

                        &nbsp;
                        <!-- show first page + leading ellipsis if needed -->
                        <c:if test="${startPage gt 1}">
                            <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=1&amp;pageSize=${pageSize}">1</a>
                            <span>...</span>&nbsp;
                        </c:if>

                        <!-- numeric pages window -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="p">
                            <c:choose>
                                <c:when test="${p == page}">
                                    <strong>${p}</strong>&nbsp;
                                </c:when>
                                <c:otherwise>
                                    <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${p}&amp;pageSize=${pageSize}">${p}</a>&nbsp;
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- trailing ellipsis + last page if needed -->
                        <c:if test="${endPage lt totalPages}">
                            <span>...</span>&nbsp;
                            <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${totalPages}&amp;pageSize=${pageSize}">${totalPages}</a>&nbsp;
                        </c:if>

                        &nbsp;
                        <c:choose>
                            <c:when test="${page lt totalPages}">
                                <a href="${baseUrl}?title=${fn:escapeXml(param.title)}&amp;page=${page+1}&amp;pageSize=${pageSize}">Sau</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">Sau</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="text-muted">Trang ${page} / ${totalPages}</div>
                </div>
            </div>
        </c:if>

        <div class="navigation" style="margin-top:24px;">
            <a href="<c:url value='/reader'/>" class="back-button">Quay lại trang bạn đọc</a>
        </div>
    </div>

    <!-- Server-side pagination implemented; no client-side pagination script needed -->
</body>
</html>