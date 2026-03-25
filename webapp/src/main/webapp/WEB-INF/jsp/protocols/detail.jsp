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
    <c:if test="${currentUser != null}">
        <div class="protocol-detail-actions">
            <form action="<c:url value='/protocols/${protocol.id}/enroll' />" method="post">
                <button type="submit" class="btn btn-md ${isEnrolled ? 'btn-outline' : 'btn-primary'} btn-action">
                    <span class="btn-icon">${isEnrolled ? '&#10005;' : '&#9998;'}</span>
                    ${isEnrolled ? 'Abandonar' : 'Anotarse'}
                </button>
            </form>
            <form action="<c:url value='/protocols/${protocol.id}/favorite' />" method="post">
                <button type="submit" class="btn btn-md ${isFavorited ? 'btn-secondary-outline' : 'btn-secondary'} btn-action">
                    <span class="btn-icon">${isFavorited ? '&#9829;' : '&#9825;'}</span>
                    ${isFavorited ? 'Guardado' : 'Guardar'}
                </button>
            </form>
        </div>
    </c:if>

    <%-- Stats --%>
    <div class="protocol-detail-stats">
        <div class="protocol-detail-stat">
            <paw:rating value="${protocol.avgRating}" count="${protocol.reviewCount}"
                        muted="${currentUser != null && userReview == null}" />
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

    <%-- Reviews --%>
    <paw:card title="Reviews">

        <%-- New review form (only when user hasn't reviewed yet) --%>
        <c:if test="${currentUser != null && userReview == null}">
            <form action="<c:url value='/protocols/${protocol.id}/reviews' />" method="post"
                  class="review-form">
                <div class="review-star-selector">
                    <span class="review-star-label">Puntaje:</span>
                    <c:forEach var="i" begin="1" end="5">
                        <label class="review-star-option">
                            <input type="radio" name="rating" value="${i}" required />
                            <span class="review-star-icon">&#9733;</span>
                        </label>
                    </c:forEach>
                </div>
                <paw:input name="body" type="textarea"
                           placeholder="Contá tu experiencia con este protocolo..." />
                <paw:button text="Enviar review" variant="primary" type="submit" />
            </form>
        </c:if>

        <c:if test="${currentUser == null}">
            <p class="review-login-prompt">
                <a href="<c:url value='/login' />">Iniciá sesión</a> para dejar una review.
            </p>
        </c:if>

        <%-- Reviews list --%>
        <c:if test="${not empty reviews}">
            <div class="review-list">
                <c:forEach var="review" items="${reviews}">
                    <c:set var="isOwn" value="${currentUser != null && review.userId == currentUser.id}" />
                    <div class="review-item ${isOwn ? 'review-item-own' : ''}" id="review-${review.id}">

                        <%-- Display mode --%>
                        <div class="review-item-display" id="review-display-${review.id}">
                            <div class="review-item-header">
                                <strong><c:out value="${review.userDisplayName}" /></strong>
                                <paw:rating value="${review.rating + 0.0}" />
                                <c:if test="${isOwn}">
                                    <div class="review-item-actions">
                                        <button type="button" class="review-action-btn"
                                                onclick="toggleEditReview('${review.id}')">Editar</button>
                                        <form action="<c:url value='/protocols/${protocol.id}/reviews/delete' />"
                                              method="post" class="review-delete-form">
                                            <button type="submit" class="review-action-btn review-action-delete">Eliminar</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                            <c:if test="${not empty review.body}">
                                <p class="review-item-body"><c:out value="${review.body}" /></p>
                            </c:if>
                        </div>

                        <%-- Edit mode (hidden by default, only for own review) --%>
                        <c:if test="${isOwn}">
                            <form action="<c:url value='/protocols/${protocol.id}/reviews' />" method="post"
                                  class="review-edit-form" id="review-edit-${review.id}" style="display: none;">
                                <div class="review-star-selector">
                                    <span class="review-star-label">Puntaje:</span>
                                    <c:forEach var="i" begin="1" end="5">
                                        <label class="review-star-option">
                                            <input type="radio" name="rating" value="${i}"
                                                ${review.rating == i ? 'checked' : ''} required />
                                            <span class="review-star-icon">&#9733;</span>
                                        </label>
                                    </c:forEach>
                                </div>
                                <paw:input name="body" type="textarea" value="${review.body}" />
                                <div class="review-edit-actions">
                                    <paw:button text="Guardar" variant="primary" type="submit" size="sm" />
                                    <button type="button" class="btn btn-sm btn-ghost"
                                            onclick="toggleEditReview('${review.id}')">Cancelar</button>
                                </div>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty reviews && currentUser == null}">
            <paw:text text="Este protocolo aún no tiene reviews." type="caption" />
        </c:if>
    </paw:card>

    <script>
        function toggleEditReview(reviewId) {
            var display = document.getElementById('review-display-' + reviewId);
            var edit = document.getElementById('review-edit-' + reviewId);
            if (edit.style.display === 'none') {
                edit.style.display = 'block';
                display.style.display = 'none';
            } else {
                edit.style.display = 'none';
                display.style.display = 'block';
            }
        }
    </script>

</div>
</body>
</html>
