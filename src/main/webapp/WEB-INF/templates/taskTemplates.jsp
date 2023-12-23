<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.model.TaskGroupTemplate" %>
<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.model.TestTemplate" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.TaskTemplate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    TaskDao taskDao = new TaskDao();
    List<TaskTemplate> taskTemplates=null;
    taskTemplates = taskDao.getAllTaskTemplates();

%>

<script>

    function deleteTaskTemplate(taskTemplateId){
        if (confirm("Czy na pewno usunąć zadanie" + taskTemplateId) == true) {
            let baseUrl = "index?action=deleteTaskTemplate&user=<%=currentUser.getId()%>&taskTemplateID="+taskTemplateId;
            let form = document.createElement("form");
            form.action = baseUrl;
            form.method = "POST";
            document.body.appendChild(form);
            form.submit()
        } else {

        }
    }

</script>


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


<%if(taskTemplates.isEmpty()){%>
<h2 class="text-center">W bazie nie ma żadnych zadań</h2>
<button  class="btn  "><a href="index.jsp?webpage=addTaskTemplate">Dodaj zadanie</a></button>

<%
} else{ %>
<p class ="h1 text-center">Zarządzanie szablonami zadań</p>
<table id="groups" class="table table-active word-break table-dark">
    <thead>
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Opis zadania</th>
        <th scope="col" class="text-center">Dodatkowe parametry</th>
        <th scope="col" class="text-center">Punkty</th>
        <th scope="col" class="text-center"><button  class="btn btn-success"><a href="index.jsp?webpage=addTaskTemplate">Dodaj zadanie</a></button></th>
    </tr>
    </thead>
    <tbody>
    <% for(int i=0;i<taskTemplates.size();i++) { %>
    <tr>
        <td class="text-center"><p><%=taskTemplates.get(i).getId()%></p></td>
        <td class="text-center"><p><%=taskTemplates.get(i).getDescription()%></p></td>
        <td class="text-center"><p><%=taskTemplates.get(i).getAnswer()%></p></td>
        <td class="text-center"><p><%=taskTemplates.get(i).getScore()%></p></td>
        <td class="text-center"><p><button class="btn btn-warning"><a href="index.jsp?webpage=editTaskTemplate&taskTemplateId=<%=taskTemplates.get(i).getId()%>">Edytuj zadanie</a></button></p></td>
        <td class="text-center"><p><button class="btn btn-danger" onclick="deleteTaskTemplate(<%=taskTemplates.get(i).getId()%>)"> Usuń zadanie</button></p></td>
    </tr>

    <%}%>
    </tbody>

</table>

<%}%>
<div>
</body>
</html>
