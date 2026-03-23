<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<html>
<head>
    <title>BioStack - Ingresar</title>
    <link rel="stylesheet" href="<c:url value='/css/components.css' />" />
</head>
<body>

    <paw:text text="Ingresar" type="heading" />
    <paw:text text="Ingresa tu email para continuar." type="body" />

    <c:if test="${not empty error}">
        <paw:text text="${error}" type="body" cssClass="form-error-text" />
    </c:if>

    <form action="<c:url value='/login' />" method="post">
        <paw:input name="email" label="Email" type="email" placeholder="tu@email.com" required="${true}" />
        <br/>
        <paw:button text="Ingresar" variant="primary" type="submit" />
    </form>

</body>
</html>
