<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="text" required="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<div class="toast">
    <div class="toast-header">
        <paw:text text="${title}" type="subtitle" cssClass="toast-title" />
        <button type="button" class="toast-close" onclick="this.closest('.toast').remove();">&times;</button>
    </div>
    <div class="toast-body">
        <paw:text text="${text}" type="body" cssClass="toast-body-text" />
    </div>
</div>
