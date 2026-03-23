<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="value" required="true" type="java.lang.Double" %>
<%@ attribute name="count" required="false" type="java.lang.Integer" %>
<%@ attribute name="cssClass" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="extraClass" value="${not empty cssClass ? cssClass : ''}" />

<span class="rating ${extraClass}">
    <c:forEach var="i" begin="1" end="5">
        <c:choose>
            <c:when test="${value >= i}">
                <span class="rating-star rating-star-filled">&#9733;</span>
            </c:when>
            <c:when test="${value >= i - 0.5}">
                <span class="rating-star rating-star-half">&#9733;</span>
            </c:when>
            <c:otherwise>
                <span class="rating-star">&#9734;</span>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <span class="rating-value"><fmt:formatNumber value="${value}" maxFractionDigits="1" /></span>
    <c:if test="${count != null && count > 0}">
        <span class="rating-count">(${count})</span>
    </c:if>
</span>
