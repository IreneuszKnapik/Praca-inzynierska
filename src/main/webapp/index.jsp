<%@ page import="inz.util.Parser" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>Ireneusz Knapik - praca inżynierska</title>
    <style><%@include file="/static/css/bootstrap-4.0.0-dist/css/bootstrap.min.css"%></style>
</head>

<%
    String webpage =request.getParameter("webpage");
    webpage =  Parser.parse(webpage);
%>

<body>

<jsp:include page="/WEB-INF/templates/navbar.jsp"/>

<jsp:include page="/WEB-INF/templates/content.jsp">
    <jsp:param name="which" value="<%=webpage%>"/>
</jsp:include>

</body>
</html>