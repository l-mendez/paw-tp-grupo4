<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="variant" required="false" %>
<%@ attribute name="cssClass" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="badgeVariant" value="${not empty variant ? variant : 'default'}" />
<c:set var="extraClass" value="${not empty cssClass ? cssClass : ''}" />

<span class="badge badge-${badgeVariant} ${extraClass}">
    <c:out value="${text}" />
</span>
