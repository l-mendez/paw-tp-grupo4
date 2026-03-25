<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<html>
<head>
    <title>Explorar Protocolos - BioStack</title>
    <link rel="stylesheet" href="<c:url value='/css/components.css' />" />
    <link rel="stylesheet" href="<c:url value='/css/protocols.css' />" />
</head>
<body>
<div class="protocols-page">

    <paw:text text="Explorar Protocolos" type="heading" />

    <%-- Search bar --%>
    <form action="<c:url value='/protocols' />" method="get" class="protocols-search-form">
        <paw:input name="q" type="text" placeholder="Buscar protocolos por nombre, descripción o tags..."
                   value="${filter.query}" />
        <paw:button text="Buscar" variant="primary" type="submit" />
    </form>

    <div class="protocols-layout">

        <%-- ========== FILTER SIDEBAR ========== --%>
        <aside class="filter-sidebar">
            <form action="<c:url value='/protocols' />" method="get" id="filterForm">
                <input type="hidden" name="q" value="<c:out value='${filter.query}' />" />
                <input type="hidden" name="page" value="0" id="pageInput" />

                <div class="filter-actions">
                    <paw:button text="Aplicar filtros" variant="primary" type="submit" size="sm" />
                    <a href="<c:url value='/protocols' />" class="btn btn-sm btn-ghost">Limpiar</a>
                </div>

                <%-- Goal Category --%>
                <div class="filter-section">
                    <div class="filter-section-title">Categoría</div>
                    <label class="filter-checkbox">
                        <input type="radio" name="goalCategory" value=""
                            ${empty filter.goalCategoryId ? 'checked' : ''} />
                        Todas
                    </label>
                    <c:forEach var="cat" items="${goalCategories}">
                        <label class="filter-checkbox">
                            <input type="radio" name="goalCategory" value="${cat.id}"
                                ${filter.goalCategoryId == cat.id ? 'checked' : ''} />
                            <c:out value="${cat.label}" />
                        </label>
                    </c:forEach>
                </div>

                <%-- Status --%>
                <div class="filter-section">
                    <div class="filter-section-title">Estado</div>
                    <label class="filter-checkbox">
                        <input type="radio" name="status" value=""
                            ${empty filter.status ? 'checked' : ''} />
                        Todos
                    </label>
                    <label class="filter-checkbox">
                        <input type="radio" name="status" value="recruiting"
                            ${filter.status == 'recruiting' ? 'checked' : ''} />
                        Reclutando
                    </label>
                    <label class="filter-checkbox">
                        <input type="radio" name="status" value="active"
                            ${filter.status == 'active' ? 'checked' : ''} />
                        Activo
                    </label>
                    <label class="filter-checkbox">
                        <input type="radio" name="status" value="completed"
                            ${filter.status == 'completed' ? 'checked' : ''} />
                        Completado
                    </label>
                </div>

                <%-- Duration Range --%>
                <div class="filter-section">
                    <div class="filter-section-title">Duración (días)</div>
                    <div class="filter-range">
                        <input type="number" name="minDuration" class="form-input"
                               placeholder="Min" value="${filter.minDuration}" min="1" />
                        <span>-</span>
                        <input type="number" name="maxDuration" class="form-input"
                               placeholder="Max" value="${filter.maxDuration}" min="1" />
                    </div>
                </div>

                <%-- Min Rating --%>
                <div class="filter-section">
                    <div class="filter-section-title">Rating mínimo</div>
                    <paw:select name="minRating">
                        <option value="" ${empty filter.minRating ? 'selected' : ''}>Cualquiera</option>
                        <option value="3.0" ${filter.minRating == 3.0 ? 'selected' : ''}>3+ estrellas</option>
                        <option value="4.0" ${filter.minRating == 4.0 ? 'selected' : ''}>4+ estrellas</option>
                        <option value="4.5" ${filter.minRating == 4.5 ? 'selected' : ''}>4.5+ estrellas</option>
                    </paw:select>
                </div>

                <%-- Intervention Categories --%>
                <div class="filter-section">
                    <div class="filter-section-title">Tipo de intervención</div>
                    <c:forEach var="intCat" items="${interventionCategories}">
                        <label class="filter-checkbox">
                            <input type="checkbox" name="interventionCategories" value="${intCat.id}"
                                <c:if test="${not empty filter.interventionCategoryIds}">
                                    <c:forEach var="selId" items="${filter.interventionCategoryIds}">
                                        <c:if test="${selId == intCat.id}">checked</c:if>
                                    </c:forEach>
                                </c:if>
                            />
                            <c:out value="${intCat.label}" />
                        </label>
                    </c:forEach>
                </div>

                <%-- Tags --%>
                <c:if test="${not empty allTags}">
                    <div class="filter-section">
                        <div class="filter-section-title">Tags</div>
                        <div class="filter-tags-list" id="tagsList">
                            <c:forEach var="tag" items="${allTags}">
                                <label class="filter-checkbox">
                                    <input type="checkbox" name="tags" value="${tag}"
                                        <c:if test="${not empty filter.tags}">
                                            <c:forEach var="selTag" items="${filter.tags}">
                                                <c:if test="${selTag == tag}">checked</c:if>
                                            </c:forEach>
                                        </c:if>
                                    />
                                    <c:out value="${tag}" />
                                </label>
                            </c:forEach>
                        </div>
                        <c:if test="${fn:length(allTags) > 10}">
                            <button type="button" class="filter-toggle-tags" onclick="document.getElementById('tagsList').classList.toggle('filter-tags-expanded'); this.textContent = this.textContent === 'Ver todos' ? 'Ver menos' : 'Ver todos';">Ver todos</button>
                        </c:if>
                    </div>
                </c:if>

            </form>
        </aside>

        <%-- ========== MAIN CONTENT ========== --%>
        <main class="protocols-main">

            <%-- Results bar with sort dropdown --%>
            <div class="results-bar">
                <paw:text text="${result.totalCount} protocolo${result.totalCount != 1 ? 's' : ''} encontrado${result.totalCount != 1 ? 's' : ''}"
                          type="caption" />
                <div class="sort-dropdown">
                    <label class="sort-dropdown-label" for="sortSelect">Ordenar por:</label>
                    <select name="sort" form="filterForm" id="sortSelect" class="form-select sort-select"
                            onchange="document.getElementById('pageInput').value='0'; document.getElementById('filterForm').submit();">
                        <option value="newest" ${currentSort == 'newest' ? 'selected' : ''}>Más nuevos</option>
                        <option value="popular" ${currentSort == 'popular' ? 'selected' : ''}>Más populares</option>
                        <option value="rating" ${currentSort == 'rating' ? 'selected' : ''}>Mejor rating</option>
                        <option value="duration" ${currentSort == 'duration' ? 'selected' : ''}>Duración</option>
                    </select>
                </div>
            </div>

            <%-- Protocol cards --%>
            <c:choose>
                <c:when test="${not empty protocols}">
                    <div class="protocols-grid">
                        <c:forEach var="protocol" items="${protocols}">
                            <paw:protocol-card
                                title="${protocol.title}"
                                description="${protocol.description}"
                                status="${protocol.status}"
                                goalLabel="${protocol.goalLabel}"
                                avgRating="${protocol.avgRating}"
                                reviewCount="${protocol.reviewCount}"
                                enrollmentCount="${protocol.enrollmentCount}"
                                durationDays="${protocol.durationDays}"
                                tags="${protocol.tags}"
                                creatorDisplayName="${protocol.creatorDisplayName}" />
                        </c:forEach>
                    </div>

                    <%-- Pagination --%>
                    <c:if test="${result.totalPages > 1}">
                        <paw:pagination currentPage="${result.currentPage}"
                                        totalPages="${result.totalPages}"
                                        formId="filterForm"
                                        pageInputId="pageInput" />
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="protocols-empty">
                        <p class="protocols-empty-title">No se encontraron protocolos</p>
                        <paw:text text="Intentá ajustar los filtros o buscar con otros términos." type="body" />
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>
</body>
</html>
