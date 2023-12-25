<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
%>

<head>
    <meta charset="UTF-8">
    <title>Błąd rejestracji</title>


</head>

<body>
<div class = "w-75 container justify-content-center">
<p class ="h2"><%=request.getParameter("errors")%></p>

<button class="btn btn-success"><a href="index.jsp?webpage=<%= request.getParameter("targetPage") %>">Powrót</a></button>
</div>
</body>