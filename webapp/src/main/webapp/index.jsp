<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<html>
<head>
    <title>PAW - Home</title>
    <link rel="stylesheet" href="<c:url value='/css/components.css' />" />
</head>
<body>

    <paw:text text="${heading}" type="heading" />
    <paw:text text="${subtitle}" type="subtitle" />
    <paw:text text="${bodyText}" type="body" />

    <paw:button text="${buttonText}" size="${buttonSize}" />
    <paw:button text="Disabled Button" size="sm" disabled="${true}" />

    <paw:toast title="Tostada!" text="${toastMessage}" />

</body>
</html>
