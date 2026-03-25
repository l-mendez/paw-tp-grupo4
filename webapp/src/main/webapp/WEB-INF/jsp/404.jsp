<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<html>
<head>
    <title>No encontrado - BioStack</title>
    <link rel="stylesheet" href="<c:url value='/css/components.css' />" />
</head>
<body>
<div class="not-found-page">
    <paw:text text="Página no encontrada" type="heading" />
    <paw:text text="El recurso solicitado no existe." type="body" />
    <a href="<c:url value='/protocols' />" class="btn btn-primary">Volver a protocolos</a>
</div>
</body>
</html>
