<%@ page import="inz.util.Parser" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>Ireneusz Knapik - praca inżynierska</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/simple-line-icons/2.4.1/css/simple-line-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

    <link href="/resources/login.css" rel="stylesheet">



</head>

<%
    String webpage =request.getParameter("webpage");
    webpage =  Parser.parse(webpage,"index;register;login;landing");
%>

<body>

<jsp:include page="/WEB-INF/templates/navbar.jsp"/>

<jsp:include page="/WEB-INF/templates/content.jsp">
    <jsp:param name="which" value="<%=webpage%>"/>
</jsp:include>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>


</body>
</html>