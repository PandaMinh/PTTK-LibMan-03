<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Ùc Gi£ - Library Management</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
</head>
<body>
    <div class="container">
        <h1>Chào mëng, Ùc gi£</h1>

        <div class="card">
            <h3>Thông tin ng°Ýi dùng</h3>
            <div class="detail-grid">
                <div class="detail-item">
                    <strong>HÍ tên:</strong>
                    <span>${user.name}</span>
                </div>
                <div class="detail-item">
                    <strong>Email:</strong>
                    <span>${user.email}</span>
                </div>
                <div class="detail-item">
                    <strong>iÇn tho¡i:</strong>
                    <span>${user.tel}</span>
                </div>
                <div class="detail-item">
                    <strong>Ëa chÉ:</strong>
                    <span>${user.address}</span>
                </div>
            </div>
        </div>

        <div class="actions">
            <ul>
                <li><a href="<c:url value='/searchDocument'/>">Tìm ki¿m tài liÇu</a></li>
                <li><a href="<c:url value='/login'/>">ng xu¥t</a></li>
            </ul>
        </div>

        <div class="recent">
            <h2>H°Ûng d«n sí dång</h2>
            <p>- Sí dång chéc nng <strong>Tìm ki¿m tài liÇu</strong> Ã tra céu sách, t¡p chí trong th° viÇn.</p>
            <p>- Xem chi ti¿t tài liÇu Ã bi¿t thông tin vÁ tác gi£, nhà xu¥t b£n, nm xu¥t b£n.</p>
            <p>- Liên hÇ vÛi thç th° n¿u c§n m°ãn tài liÇu.</p>
        </div>
    </div>
</body>
</html>
