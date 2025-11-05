<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Chi tiết tài liệu - LibMan</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css" />
  <style>
    .detail-grid { display:grid; grid-template-columns: 1fr 1fr; gap:18px; }
    @media (max-width:800px){ .detail-grid { grid-template-columns: 1fr; } }
    .box { background:white; padding:14px; border-radius:8px; border:1px solid #eee; }
    .field-label{ font-size:12px; color:#888; }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/jsp/common/header.jsp" />

  <div class="container main-content" style="padding-top:24px;">
    <c:choose>
      <c:when test="${not empty document}">
        <!-- Document Header -->
        <div class="card">
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="menu-icon" style="background: var(--brand); width: 40px; height: 40px; font-size: 18px;">📖</div>
                    <div>
                        <h1 style="margin: 0; color: var(--brand); font-size: 20px;">Chi tiết tài liệu</h1>
                        <p style="margin: 2px 0 0 0; color: var(--text-medium); font-size: 13px;">Thông tin chi tiết về tài liệu</p>
                    </div>
                </div>
                <a href="javascript:history.back()" class="btn btn-outline" style="padding: 6px 12px; font-size: 14px;">← Quay lại</a>
            </div>
        </div>

        <div class="detail-grid" style="gap:24px;">
          <div class="box">
            <h3 class="text-[#2b7a78]" style="margin-top:0;color:#2b7a78;margin-bottom:16px;">Thông tin cơ bản</h3>
            <div style="display:flex;flex-direction:column;gap:12px;">
              <div>
                <div class="field-label">Mã tài liệu</div>
                <div style="font-weight:600;">${fn:escapeXml(document.id)}</div>
              </div>
              <div>
                <div class="field-label">Tên tài liệu</div>
                <div style="font-weight:600;">${fn:escapeXml(document.title)}</div>
              </div>
              <div>
                <div class="field-label">Tác giả</div>
                <div style="font-weight:600;">${fn:escapeXml(document.author)}</div>
              </div>
              <div>
                <div class="field-label">Thể loại</div>
                <div style="font-weight:600;">${fn:escapeXml(document.category)}</div>
              </div>
              <div>
                <div class="field-label">Năm xuất bản</div>
                <div style="font-weight:600;">${document.yearPublic}</div>
              </div>
            </div>

            <div style="margin-top:20px;">
              <div class="field-label">Mô tả</div>
              <div style="margin-top:8px;">${fn:escapeXml(document.description)}</div>
            </div>
          </div>

          <div class="box">
            <h3 style="margin-top:0;color:#2b7a78;margin-bottom:16px;">Nội dung tài liệu</h3>
            <c:if test="${not empty document.content}">
              <div style="border:1px solid #f1f1f1;padding:12px;border-radius:6px;height:60vh;overflow:auto;background:#fbfbfb;">
                <pre style="white-space:pre-wrap;word-break:break-word;margin:0;">${fn:escapeXml(document.content)}</pre>
              </div>
            </c:if>
            <c:if test="${empty document.content}">
              <div style="border:1px dashed #eee;padding:32px;border-radius:6px;text-align:center;background:#fafafa;">
                <p class="text-muted">Chưa có nội dung</p>
              </div>
            </c:if>
          </div>
        </div>

      </c:when>
      <c:otherwise>
        <div class="card mt-3">
          <h3>Không tìm thấy tài liệu</h3>
          <p class="text-muted">Không có thông tin tài liệu để hiển thị.</p>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>
