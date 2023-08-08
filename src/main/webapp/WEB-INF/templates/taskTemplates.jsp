<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.model.TaskGroupTemplate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    GroupDao groupDao = new GroupDao();
    List<Group> groups=null;
    groups = groupDao.getGroupsByUserId(currentUser.getId());

    TaskTemplateDao taskTemplateDao = new TaskTemplateDao();
    List<TaskGroupTemplate> taskGroupTemplates=null;
    taskGroupTemplates = taskTemplateDao.getTaskGroupByUserId(currentUser.getId());

%>


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>

<%if(taskGroupTemplates.isEmpty()){%>
<h2 class="text-center">Użytkownik nie ma udostępnionych żadnych szablonów testów</h2>
<%
} else{ %>

<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Nazwa szablonu testu</th>
    </tr>
    <% for(int i=0;i<taskGroupTemplates.size();i++) { %>
        <tr>
            <td>
                <%=taskGroupTemplates.get(i).getId()%>
            </td>

        </tr>
    <tr>
        <td>
            <%=taskGroupTemplates.get(i).getName()%>
        </td>

    </tr>

<%}%>
</table>

<%}%>

</body>
</html>
