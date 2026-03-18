<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>

<html>
<head>
    <title>BioStack - Components Demo</title>
    <link rel="stylesheet" href="<c:url value='/css/components.css' />" />
    <style>
        body { font-family: var(--bs-font-family); background: var(--bs-gray-50); padding: 2rem; color: var(--bs-gray-800); }
        .section { margin-bottom: 2.5rem; }
        .flex-row { display: flex; gap: 0.5rem; flex-wrap: wrap; align-items: center; }
        hr { border: none; border-top: 1px solid var(--bs-gray-200); margin: 2rem 0; }
    </style>
</head>
<body>

    <paw:text text="BioStack Component Library" type="heading" />
    <paw:text text="Reusable components for the biohacking protocol platform" type="body" />

    <hr />

    <%-- Text --%>
    <div class="section">
        <paw:text text="Text" type="title" />
        <paw:text text="Protocol: Sleep Optimization Stack" type="heading" />
        <paw:text text="Improve deep sleep and HRV recovery" type="subtitle" />
        <paw:text text="This protocol combines magnesium glycinate, light blocking, and cold exposure to optimize sleep architecture." type="body" />
        <paw:text text="Dosage" type="label" />
        <paw:text text="Last updated 3 days ago" type="caption" />
    </div>

    <hr />

    <%-- Buttons --%>
    <div class="section">
        <paw:text text="Buttons" type="title" />
        <div class="flex-row">
            <paw:button text="Follow Protocol" variant="primary" />
            <paw:button text="Compare" variant="secondary" />
            <paw:button text="View Details" variant="outline" />
            <paw:button text="Delete" variant="danger" size="sm" />
            <paw:button text="Cancel" variant="ghost" />
            <paw:button text="Disabled" variant="primary" disabled="${true}" />
        </div>
        <br />
        <div class="flex-row">
            <paw:button text="Small" variant="primary" size="sm" />
            <paw:button text="Medium" variant="primary" size="md" />
            <paw:button text="Large" variant="primary" size="lg" />
        </div>
    </div>

    <hr />

    <%-- Cards --%>
    <div class="section">
        <paw:text text="Cards" type="title" />
        <div class="flex-row" style="align-items: flex-start;">
            <paw:card title="Sleep Optimization">
                <paw:text text="Magnesium glycinate 400mg, light blocking glasses 2h before bed, cold shower protocol." type="body" />
                <paw:text text="127 followers &middot; 4.3 avg rating" type="caption" />
            </paw:card>
            <paw:card title="HRV Booster">
                <paw:text text="Box breathing 5min AM, zone 2 cardio 30min 3x/week, ashwagandha 600mg." type="body" />
                <paw:text text="89 followers &middot; 4.1 avg rating" type="caption" />
            </paw:card>
        </div>
    </div>

    <hr />

    <%-- Inputs --%>
    <div class="section">
        <paw:text text="Inputs" type="title" />
        <div style="max-width: 400px;">
            <paw:input name="protocol_name" label="Protocol Name" placeholder="e.g. Sleep Optimization Stack" />
            <paw:input name="dosage" label="Dosage (mg)" type="number" placeholder="400" />
            <paw:input name="notes" label="Session Notes" type="textarea" placeholder="How did you feel today?" />
            <paw:input name="email" label="Email" type="email" value="bad-email" error="Enter a valid email address" />
            <paw:input name="locked" label="Locked Field" value="Magnesium Glycinate" disabled="${true}" />
        </div>
    </div>

    <hr />

    <%-- Toasts --%>
    <div class="section">
        <paw:text text="Toasts" type="title" />
        <paw:text text="(fixed position, top-right corner)" type="caption" />
    </div>

    <paw:toast title="Log Saved" text="Your daily metrics have been recorded." variant="success" />

</body>
</html>
