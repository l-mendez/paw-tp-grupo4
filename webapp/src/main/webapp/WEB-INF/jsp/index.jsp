<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<html>
<head>
    <title>BioStack</title>
    <link rel="stylesheet" href="<c:url value='/css/components.css' />" />
</head>
<body>

    <paw:text text="BioStack" type="heading" />
    <paw:text text="Plataforma de protocolos de biohacking" type="subtitle" />

    <c:choose>
        <c:when test="${not empty currentUser}">
            <paw:text text="Hola, ${currentUser.username}! (${currentUser.email})" type="body" />
            <a href="<c:url value='/logout' />">
                <paw:button text="Salir" variant="outline" size="sm" />
            </a>
        </c:when>
        <c:otherwise>
            <paw:text text="Ingresa para comenzar a explorar protocolos." type="body" />
            <a href="<c:url value='/login' />">
                <paw:button text="Ingresar" variant="primary" />
            </a>
        </c:otherwise>
    </c:choose>

</body>
</html>
