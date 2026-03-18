<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="false" %>
<%@ attribute name="type" required="false" %>
<%@ attribute name="placeholder" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="error" required="false" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>
<%@ attribute name="required" required="false" type="java.lang.Boolean" %>
<%@ attribute name="cssClass" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<c:set var="inputType" value="${not empty type ? type : 'text'}" />
<c:set var="inputDisabled" value="${disabled ne null ? disabled : false}" />
<c:set var="inputRequired" value="${required ne null ? required : false}" />
<c:set var="extraClass" value="${not empty cssClass ? cssClass : ''}" />
<c:set var="errorClass" value="${not empty error ? 'form-input-error' : ''}" />

<div class="form-group">
    <c:if test="${not empty label}">
        <paw:text text="${label}" type="label" />
    </c:if>

    <c:choose>
        <c:when test="${inputType == 'textarea'}">
            <textarea
                name="${name}"
                class="form-input ${errorClass} ${extraClass}"
                placeholder="${placeholder}"
                <c:if test="${inputDisabled}">disabled</c:if>
                <c:if test="${inputRequired}">required</c:if>
            ><c:out value="${value}" /></textarea>
        </c:when>
        <c:otherwise>
            <input
                type="${inputType}"
                name="${name}"
                class="form-input ${errorClass} ${extraClass}"
                placeholder="${placeholder}"
                value="<c:out value='${value}' />"
                <c:if test="${inputDisabled}">disabled</c:if>
                <c:if test="${inputRequired}">required</c:if>
            />
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty error}">
        <p class="form-error-text"><c:out value="${error}" /></p>
    </c:if>
</div>
