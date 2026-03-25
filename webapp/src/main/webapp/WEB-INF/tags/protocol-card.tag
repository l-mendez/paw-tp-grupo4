<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="description" required="false" %>
<%@ attribute name="status" required="true" %>
<%@ attribute name="goalLabel" required="true" %>
<%@ attribute name="avgRating" required="true" type="java.lang.Double" %>
<%@ attribute name="reviewCount" required="true" type="java.lang.Integer" %>
<%@ attribute name="enrollmentCount" required="true" type="java.lang.Integer" %>
<%@ attribute name="durationDays" required="false" type="java.lang.Integer" %>
<%@ attribute name="tags" required="false" type="java.util.List" %>
<%@ attribute name="creatorDisplayName" required="true" %>
<%@ attribute name="cssClass" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="extraClass" value="${not empty cssClass ? cssClass : ''}" />

<c:choose>
    <c:when test="${status == 'draft'}"><c:set var="statusLabel" value="Borrador" /></c:when>
    <c:when test="${status == 'recruiting'}"><c:set var="statusLabel" value="Reclutando" /></c:when>
    <c:when test="${status == 'active'}"><c:set var="statusLabel" value="Activo" /></c:when>
    <c:when test="${status == 'completed'}"><c:set var="statusLabel" value="Completado" /></c:when>
    <c:otherwise><c:set var="statusLabel" value="${status}" /></c:otherwise>
</c:choose>

<div class="protocol-card-link ${extraClass}">
    <div class="card">
        <div class="card-body">
            <div class="protocol-card-header">
                <h3 class="protocol-card-title">
                    <c:out value="${title}" />
                </h3>
                <span class="protocol-card-status">
                    <paw:badge text="${statusLabel}" cssClass="badge-status-${status}" />
                </span>
            </div>

            <paw:badge text="${goalLabel}" variant="primary" />

            <c:if test="${not empty description}">
                <p class="protocol-description">
                    <c:out value="${description}" />
                </p>
            </c:if>

            <div class="protocol-meta">
                <span class="protocol-meta-item">
                    <paw:rating value="${avgRating}" count="${reviewCount}" />
                </span>
                <span class="protocol-meta-item">
                    ${enrollmentCount} participante${enrollmentCount != 1 ? 's' : ''}
                </span>
                <c:if test="${durationDays != null}">
                    <span class="protocol-meta-item">
                        ${durationDays} días
                    </span>
                </c:if>
            </div>

            <c:if test="${not empty tags}">
                <div class="protocol-tags">
                    <c:forEach var="tag" items="${tags}">
                        <paw:badge text="${tag}" variant="outline" />
                    </c:forEach>
                </div>
            </c:if>

            <div class="protocol-creator">
                por <strong><c:out value="${creatorDisplayName}" /></strong>
            </div>
        </div>
    </div>
</div>
