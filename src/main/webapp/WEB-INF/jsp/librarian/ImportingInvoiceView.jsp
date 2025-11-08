<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhập tài liệu từ nhà cung cấp - LibMan</title>
    <link rel="stylesheet" href="<c:url value='/css/global.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/header.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/reader.css'/>" type="text/css">
</head>
<body style="background: linear-gradient(135deg, #f9fafb 0%, #e5e7eb 100%); min-height: 100vh;">
    <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
    
    <!-- Header Section -->
    <div style="background: #e8f4f3; border-bottom: 1px solid var(--border); box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
        <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 16px 24px;">
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <h1 style="margin: 0; color: var(--brand); font-size: 24px; font-weight: 600;">
                    Nhập tài liệu từ nhà cung cấp
                </h1>
                <a href="${pageContext.request.contextPath}/searchSupplier" class="btn btn-outline" style="padding: 8px 16px; font-size: 14px;">
                    ← Quay lại
                </a>
            </div>
        </div>
    </div>

    <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 32px 24px;">
        
        <!-- Header phiếu nhập -->
        <div class="card" style="border: 2px solid var(--brand); margin-bottom: 24px;">
            <div style="background: #e8f4f3; padding: 16px; text-align: center; border-bottom: 1px solid var(--border);">
                <h2 style="margin: 0; color: var(--brand); font-size: 20px; font-weight: 700;">
                    PHIẾU NHẬP TÀI LIỆU
                </h2>
                <p style="margin: 8px 0 0 0; font-size: 14px; color: var(--text-medium);">
                    Ngày <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd"/> tháng <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MM"/> năm <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/> - 
                    Giờ: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm:ss"/>
                </p>
            </div>
        </div>

        <!-- Thông tin người nhập -->
        <div class="card" style="margin-bottom: 24px;">
            <div class="card-header">
                <h3>Thông tin người nhập</h3>
            </div>
            <div class="card-body">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div>
                        <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">Tên thư viện</label>
                        <p style="margin: 0; font-weight: 500; font-size: 14px;">Thư viện LibMan</p>
                    </div>
                    <div>
                        <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">Thủ thư nhập tài liệu</label>
                        <p style="margin: 0; font-weight: 500; font-size: 14px;">${sessionScope.user.name}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thông tin nhà cung cấp -->
        <div class="card" style="margin-bottom: 24px;">
            <div class="card-header">
                <h3>Thông tin nhà cung cấp</h3>
            </div>
            <div class="card-body">
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                    <div>
                        <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">Tên nhà cung cấp</label>
                        <p style="margin: 0; font-weight: 500; font-size: 14px;">${supplier.name}</p>
                    </div>
                    <div>
                        <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">Địa chỉ</label>
                        <p style="margin: 0; font-size: 14px;">${supplier.address}</p>
                    </div>
                    <div>
                        <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">Số điện thoại</label>
                        <p style="margin: 0; font-size: 14px;">${supplier.tel}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tìm kiếm tài liệu -->
        <div class="card" style="margin-bottom: 24px;">
            <div class="card-header">
                <h3>Tìm kiếm tài liệu để nhập</h3>
            </div>
            <div class="card-body">
                <div style="display: flex; gap: 16px; margin-bottom: 16px;">
                    <input type="text" 
                           id="documentSearchInput"
                           placeholder="Nhập tên tài liệu để tìm kiếm..." 
                           style="flex: 1; padding: 8px 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 14px;">
                    <button type="button" 
                            onclick="searchDocuments()" 
                            class="btn btn-primary" 
                            style="padding: 8px 16px; font-size: 14px; background: var(--brand); border: none;">
                        🔍 Tìm kiếm
                    </button>
                </div>
                
                <!-- Dropdown danh sách tài liệu -->
                <div id="documentSelectContainer" style="margin-bottom: 16px; display: none;">
                    <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">
                        Chọn tài liệu từ kết quả tìm kiếm (<span id="documentCount">0</span> kết quả)
                    </label>
                    <select id="documentSelect" 
                            onchange="selectDocumentFromDropdown()" 
                            style="width: 100%; padding: 8px 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 14px; height: 120px; overflow-y: auto;" 
                            size="5">
                        <option value="">-- Chọn tài liệu để nhập --</option>
                    </select>
                </div>
                
                <c:if test="${empty documents and not empty param.documentName}">
                    <div style="padding: 16px; background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 6px; text-align: center; color: #856404;">
                        Không tìm thấy tài liệu nào với từ khóa "${param.documentName}"
                    </div>
                </c:if>
                
                <c:if test="${not empty documents}">
                    <div style="border: 1px solid var(--border); border-radius: 8px; overflow: hidden;">
                        <table class="table" id="tblListDocument" style="margin: 0;">
                            <thead style="background: var(--bg-light);">
                                <tr>
                                    <th style="padding: 12px; font-weight: 600;">Mã TL</th>
                                    <th style="padding: 12px; font-weight: 600;">Tên tài liệu</th>
                                    <th style="padding: 12px; font-weight: 600;">Tác giả</th>
                                    <th style="padding: 12px; font-weight: 600;">NXB</th>
                                    <th style="padding: 12px; font-weight: 600;">Năm XB</th>
                                    <th style="padding: 12px; font-weight: 600;">Chọn</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${documents}" var="document">
                                    <tr style="border-top: 1px solid var(--border);">
                                        <td style="padding: 12px;">${document.id}</td>
                                        <td style="padding: 12px; font-weight: 500;">${document.title}</td>
                                        <td style="padding: 12px;">${document.author}</td>
                                        <td style="padding: 12px;">${document.category}</td>
                                        <td style="padding: 12px;">${document.yearPublic}</td>
                                        <td style="padding: 12px;">
                                            <button type="button" class="btn btn-outline btn-sm" 
                                                    onclick="selectDocument('${document.id}', '${document.title}')"
                                                    style="padding: 4px 8px; font-size: 12px;">
                                                Chọn
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Danh sách tài liệu nhập -->
        <div class="card" style="margin-bottom: 24px;">
            <div class="card-header">
                <h3>📋 Danh sách tài liệu nhập</h3>
            </div>
            <div class="card-body">
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; margin: 0; font-size: 14px;">
                        <thead style="background: var(--primary); color: white;">
                            <tr>
                                <th style="padding: 8px; font-weight: 500; text-align: center; font-size: 13px;">STT</th>
                                <th style="padding: 8px; font-weight: 500; text-align: left; font-size: 13px;">Tên tài liệu</th>
                                <th style="padding: 8px; font-weight: 500; text-align: center; font-size: 13px;">Số lượng</th>
                                <th style="padding: 8px; font-weight: 500; text-align: center; font-size: 13px;">Đơn giá</th>
                                <th style="padding: 8px; font-weight: 500; text-align: center; font-size: 13px;">Thành tiền</th>
                                <th style="padding: 8px; font-weight: 500; text-align: center; font-size: 13px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty sessionScope.importingDetails}">
                                    <tr>
                                        <td colspan="6" style="padding: 16px; text-align: center; color: var(--text-secondary);">
                                            📝 Chưa có tài liệu nào được thêm vào danh sách
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="totalAmount" value="0"/>
                                    <c:set var="totalQuantity" value="0"/>
                                    <c:forEach items="${sessionScope.importingDetails}" var="detail" varStatus="status">
                                        <tr style="border-bottom: 1px solid var(--border);" data-document-id="${detail.document.id}">
                                            <td style="padding: 8px; text-align: center; font-weight: 500;">${status.index + 1}</td>
                                            <td style="padding: 8px; font-weight: 500;">
                                                <div>${detail.document.title}</div>
                                                <div style="font-size: 12px; color: var(--text-secondary); margin-top: 2px;">${detail.document.author}</div>
                                            </td>
                                            <td style="padding: 8px; text-align: center; color: var(--primary); font-weight: 500;">${detail.quantity}</td>
                                            <td style="padding: 8px; text-align: center;">
                                                <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ
                                            </td>
                                            <td style="padding: 8px; text-align: center; color: var(--primary); font-weight: 600;">
                                                <fmt:formatNumber value="${detail.price * detail.quantity}" type="number" maxFractionDigits="0"/> đ
                                            </td>
                                            <td style="padding: 8px; text-align: center;">
                                                <button type="button" onclick="removeItem('${detail.document.id}', '${detail.document.title}')" 
                                                        style="padding: 4px 8px; background: #ef4444; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px;">
                                                    🗑 Xóa
                                                </button>
                                            </td>
                                        </tr>
                                        <c:set var="totalAmount" value="${totalAmount + (detail.price * detail.quantity)}"/>
                                        <c:set var="totalQuantity" value="${totalQuantity + detail.quantity}"/>
                                    </c:forEach>
                                    <!-- Tổng cộng -->
                                    <tr style="background: var(--background-light); border-top: 2px solid var(--primary);">
                                        <td colspan="2" style="padding: 12px 8px; font-weight: 500; color: var(--text-secondary);">
                                            TỔNG CỘNG
                                        </td>
                                        <td style="padding: 12px 8px; text-align: center;">
                                            <span style="background: var(--primary); color: white; padding: 4px 12px; border-radius: 16px; font-size: 14px; font-weight: 500;">
                                                ${totalQuantity} cuốn
                                            </span>
                                        </td>
                                        <td colspan="3" style="padding: 12px 8px; text-align: center; font-weight: 600; color: #f97316; font-size: 16px;">
                                            <fmt:formatNumber value="${totalAmount}" type="number" maxFractionDigits="0"/> đ
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Thanh toán & Lưu hóa đơn -->
        <c:if test="${not empty sessionScope.importingDetails}">
            <div class="card" style="margin-bottom: 24px;">
                <div class="card-header">
                    <h3>💳 Thanh toán & Lưu hóa đơn</h3>
                </div>
                <div class="card-body">
                    <form id="invoiceForm" action="<c:url value='/addImportingInvoice'/>" method="post">
                        <input type="hidden" name="action" value="saveInvoice">
                        <input type="hidden" name="supplierId" value="${supplier.id}">
                        
                        <!-- Thông tin tổng quan -->
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; padding: 8px 12px; background: var(--brand-light); border-radius: 6px;">
                            <div style="font-size: 14px; font-weight: 500; color: var(--text-dark);">
                                Tổng: <span style="color: var(--brand); font-weight: 600;">${totalQuantity} cuốn</span>
                            </div>
                            <div style="font-size: 16px; font-weight: 600; color: #f97316;">
                                <fmt:formatNumber value="${totalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                            </div>
                        </div>
                        
                        <div style="display: flex; gap: 16px; align-items: flex-end;">
                            <!-- Hình thức thanh toán -->
                            <div style="flex: 1;">
                                <label for="typePay" style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">
                                    Hình thức thanh toán
                                </label>
                                <select id="typePay" name="typePay" required onchange="toggleBankDetails(this.value)"
                                        style="width: 100%; padding: 6px 10px; border: 1px solid var(--border); border-radius: 6px; font-size: 14px; height: 36px;">
                                    <option value="Tiền mặt">Tiền mặt</option>
                                    <option value="Chuyển khoản">Chuyển khoản</option>
                                </select>
                            </div>
                            
                            <!-- Tên ngân hàng -->
                            <div id="bankDetails" style="display: none; flex: 1;">
                                <label for="bank" style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">
                                    Tên ngân hàng <span style="color: var(--danger);">*</span>
                                </label>
                                <input type="text" id="bank" name="bank" 
                                       placeholder="Nhập tên ngân hàng"
                                       style="width: 100%; padding: 6px 10px; border: 1px solid var(--border); border-radius: 6px; font-size: 14px; height: 36px;">
                            </div>
                        
                        <div style="display: flex; gap: 12px;">
                            <button type="submit" id="btnSaveInvoice" class="btn btn-primary" 
                                    style="flex: 1; padding: 10px 20px; font-size: 14px; font-weight: 600; background: var(--brand); border: none; border-radius: 6px; color: white; cursor: pointer;">
                                💾 Lưu hóa đơn
                            </button>
                            <button type="button" class="btn btn-outline" onclick="cancelImport()" id="btnCancel" 
                                    style="padding: 10px 20px; font-size: 14px; border: 1px solid var(--border); background: white; border-radius: 6px; cursor: pointer;">
                                ❌ Hủy
                            </button>
                        </div>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

    </div> <!-- Đóng container chính -->

    <script>
        // AJAX search for documents
        function searchDocuments() {
            const searchTerm = document.getElementById('documentSearchInput').value.trim();
            if (!searchTerm) {
                alert('Vui lòng nhập từ khóa tìm kiếm');
                return;
            }

            // Show loading
            const btn = event.target;
            btn.disabled = true;
            btn.innerHTML = '⏳ Đang tìm...';

            // Call servlet to get JSON response
            fetch('${pageContext.request.contextPath}/addImportingInvoice?action=searchDocumentAjax&supplierId=${supplier.id}&documentName=' + encodeURIComponent(searchTerm))
                .then(response => response.json())
                .then(documents => {
                    populateDocumentDropdown(documents);
                })
                .catch(error => {
                    console.error('Error:', error);
                    // Fallback to simple redirect if AJAX fails
                    window.location.href = '${pageContext.request.contextPath}/addImportingInvoice?action=searchDocument&supplierId=${supplier.id}&documentName=' + encodeURIComponent(searchTerm);
                })
                .finally(() => {
                    btn.disabled = false;
                    btn.innerHTML = '🔍 Tìm kiếm';
                });
        }

        // Populate dropdown with documents
        function populateDocumentDropdown(documents) {
            const dropdown = document.getElementById('documentSelect');
            dropdown.innerHTML = '<option value="">-- Chọn tài liệu để nhập --</option>';
            
            if (documents && documents.length > 0) {
                documents.forEach(doc => {
                    const option = document.createElement('option');
                    option.value = doc.id;
                    option.setAttribute('data-name', doc.title);
                    option.setAttribute('data-author', doc.author);
                    option.setAttribute('data-category', doc.category);
                    option.textContent = doc.title + ' (' + doc.author + ')';
                    dropdown.appendChild(option);
                });
                
                document.getElementById('documentCount').textContent = documents.length;
                document.getElementById('documentSelectContainer').style.display = 'block';
            } else {
                document.getElementById('documentSelectContainer').style.display = 'none';
                alert('Không tìm thấy tài liệu nào');
            }
        }

        // Select document from dropdown and show popup (but check for existing item first)
        function selectDocumentFromDropdown() {
            const dropdown = document.getElementById('documentSelect');
            const selectedOption = dropdown.options[dropdown.selectedIndex];
            if (!selectedOption || !selectedOption.value) return;

            const documentId = selectedOption.value;
            const documentName = selectedOption.getAttribute('data-name');
            const documentAuthor = selectedOption.getAttribute('data-author') || '';

            // Pre-check whether document already exists in the list and show confirm BEFORE modal
            preCheckAndShow(documentId, documentName, documentAuthor);
        }

        // Select document from search results table - check first then maybe show popup
        function selectDocument(documentId, documentTitle) {
            preCheckAndShow(documentId, documentTitle, '');
        }

        // Show popup for entering quantity and price
        // initialQuantity / initialPrice: optional values to prefill (used when updating existing item)
        // isUpdate: boolean flag to indicate this modal is for updating an existing item
        function showQuantityPricePopup(docId, docName, docAuthor, initialQuantity, initialPrice, isUpdate) {
            const popup = `
                <div id="quantityPriceModal" style="
                    position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
                    background: rgba(0,0,0,0.5); z-index: 1000; display: flex; 
                    align-items: center; justify-content: center;">
                    <div style="
                        background: white; padding: 24px; border-radius: 8px; 
                        width: 90%; max-width: 500px; box-shadow: 0 4px 20px rgba(0,0,0,0.15);">
                        <h3 style="margin: 0 0 16px 0; color: var(--brand);">Nhập thông tin tài liệu</h3>
                        
                        <div style="margin-bottom: 16px; padding: 12px; background: #f8fafc; border-radius: 6px;">
                            <p style="margin: 0; font-weight: 600;">\${docName}</p>
                            <p style="margin: 4px 0 0 0; font-size: 14px; color: var(--text-medium);">
                                Tác giả: \${docAuthor}
                            </p>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px;">
                            <div>
                                <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">
                                    Số lượng <span style="color: var(--danger);">*</span>
                                </label>
                                <input type="text" id="quantityInput" value="1" maxlength="6"
                                       placeholder="Nhập số lượng"
                                       oninput="clearError('quantity'); validateIntegerInput(this); preventDecimal(this)"
                                       onkeypress="return isNumberKey(event)"
                                       onpaste="handlePaste(event, this)"
                                       style="width: 100%; padding: 8px 12px; border: 1px solid var(--border); border-radius: 6px;">
                                <div id="quantityError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></div>
                            </div>
                            <div>
                                <label style="display: block; font-size: 12px; font-weight: 500; color: var(--text-medium); margin-bottom: 4px;">
                                    Đơn giá (VNĐ) <span style="color: var(--danger);">*</span>
                                </label>
                                <input type="text" id="priceInput" value="10000" maxlength="10"
                                       placeholder="Nhập đơn giá"
                                       oninput="clearError('price'); validateIntegerInput(this); preventDecimal(this)"
                                       onkeypress="return isNumberKey(event)"
                                       onpaste="handlePaste(event, this)"
                                       style="width: 100%; padding: 8px 12px; border: 1px solid var(--border); border-radius: 6px;">
                                <div id="priceError" style="color: #ef4444; font-size: 12px; margin-top: 4px; display: none;"></div>
                            </div>
                        </div>

                            <div style="display: flex; gap: 12px; justify-content: flex-end;">
                            <button type="button" onclick="closeQuantityPriceModal()" 
                                    style="padding: 8px 16px; border: 1px solid var(--border); background: white; border-radius: 6px;">
                                Hủy
                            </button>
                            <button type="button" onclick="addDocumentToList('\${docId}', '\${docName}', '\${docAuthor}', ${isUpdate ? 'true' : 'false'})" 
                                    style="padding: 8px 16px; background: var(--brand); color: white; border: none; border-radius: 6px;">
                                Thêm vào danh sách
                            </button>
                        </div>
                    </div>
                </div>
            `;
            
            document.body.insertAdjacentHTML('beforeend', popup);
            // Prefill initial values if provided
            if (initialQuantity) {
                const q = document.getElementById('quantityInput');
                if (q) q.value = initialQuantity;
            }
            if (initialPrice) {
                const p = document.getElementById('priceInput');
                if (p) p.value = initialPrice;
            }
            document.getElementById('quantityInput').focus();
        }

        // Validate integer input - show error for decimals but allow typing
        function validateIntegerInput(input) {
            let value = input.value;
            const errorElement = input.nextElementSibling;
            
            // Clear previous error state
            if (errorElement && errorElement.classList.contains('error-message')) {
                errorElement.style.display = 'none';
                input.style.borderColor = 'var(--border)';
            }
            
            // Show error if decimal point is detected
            if (value.includes('.') || value.includes(',')) {
                if (errorElement && errorElement.classList.contains('error-message')) {
                    errorElement.textContent = 'Chỉ được nhập số nguyên, không được có dấu thập phân';
                    errorElement.style.display = 'block';
                    input.style.borderColor = '#ef4444';
                }
            }
            
            // Show error if not a positive integer
            const numValue = parseInt(value);
            if (value && value.trim() !== '' && (isNaN(numValue) || numValue < 1)) {
                if (errorElement && errorElement.classList.contains('error-message')) {
                    errorElement.textContent = 'Giá trị phải là số nguyên lớn hơn 0';
                    errorElement.style.display = 'block';
                    input.style.borderColor = '#ef4444';
                }
            }
        }
        
        // Prevent decimal input by removing invalid characters
        function preventDecimal(input) {
            let value = input.value;
            // Remove any non-digit characters except at the start (for negative, but we don't want that either)
            let cleaned = value.replace(/[^\d]/g, '');
            
            if (cleaned !== value) {
                input.value = cleaned;
                // Trigger validation after cleaning
                validateIntegerInput(input);
            }
        }
        
        // Handle paste events to prevent decimal numbers
        function handlePaste(event, input) {
            event.preventDefault();
            
            // Get pasted data
            let paste = (event.clipboardData || window.clipboardData).getData('text');
            
            // Only allow digits
            let cleaned = paste.replace(/[^\d]/g, '');
            
            if (cleaned) {
                input.value = cleaned;
                validateIntegerInput(input);
            }
        }

        // Allow typing but will be validated later
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            
            // Allow: backspace, delete, tab, escape, enter
            if ([8, 9, 27, 13, 46].indexOf(charCode) !== -1 ||
                // Allow: Ctrl+A, Ctrl+C, Ctrl+V, Ctrl+X
                (charCode === 65 && evt.ctrlKey === true) ||
                (charCode === 67 && evt.ctrlKey === true) ||
                (charCode === 86 && evt.ctrlKey === true) ||
                (charCode === 88 && evt.ctrlKey === true) ||
                // Allow: home, end, left, right
                (charCode >= 35 && charCode <= 39)) {
                return true;
            }
            
            // BLOCK decimal point completely
            if (charCode === 46 || charCode === 190 || charCode === 188 || charCode === 110) {
                return false;
            }
            
            // Allow numbers only
            if (charCode >= 48 && charCode <= 57) {
                return true;
            }
            
            // Block everything else
            return false;
        }

        // Clear error when user starts typing
        function clearError(fieldType) {
            const errorElement = document.getElementById(fieldType + 'Error');
            const inputElement = document.getElementById(fieldType + 'Input');
            
            if (errorElement) {
                errorElement.style.display = 'none';
            }
            if (inputElement) {
                inputElement.style.borderColor = 'var(--border)';
            }
        }

        // Add document to importing list
        // isUpdate: boolean (if true, call updateExistingDocument; otherwise add new)
        function addDocumentToList(docId, docName, docAuthor, isUpdate) {
            console.log('DEBUG addDocumentToList - docId:', docId, 'isUpdate:', isUpdate);
            
            // Clear previous errors
            const quantityError = document.getElementById('quantityError');
            const priceError = document.getElementById('priceError');
            const quantityInput = document.getElementById('quantityInput');
            const priceInput = document.getElementById('priceInput');
            
            quantityError.style.display = 'none';
            priceError.style.display = 'none';
            quantityInput.style.borderColor = 'var(--border)';
            priceInput.style.borderColor = 'var(--border)';
            
            const quantity = parseInt(quantityInput.value);
            const price = parseInt(priceInput.value);
            
            let hasError = false;
            
            // Validate quantity - must be positive integer, no decimals
            if (!quantity || quantity < 1 || !Number.isInteger(Number(quantityInput.value)) || 
                quantityInput.value.includes('.') || quantityInput.value.includes(',')) {
                quantityError.textContent = 'Số lượng phải là số nguyên lớn hơn 0, không được có dấu thập phân';
                quantityError.style.display = 'block';
                quantityInput.style.borderColor = '#ef4444';
                hasError = true;
            }
            
            // Validate price - must be positive integer, no decimals
            if (!price || price < 1 || !Number.isInteger(Number(priceInput.value)) || 
                priceInput.value.includes('.') || priceInput.value.includes(',')) {
                priceError.textContent = 'Đơn giá phải là số nguyên lớn hơn 0, không được có dấu thập phân';
                priceError.style.display = 'block';
                priceInput.style.borderColor = '#ef4444';
                hasError = true;
            }
            
            // If validation fails, focus on first error field and stay in popup
            if (hasError) {
                if (quantityError.style.display === 'block') {
                    quantityInput.focus();
                } else if (priceError.style.display === 'block') {
                    priceInput.focus();
                }
                return; // Don't close popup
            }

            // If this modal was opened to update an existing item, call update; otherwise add new
            if (isUpdate) {
                console.log('DEBUG: Calling updateExistingDocument for docId:', docId);
                updateExistingDocument(docId, quantity, price);
            } else {
                console.log('DEBUG: Calling addNewDocument for docId:', docId);
                addNewDocument(docId, quantity, price);
            }
        }
        
        // Pre-check whether a document exists in current list; if exists, ask confirmation
        function preCheckAndShow(docId, docName, docAuthor) {
            console.log('DEBUG preCheckAndShow - docId:', docId, 'docName:', docName);
            
            const tableBody = document.querySelector('tbody');
            console.log('DEBUG: tableBody found:', !!tableBody);
            
            let documentExists = false;
            let existingRow = null;
            let existingQuantity = null;
            let existingPrice = null;

            if (tableBody) {
                // First check: look for all rows
                const allRows = tableBody.querySelectorAll('tr');
                console.log('DEBUG: Total rows found:', allRows.length);
                
                // Second check: look for rows with data-document-id
                const existingRows = tableBody.querySelectorAll('tr[data-document-id]');
                console.log('DEBUG: Rows with data-document-id:', existingRows.length);
                
                // Third check: manually inspect first few rows
                allRows.forEach((row, index) => {
                    const documentIdAttr = row.getAttribute('data-document-id');
                    console.log('DEBUG: Row', index, 'data-document-id:', documentIdAttr);
                    console.log('DEBUG: Row', index, 'innerHTML preview:', row.innerHTML.substring(0, 100));
                });
                
                existingRows.forEach((row, index) => {
                    const rowDocumentId = row.getAttribute('data-document-id');
                    console.log('DEBUG: Row', index, 'has docId:', rowDocumentId, 'comparing with:', docId);
                    
                    // Convert both to string for comparison
                    if (rowDocumentId && String(rowDocumentId) === String(docId)) {
                        console.log('DEBUG: MATCH FOUND! Document already exists in list');
                        documentExists = true;
                        existingRow = row;
                        
                        // Get existing values from the row
                        const cells = row.querySelectorAll('td');
                        if (cells.length >= 6) {
                            const qtyCell = cells[2];
                            const priceCell = cells[3];
                            if (qtyCell) existingQuantity = qtyCell.textContent.trim();
                            if (priceCell) {
                                // Remove non-digit characters
                                existingPrice = priceCell.textContent.replace(/[^\d]/g, '').trim();
                            }
                            console.log('DEBUG: Existing values - quantity:', existingQuantity, 'price:', existingPrice);
                        }
                    }
                });
            }
            
            console.log('DEBUG: documentExists:', documentExists);

            if (documentExists) {
                // Ask user before showing modal
                if (confirm(`Tài liệu "${docName}" đã có trong danh sách.\n\nBạn có muốn cập nhật số lượng và đơn giá không?\n\n- Chọn "OK" để cập nhật\n- Chọn "Hủy" để không làm gì`)) {
                    console.log('DEBUG: User chose to UPDATE');
                    // Show modal prefilled with existing values and mark as update
                    showQuantityPricePopup(docId, docName, docAuthor, existingQuantity || 1, existingPrice || 10000, true);
                } else {
                    console.log('DEBUG: User cancelled update');
                    // do nothing
                    return;
                }
            } else {
                console.log('DEBUG: Document not found, adding NEW');
                // Not existing -> show modal for adding new
                showQuantityPricePopup(docId, docName, docAuthor, 1, 10000, false);
            }
        }
        
        // Add new document to list
        function addNewDocument(docId, quantity, price) {
            closeQuantityPriceModal();
            
            // Show loading
            const loadingDiv = document.createElement('div');
            loadingDiv.innerHTML = `
                <div style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
                            background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); z-index: 2000;">
                    <div style="text-align: center;">
                        <div style="margin-bottom: 12px;">⏳</div>
                        <div>Đang thêm tài liệu...</div>
                    </div>
                </div>
            `;
            document.body.appendChild(loadingDiv);

            // Send AJAX request to add new document
            fetch('${pageContext.request.contextPath}/addImportingInvoice', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=addItem&documentId=' + docId + '&quantity=' + quantity + '&price=' + price + '&supplierId=${supplier.id}'
            })
            .then(response => response.text())
            .then(html => {
                document.body.removeChild(loadingDiv);
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                document.body.removeChild(loadingDiv);
                alert('Có lỗi xảy ra khi thêm tài liệu');
            });
        }
        
        // Update existing document in the list
        function updateExistingDocument(docId, quantity, price) {
            console.log('DEBUG updateExistingDocument - docId:', docId, 'quantity:', quantity, 'price:', price);
            
            closeQuantityPriceModal();
            
            // Show loading
            const loadingDiv = document.createElement('div');
            loadingDiv.innerHTML = `
                <div style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
                            background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); z-index: 2000;">
                    <div style="text-align: center;">
                        <div style="margin-bottom: 12px;">🔄</div>
                        <div>Đang cập nhật tài liệu...</div>
                    </div>
                </div>
            `;
            document.body.appendChild(loadingDiv);

            const requestBody = 'action=updateItem&documentId=' + docId + '&quantity=' + quantity + '&price=' + price + '&supplierId=${supplier.id}';
            console.log('DEBUG: Sending request body:', requestBody);

            // Send AJAX request to update
            fetch('${pageContext.request.contextPath}/addImportingInvoice', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: requestBody
            })
            .then(response => {
                console.log('DEBUG: Response status:', response.status);
                return response.text();
            })
            .then(html => {
                console.log('DEBUG: Update response received, reloading page');
                document.body.removeChild(loadingDiv);
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                document.body.removeChild(loadingDiv);
                alert('Có lỗi xảy ra khi cập nhật tài liệu');
            });
        }

        // Close popup
        function closeQuantityPriceModal() {
            const modal = document.getElementById('quantityPriceModal');
            if (modal) {
                modal.remove();
            }
            // Reset dropdown selection
            const dropdown = document.getElementById('documentSelect');
            if (dropdown) {
                dropdown.selectedIndex = 0;
            }
        }

        function toggleBankDetails(paymentType) {
            const bankDetails = document.getElementById('bankDetails');
            const bankInput = document.getElementById('bank');
            
            if (paymentType === 'Chuyển khoản') {
                bankDetails.style.display = 'block';
                bankInput.required = true;
            } else {
                bankDetails.style.display = 'none';
                bankInput.required = false;
                bankInput.value = '';
            }
        }

        // Validate and submit invoice
        document.getElementById('invoiceForm').addEventListener('submit', function(e) {
            const paymentType = document.getElementById('typePay').value;
            const bankInput = document.getElementById('bank');
            
            if (paymentType === 'Chuyển khoản' && (!bankInput.value || bankInput.value.trim() === '')) {
                e.preventDefault();
                alert('Vui lòng nhập tên ngân hàng khi chọn hình thức chuyển khoản');
                bankInput.focus();
                return false;
            }
            
            // Show loading
            const submitBtn = document.getElementById('btnSaveInvoice');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '⏳ Đang lưu...';
            
            return true;
        });

        function removeItem(documentId, documentTitle) {
            console.log('DEBUG removeItem - documentId:', documentId, 'title:', documentTitle);
            
            if (confirm(`Bạn có chắc chắn muốn xóa tài liệu "${documentTitle}" khỏi danh sách nhập?`)) {
                // Show loading
                const loadingDiv = document.createElement('div');
                loadingDiv.innerHTML = `
                    <div style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
                                background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); z-index: 2000;">
                        <div style="text-align: center;">
                            <div style="margin-bottom: 12px;">🗑️</div>
                            <div>Đang xóa tài liệu...</div>
                        </div>
                    </div>
                `;
                document.body.appendChild(loadingDiv);

                // Send AJAX request to remove item
                fetch('${pageContext.request.contextPath}/addImportingInvoice', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=removeItem&documentId=' + documentId + '&supplierId=${supplier.id}'
                })
                .then(response => response.text())
                .then(html => {
                    document.body.removeChild(loadingDiv);
                    window.location.reload();
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.body.removeChild(loadingDiv);
                    alert('Có lỗi xảy ra khi xóa tài liệu');
                });
            }
        }

        function cancelImport() {
            if (confirm('Bạn có chắc chắn muốn hủy nhập? Tất cả dữ liệu sẽ bị mất.')) {
                window.location.href = '${pageContext.request.contextPath}/searchSupplier';
            }
        }
    </script>
</body>
</html>