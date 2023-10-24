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
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>

<%if(testTemplates.isEmpty()){%>
<h2 class="text-center">Użytkownik nie ma udostępnionych żadnych testów</h2>
<%
} else{ %>

<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Nazwa testu</th>
    </tr>
    <% for(int i=0;i<testTemplates.size();i++) { %>
        <tr>
            <td>
                <%=testTemplates.get(i).getId()%>
            </td>
            <td>
                <a href="index?&action=openTest&testTemplateId=<%=testTemplates.get(i).getId()%>"><%=testTemplates.get(i).getName()%></a>
            </td>

        </tr>

<%}%>
</table>

<%}%>

</body>
</html>
