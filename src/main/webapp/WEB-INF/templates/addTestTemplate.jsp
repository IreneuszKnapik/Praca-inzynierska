<%@ page import="inz.dao.GroupDao" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    TaskDao taskDao = new TaskDao();
    List<TaskTemplate> tasks=null;
    tasks = taskDao.getAllTaskTemplates();

%>

<script>

    let taskChanges = [];
    function updateTask (event, taskid){
        let checkbox = event.target;

        if (checkbox.checked) {
            taskChanges.push(taskid);
            console.log(taskid + " enabled");
            console.log(taskChanges);
        } else {
            taskChanges.splice(taskChanges.indexOf(taskid),1);
            console.log(taskid + " disabled");
            console.log(taskChanges);
        }
        console.log(taskid);

    }

    function saveTestTemplate (){
        let baseUrl = "index?action=addTestTemplate&user=<%=currentUser.getId()%>&taskChanges="+taskChanges.toString();
        console.log(baseUrl);
        let form = document.getElementById("addTestForm");
        form.action = baseUrl;
        form.submit();


    }



</script>

<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body id="testForm">

<h2 class="text-center">Dodaj nowy test do bazy</h2>
<div>
    <form id="addTestForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="name" placeholder="Nazwa testu" required="required" >
        </div>
        <div class="form-group">
            <textarea placeholder="Opis testu" name="description" class="h-100 w-100" form="addTestform"></textarea>
        </div>
        <div class="form-group">
            <input type="datetime-local" class="form-control item" name="due_date"  required="required">
        </div>
        <div class="form-group">
            <input type="number" class="form-control item" name="allowed_attempts" placeholder="Ilośc mozliwych podejść" required="required">
        </div>

        <table>
            <tr>
                <th scope="col" class="text-center">Id</th>
                <th scope="col" class="text-center">Opis zadania</th>
                <th scope="col" class="text-center">Odpowiedź</th>
                <th scope="col" class="text-center">Możliwe punkty do zdobycia</th>
                <th scope="col" class="text-center">Dodane do obecnego testu?</th>
            </tr>
            <% for(int i=0;i<tasks.size();i++) { %>
            <tr>
                <td>
                    <%=tasks.get(i).getId()%>
                </td>
                <td>
                    <%=tasks.get(i).getDescription()%>
                </td>
                <td>
                    <%=tasks.get(i).getAnswer()%>
                </td>
                <td>
                    <%=tasks.get(i).getScore()%>
                </td>
                <td>
                    <input class="form-control item" type="checkbox" name="enabledTask" onchange="updateTask(event,<%=tasks.get(i).getId()%>)">
                </td>
            </tr>
            <%}%>
        </table>

        <div class="form-group">
            <button onclick="saveTestTemplate()" class="btn ">Dodaj test</button>
        </div>
    </form>

</div>

</body>
</html>
