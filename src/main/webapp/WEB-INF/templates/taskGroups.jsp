<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.model.TaskGroupTemplate" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.TaskGroup" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    GroupDao groupDao = new GroupDao();
    List<Group> groups=null;
    groups = groupDao.getGroupsByUserId(currentUser.getId());

    TaskDao taskDao = new TaskDao();
    List<TaskGroup> taskGroup=null;
    taskGroup = taskDao.getTaskGroupByUserId(currentUser.getId());

%>


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>

<%if(taskGroup.isEmpty()){%>
<h2 class="text-center">Użytkownik nie ma udostępnionych żadnych testów</h2>
<%
} else{ %>

<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Nazwa testu</th>
    </tr>
    <% for(int i=0;i<taskGroup.size();i++) { %>
        <tr>
            <td>
                <%=taskGroup.get(i).getId()%>
            </td>

        </tr>
    <tr>
        <td>
            <a href="index.jsp?webpage=taskGroup&taskGroup=<%=taskGroup.get(i).getId()%>&taskId=0"><%=taskGroup.get(i).getName()%></a>
        </td>

    </tr>

<%}%>
</table>

<%}%>

</body>
</html>
