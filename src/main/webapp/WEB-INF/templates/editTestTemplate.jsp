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

    String testTemplateId = request.getParameter("testTemplateId");

    TestDao testDao = new TestDao();
    TestTemplate testTemplate = null;
    testTemplate = testDao.getTestTemplateById(Integer.parseInt(testTemplateId));
    List<String> taskIDs = testDao.getTaskIDfromTestTemplate(Integer.parseInt(testTemplateId));

%>

<script>

    let taskChanges = [];

    function updateTask (event, taskid){
        //console.log(taskid);
        if (taskChanges.includes(taskid)) {
            taskChanges.splice(taskChanges.indexOf(taskid),1);
            //console.log(taskid + " disabled");
            //console.log(taskChanges);

        } else {
            taskChanges.push(taskid);
            //console.log(taskid + " enabled");
            //console.log(taskChanges);
        }


    }

    function saveTestTemplate (){

        if(taskChanges.length === 0){
            taskChanges=[0];
        }
        let baseUrl = "index?action=updateTestTemplate&user=<%=currentUser.getId()%>&testTemplateID=<%=testTemplateId%>&taskChanges="+taskChanges;
        console.log(baseUrl);
        let form = document.getElementById("editTestForm");
        form.action = baseUrl;
        form.submit();


    }


</script>

<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>
<h2 class="text-center">Edytuj test </h2>
<div>
    <form id="editTestForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item"  name="name" placeholder="Nazwa testu" required="required" defaultValue="<%=testTemplate.getName()%>" value="<%=testTemplate.getName()%>">
        </div>
        <div class="form-group">
            <textarea placeholder="Opis testu" name="description" class="h-100 w-100" defaultValue="<%=testTemplate.getDescription()%>" ><%=testTemplate.getDescription()%></textarea>
        </div>
        <div class="form-group">
            <input type="datetime-local" class="form-control item" name="due_date"  required="required" defaultValue="<%=testTemplate.getDue_date()%>" value="<%=testTemplate.getDue_date()%>">
        </div>
        <div class="form-group">
            <input type="number" class="form-control item"  name="allowed_attempts" placeholder="Ilośc mozliwych podejść" required="required" defaultValue="<%=testTemplate.getAllowed_attempts()%>" value="<%=testTemplate.getAllowed_attempts()%>">
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
                    <input class="form-control item" type="checkbox" name="enabledTask" onchange="updateTask(event,<%=tasks.get(i).getId()%>)" <% if (taskIDs.contains(String.valueOf(tasks.get(i).getId()))) {%>checked<%}%>>
                </td>
            </tr>
            <%}%>
        </table>

        <div class="form-group">
            <button onclick="saveTestTemplate()" class="btn btn-block">Zapisz zmiany</button>
        </div>
    </form>

</div>

</body>
</html>
