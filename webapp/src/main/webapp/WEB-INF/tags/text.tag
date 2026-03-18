<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="type" required="false" %>
<%@ attribute name="cssClass" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="textType" value="${not empty type ? type : 'body'}" />
<c:set var="extraClass" value="${not empty cssClass ? cssClass : ''}" />

<c:choose>
    <c:when test="${textType == 'heading'}">
        <h1 class="text-heading ${extraClass}"><c:out value="${text}" /></h1>
    </c:when>
    <c:when test="${textType == 'title'}">
        <h2 class="text-title ${extraClass}"><c:out value="${text}" /></h2>
    </c:when>
    <c:when test="${textType == 'subtitle'}">
        <h3 class="text-subtitle ${extraClass}"><c:out value="${text}" /></h3>
    </c:when>
    <c:when test="${textType == 'label'}">
        <label class="text-label ${extraClass}"><c:out value="${text}" /></label>
    </c:when>
    <c:when test="${textType == 'caption'}">
        <span class="text-caption ${extraClass}"><c:out value="${text}" /></span>
    </c:when>
    <c:otherwise>
        <p class="text-body ${extraClass}"><c:out value="${text}" /></p>
    </c:otherwise>
</c:choose>
