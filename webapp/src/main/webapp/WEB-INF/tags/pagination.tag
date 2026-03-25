<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="currentPage" required="true" type="java.lang.Integer" %>
<%@ attribute name="totalPages" required="true" type="java.lang.Integer" %>
<%@ attribute name="formId" required="true" %>
<%@ attribute name="pageInputId" required="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${totalPages > 1}">
    <nav class="pagination">
        <c:if test="${currentPage > 0}">
            <a href="#" onclick="document.getElementById('${pageInputId}').value=${currentPage - 1}; document.getElementById('${formId}').submit(); return false;"
               class="pagination-link pagination-prev">&laquo; Anterior</a>
        </c:if>

        <c:forEach var="i" begin="0" end="${totalPages - 1}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="pagination-link pagination-current">${i + 1}</span>
                </c:when>
                <c:otherwise>
                    <c:if test="${i == 0 || i == totalPages - 1 || (i >= currentPage - 2 && i <= currentPage + 2)}">
                        <a href="#" onclick="document.getElementById('${pageInputId}').value=${i}; document.getElementById('${formId}').submit(); return false;"
                           class="pagination-link">${i + 1}</a>
                    </c:if>
                    <c:if test="${(i == currentPage - 3 && i > 0) || (i == currentPage + 3 && i < totalPages - 1)}">
                        <span class="pagination-ellipsis">&hellip;</span>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${currentPage < totalPages - 1}">
            <a href="#" onclick="document.getElementById('${pageInputId}').value=${currentPage + 1}; document.getElementById('${formId}').submit(); return false;"
               class="pagination-link pagination-next">Siguiente &raquo;</a>
        </c:if>
    </nav>
</c:if>
