<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:choose>
    <c:when test="${protocol.status == 'draft'}"><c:set var="statusLabel" value="Borrador" /></c:when>
    <c:when test="${protocol.status == 'recruiting'}"><c:set var="statusLabel" value="Reclutando" /></c:when>
    <c:when test="${protocol.status == 'active'}"><c:set var="statusLabel" value="Activo" /></c:when>
    <c:when test="${protocol.status == 'completed'}"><c:set var="statusLabel" value="Completado" /></c:when>
    <c:otherwise><c:set var="statusLabel" value="${protocol.status}" /></c:otherwise>
</c:choose>

<html>
<head>
    <title><c:out value="${protocol.title}" /> - BioStack</title>
    <link rel="stylesheet" href="<c:url value='/css/components.css' />" />
    <link rel="stylesheet" href="<c:url value='/css/protocols.css' />" />
</head>
<body>
<div class="protocol-detail-page">

    <a href="<c:url value='/protocols' />" class="protocol-detail-back">&larr; Volver a protocolos</a>

    <%-- Header --%>
    <div class="protocol-detail-header">
        <div class="protocol-detail-header-top">
            <paw:text text="${protocol.title}" type="heading" />
            <paw:badge text="${statusLabel}" cssClass="badge-status-${protocol.status}" />
        </div>

        <div class="protocol-detail-meta">
            <span class="protocol-detail-meta-item">
                <span class="protocol-detail-meta-label">Objetivo:</span>
                <span class="protocol-detail-meta-value"><c:out value="${protocol.goalLabel}" /></span>
            </span>
            <c:if test="${not empty protocol.goalCategoryName}">
                <span class="protocol-detail-meta-item">
                    <span class="protocol-detail-meta-label">Categoría:</span>
                    <span class="protocol-detail-meta-value"><c:out value="${protocol.goalCategoryName}" /></span>
                </span>
            </c:if>
        </div>

        <c:if test="${not empty protocol.tags}">
            <div class="protocol-detail-tags">
                <c:forEach var="tag" items="${protocol.tags}">
                    <paw:badge text="${tag}" variant="outline" />
                </c:forEach>
            </div>
        </c:if>

        <div class="protocol-detail-author">
            por <strong><c:out value="${protocol.creatorDisplayName}" /></strong>
        </div>
    </div>

    <%-- Action buttons --%>
    <div class="protocol-detail-actions">
        <paw:button text="Anotarse" variant="primary" />
        <paw:button text="Guardar" variant="outline" />
    </div>

    <%-- Stats --%>
    <div class="protocol-detail-stats">
        <div class="protocol-detail-stat">
            <paw:rating value="${protocol.avgRating}" count="${protocol.reviewCount}" />
        </div>
        <div class="protocol-detail-stat">
            <span class="protocol-detail-stat-value">${protocol.enrollmentCount}</span>
            <span class="protocol-detail-stat-label">participante${protocol.enrollmentCount != 1 ? 's' : ''}</span>
        </div>
        <div class="protocol-detail-stat">
            <span class="protocol-detail-stat-value">${protocol.favoriteCount}</span>
            <span class="protocol-detail-stat-label">favorito${protocol.favoriteCount != 1 ? 's' : ''}</span>
        </div>
        <c:if test="${protocol.durationDays != null}">
            <div class="protocol-detail-stat">
                <span class="protocol-detail-stat-value">${protocol.durationDays}</span>
                <span class="protocol-detail-stat-label">días</span>
            </div>
        </c:if>
    </div>

    <%-- Description --%>
    <c:if test="${not empty protocol.description}">
        <paw:card title="Descripción">
            <p class="text-body"><c:out value="${protocol.description}" /></p>
        </paw:card>
    </c:if>

    <%-- Interventions --%>
    <paw:card title="Intervenciones">
        <c:choose>
            <c:when test="${not empty interventions}">
                <div class="intervention-list">
                    <c:forEach var="intv" items="${interventions}">
                        <div class="intervention-item">
                            <paw:text text="${intv.interventionLabel}" type="subtitle" />
                            <div class="intervention-item-details">
                                <c:if test="${intv.dosage != null}">
                                    <span class="intervention-detail">
                                        <strong>Dosis:</strong>
                                        <fmt:formatNumber value="${intv.dosage}" maxFractionDigits="2" />
                                        <c:if test="${not empty intv.dosageUnit}">
                                            <c:out value="${intv.dosageUnit}" />
                                        </c:if>
                                    </span>
                                </c:if>
                                <span class="intervention-detail">
                                    <strong>Frecuencia:</strong>
                                    <span class="intervention-detail-value"><c:out value="${intv.frequency}" /></span>
                                </span>
                                <c:if test="${not empty intv.timing}">
                                    <span class="intervention-detail">
                                        <strong>Momento:</strong>
                                        <span class="intervention-detail-value"><c:out value="${intv.timing}" /></span>
                                    </span>
                                </c:if>
                            </div>
                            <c:if test="${not empty intv.instructions}">
                                <p class="intervention-instructions"><c:out value="${intv.instructions}" /></p>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <paw:text text="Este protocolo no tiene intervenciones definidas." type="caption" />
            </c:otherwise>
        </c:choose>
    </paw:card>

    <%-- TODO: Aggregated Results — compute community-wide metric averages, trends,
         and distributions from metric_logs of completed enrollments for this protocol --%>
    <paw:card title="Resultados">
        <paw:text text="Próximamente: datos agregados de la comunidad." type="caption" />
    </paw:card>

</div>
</body>
</html>
