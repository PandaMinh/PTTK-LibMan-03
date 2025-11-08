<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách phiếu nhập - LibMan</title>
    <link rel="stylesheet" href="<c:url value='/css/global.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/header.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/reader.css'/>" type="text/css">
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
    <div class="container main-content">
        <!-- Header Section -->
        <div class="card">
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="menu-icon" style="background: var(--warning); width: 40px; height: 40px; font-size: 18px;">📋</div>
                    <div>
                        <h1 style="margin: 0; color: var(--brand); font-size: 20px;">Lịch sử phiếu nhập kho</h1>
                        <p style="margin: 2px 0 0 0; color: var(--text-medium); font-size: 13px;">Quản lý và theo dõi các phiếu nhập đã tạo</p>
                    </div>
                </div>
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/addImportingInvoice" class="btn btn-success" style="padding: 8px 16px; font-size: 14px;">📝 Tạo phiếu mới</a>
                    <a href="${pageContext.request.contextPath}/librarian" class="btn btn-outline" style="padding: 8px 16px; font-size: 14px;">🏠 Về trang chủ</a>
                </div>
            </div>
        </div>

        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-error mt-2">${error}</div>
        </c:if>
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success mt-2">Thao tác thành công!</div>
        </c:if>

        <!-- Invoice List -->
        <div class="card mt-2">
            <c:choose>
                <c:when test="${empty invoices}">
                    <div class="empty-state">
                        <div style="text-align: center; padding: 40px;">
                            <div style="font-size: 48px; margin-bottom: 16px;">📋</div>
                            <h3 style="color: var(--text-medium); margin-bottom: 8px;">Chưa có phiếu nhập nào</h3>
                            <p style="color: var(--text-light); margin-bottom: 24px;">Bắt đầu tạo phiếu nhập kho đầu tiên</p>
                            <a href="${pageContext.request.contextPath}/addImportingInvoice" class="btn btn-primary">Tạo phiếu nhập</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <h2 style="margin: 0 0 16px 0; color: var(--brand); font-size: 18px;">
                        Danh sách phiếu nhập 
                        <span style="background: var(--info); color: white; padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: normal;">
                            ${invoices.size()} phiếu
                        </span>
                    </h2>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">Mã phiếu</th>
                                    <th style="width: 120px;">Ngày nhập</th>
                                    <th>Nhà cung cấp</th>
                                    <th style="width: 120px;">Liên hệ</th>
                                    <th style="width: 120px;">Hình thức thanh toán</th>
                                    <th style="width: 150px;">Thông tin ngân hàng</th>
                                    <th style="width: 100px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${invoices}" var="invoice">
                                    <tr class="clickable-row">
                                        <td>
                                            <div class="id-badge">#${invoice.id}</div>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${invoice.importDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500;">${invoice.supplier.name}</div>
                                            <div style="font-size: 12px; color: var(--text-medium);">${invoice.supplier.address}</div>
                                        </td>
                                        <td>${invoice.supplier.tel}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${invoice.typePay == 'cash'}">
                                                    <span class="badge badge-success">💰 Tiền mặt</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-info">🏦 Chuyển khoản</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty invoice.bank}">
                                                    <span style="font-size: 12px;">${invoice.bank}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--text-light); font-style: italic;">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="${pageContext.request.contextPath}/librarian?action=viewInvoiceDetail&id=${invoice.id}" 
                                                   class="btn btn-sm btn-outline" 
                                                   style="padding: 4px 8px; font-size: 12px;" 
                                                   title="Xem chi tiết">👁️</a>
                                                <a href="${pageContext.request.contextPath}/librarian?action=printInvoice&id=${invoice.id}" 
                                                   class="btn btn-sm btn-info" 
                                                   style="padding: 4px 8px; font-size: 12px;" 
                                                   title="In phiếu">🖨️</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Summary Stats -->
        <c:if test="${not empty invoices}">
            <div class="card mt-2">
                <h3 style="color: var(--brand); margin: 0 0 12px 0; font-size: 16px;">Thống kê tổng quan</h3>
                <div class="grid grid-3">
                    <div class="stat-card">
                        <div class="stat-number">${invoices.size()}</div>
                        <div class="stat-label">Tổng phiếu nhập</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="cashCount" value="0"/>
                            <c:forEach items="${invoices}" var="invoice">
                                <c:if test="${invoice.typePay == 'cash'}">
                                    <c:set var="cashCount" value="${cashCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${cashCount}
                        </div>
                        <div class="stat-label">Thanh toán tiền mặt</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${invoices.size() - cashCount}</div>
                        <div class="stat-label">Thanh toán chuyển khoản</div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <style>
        .id-badge {
            background: var(--brand);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }
        
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
            display: inline-block;
        }
        
        .badge-success {
            background: var(--success);
            color: white;
        }
        
        .badge-info {
            background: var(--info);
            color: white;
        }
        
        .btn-group {
            display: flex;
            gap: 4px;
        }
        
        .btn-sm {
            padding: 4px 8px !important;
            font-size: 12px !important;
            min-width: auto !important;
        }
        
        .stat-card {
            text-align: center;
            padding: 16px;
            background: var(--bg-light);
            border-radius: 8px;
        }
        
        .stat-number {
            font-size: 24px;
            font-weight: 600;
            color: var(--brand);
            margin-bottom: 4px;
        }
        
        .stat-label {
            font-size: 12px;
            color: var(--text-medium);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .grid-3 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
        }
    </style>
</body>
</html>