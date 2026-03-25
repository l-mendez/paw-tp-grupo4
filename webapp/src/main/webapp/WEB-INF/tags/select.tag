<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="false" %>
<%@ attribute name="cssClass" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="extraClass" value="${not empty cssClass ? cssClass : ''}" />

<div class="form-group">
    <c:if test="${not empty label}">
        <paw:text text="${label}" type="label" />
    </c:if>
    <select name="${name}" class="form-select ${extraClass}">
        <jsp:doBody />
    </select>
</div>
