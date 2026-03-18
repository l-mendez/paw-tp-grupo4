<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="cssClass" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="cardClass" value="${not empty cssClass ? cssClass : ''}" />

<div class="card ${cardClass}">
    <c:if test="${not empty title}">
        <div class="card-header">
            <paw:text text="${title}" type="title" />
        </div>
    </c:if>
    <div class="card-body">
        <jsp:doBody />
    </div>
</div>
