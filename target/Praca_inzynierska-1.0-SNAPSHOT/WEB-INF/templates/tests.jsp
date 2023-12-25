<%@ page import="inz.dao.GroupDao" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    TestDao testDao = new TestDao();
    List<TestTemplate> testTemplates = null;
    testTemplates = testDao.getTestTemplatesByUserId(currentUser.getId());
%>


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
    <style>
        td > p {
            word-break: break-all;
        }
    </style>
</head>
<body>
<div style="width:90%" class="container align-items-center justify-content-center">

<%if(testTemplates.isEmpty()){%>
<h2 class="text-center">Użytkownik nie ma udostępnionych żadnych testów</h2>
<%
} else{ %>
<p class="h1 text-center">Dostepne testy</p>
<table id="groups" class="table table-active word-break table-dark">
    <thead>
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Nazwa testu</th>
    </tr>
    </thead>
    <tbody>
    <% for(int i=0;i<testTemplates.size();i++) { %>
    <tr>
        <td><p class="text-center"><%=testTemplates.get(i).getId()%></p></td>
        <td><p class="text-center"><%=testTemplates.get(i).getName()%></p></td>
        <td><button  class="btn btn-info"><a href="index?&action=openTest&testTemplateId=<%=testTemplates.get(i).getId()%>">Otwórz test</a></button></td>
    </tr>
    </tbody>


<%}%>
</table>

<%}%>
</div>
</body>
</html>
