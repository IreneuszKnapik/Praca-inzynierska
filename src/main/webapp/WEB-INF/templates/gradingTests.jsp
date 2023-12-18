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


<% if(tests.isEmpty()){%>
<h2 class="text-center">Nie ma żadnych testów do oceny</h2>
<% } else{ %>

<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Data rozpoczęcia</th>
        <th scope="col" class="text-center">Data wysłania</th>
        <th scope="col" class="text-center">Id szablonu testu</th>
        <th scope="col" class="text-center">Id użytkownika</th>
        <th scope="col" class="text-center">Ocena</th>

    </tr>
    <% for(int i=0;i<tests.size();i++) { %>
        <tr>
            <td>
                <%=tests.get(i).getId()%>
            </td>
            <td>
                <%=tests.get(i).getStart_date()%>
            </td>
            <td>
                <%=tests.get(i).getSubmit_date()%>
            </td>
            <td>
                <%=tests.get(i).getTest_template_id()%>
            </td>
            <td>
                <%=tests.get(i).getUser_id()%>
            </td>
            <td>
                <%=tests.get(i).getGrade()%>
            </td>
            <td>
                <button class="btn  "><a href="index.jsp?webpage=gradingTest&testId=<%=tests.get(i).getId()%>&taskPos=0">Oceń test</a></button>
            </td>
        </tr>

<%}%>
</table>

<%}%>

</body>
</html>
