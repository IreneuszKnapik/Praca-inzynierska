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
</head>
<body>



<%if(taskTemplates.isEmpty()){%>
<h2 class="text-center">W bazie nie ma żadnych zadań</h2>
<button  class="btn  "><a href="index.jsp?webpage=addTaskTemplate">Dodaj zadanie</a></button>

<%
} else{ %>
<button  class="btn  "><a href="index.jsp?webpage=addTaskTemplate">Dodaj zadanie</a></button>
<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Opis zadania</th>
        <th scope="col" class="text-center">Poprawna odpowiedź</th>
        <th scope="col" class="text-center">Punkty</th>

    </tr>
    <% for(int i=0;i<taskTemplates.size();i++) { %>
        <tr>
            <td>
                <%=taskTemplates.get(i).getId()%>
            </td>
            <td>
                <%=taskTemplates.get(i).getDescription()%>
            </td>
            <td>
                <%=taskTemplates.get(i).getAnswer()%>
            </td>
            <td>
                <%=taskTemplates.get(i).getScore()%>
            </td>
            <td>
                <button class="btn  "><a href="index.jsp?webpage=editTaskTemplate&taskTemplateId=<%=taskTemplates.get(i).getId()%>">Edytuj zadanie</a></button>
            </td>
            <td>
                <button class="btn " onclick="deleteTaskTemplate(<%=taskTemplates.get(i).getId()%>)"> Usuń zadanie</button>
            </td>
        </tr>

<%}%>
</table>

<%}%>

</body>
</html>
