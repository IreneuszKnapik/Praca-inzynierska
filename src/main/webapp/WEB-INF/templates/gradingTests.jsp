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
    List<Test> tests = null;
    tests = testDao.getAllTests();

%>



<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<div style="width:90%" class="container align-items-center justify-content-center">

<% if(tests.isEmpty()){%>
<h2 class="text-center">Nie ma żadnych testów do oceny</h2>
<% } else{ %>
<p class ="h1 text-center">Ocenianie testów</p>
<table class="table table-active word-break table-dark">
    <thead>
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Data rozpoczęcia</th>
        <th scope="col" class="text-center">Data wysłania</th>
        <th scope="col" class="text-center">Id szablonu testu</th>
        <th scope="col" class="text-center">Id użytkownika</th>
        <th scope="col" class="text-center">Ocena</th>
    </tr>
    </thead>
    <tbody>

    <% for(int i=0;i<tests.size();i++) { %>
        <tr>
            <td class="text-center"><p><%=tests.get(i).getId()%></p></td>
            <td class="text-center"><p><%=tests.get(i).getStart_date()%></p></td>
            <td class="text-center"><p><%=tests.get(i).getSubmit_date()%></p></td>
            <td class="text-center"><p><%=tests.get(i).getTest_template_id()%></p></td>
            <td class="text-center"><p><%=tests.get(i).getUser_id()%></p></td>
            <td class="text-center"><p><%=tests.get(i).getGrade()%></p></td>
            <td class="text-center"><p><button class="btn btn-info"><a href="index.jsp?webpage=gradingTest&testId=<%=tests.get(i).getId()%>&taskPos=0">Oceń test</a></button></p></td>
        </tr>

<%}%>
    </tbody>
</table>

<%}%>
</div>
</body>
</html>
