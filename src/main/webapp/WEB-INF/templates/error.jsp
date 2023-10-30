<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
%>

<head>
    <meta charset="UTF-8">
    <title>Błąd</title>


</head>

<body>
<p><%=request.getParameter("errors")%></p>

<button type="submit" class="btn btn-block"><a href="index.jsp?webpage=<%= request.getParameter("targetPage") %>">Powrót</a></button>
</body>