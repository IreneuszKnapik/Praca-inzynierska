<%@ page import="java.util.List" %>

<%@ page import="inz.model.*" %>
<%@ page import="inz.dao.*" %>
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

    GroupDao groupDao= new GroupDao();
    List<Group> groups = null;
    groups = groupDao.getAllGroups();
    List<String> groupIDs = groupDao.getGroupIDfromTestTemplate(Integer.parseInt(testTemplateId));

%>

<script>

    let taskChanges = [];
    let groupChanges = [];

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
    function updateGroup (event, groupid){
        //console.log(taskid);
        if (groupChanges.includes(groupid)) {
            groupChanges.splice(groupChanges.indexOf(groupid),1);
            //console.log(taskid + " disabled");
            //console.log(taskChanges);

        } else {
            groupChanges.push(groupid);
            //console.log(taskid + " enabled");
            //console.log(taskChanges);
        }


    }

    function saveTestTemplate (){

        if(taskChanges.length === 0){
            taskChanges=[0];
        }
        if(groupChanges.length === 0){
            groupChanges=[0];
        }
        let baseUrl = "index?action=updateTestTemplate&user=<%=currentUser.getId()%>&testTemplateID=<%=testTemplateId%>&taskChanges="+taskChanges+"&groupChanges="+groupChanges;
        console.log(baseUrl);
        let form = document.getElementById("editTestForm");
        form.action = baseUrl;
        form.submit();


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

<h2 class="text-center">Edytuj test: <%=testTemplate.getName()%></h2>
<div style="width:90%" class="container align-items-center justify-content-center">
    <div>
    <form id="editTestForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <p class="h2">Nazwa testu</p>
        <div class="form-group">
            <input type="text" class="form-control item"  name="name" placeholder="Nazwa testu" required="required" defaultValue="<%=testTemplate.getName()%>" value="<%=testTemplate.getName()%>">
        </div>
        <p class="h2">Opis testu</p>
        <div class="form-group">
            <textarea placeholder="Opis testu" name="description" class="w-100 form-control" defaultValue="<%=testTemplate.getDescription()%>" ><%=testTemplate.getDescription()%></textarea>
        </div>
        <p class="h2">Dozwolona data oddania</p>
        <div class="form-group">
            <input type="datetime-local" class="form-control item" name="due_date"  required="required" defaultValue="<%=testTemplate.getDue_date()%>" value="<%=testTemplate.getDue_date()%>">
        </div>
        <p class="h2">Ilośc mozliwych podejść</p>
        <div class="form-group">
            <input type="number" class="form-control item"  name="allowed_attempts" placeholder="Ilośc mozliwych podejść" required="required" defaultValue="<%=testTemplate.getAllowed_attempts()%>" value="<%=testTemplate.getAllowed_attempts()%>">
        </div>
        <p class="h2">Przydzielanie zadań do testu</p>
        <table class="table table-active word-break table-dark">
            <thead class="thead-dark">
            <tr>
                <th scope="col" class="text-center">Id</th>
                <th scope="col" class="text-center">Opis zadania</th>
                <th scope="col" class="text-center">Odpowiedź</th>
                <th scope="col" class="text-center">Możliwe punkty do zdobycia</th>
                <th scope="col" class="text-center">Dodane do obecnego testu?</th>
            </tr>
            </thead>
            <tbody>
            <% for(int i=0;i<tasks.size();i++) { %>
            <tr>
                <td><p class="text-center"><%=tasks.get(i).getId()%></p></td>
                <td>
                    <p class="text-center">
                    <%=tasks.get(i).getDescription()%>
                    </p>
                </td>
                <td>
                    <p class="text-center">
                    <%=tasks.get(i).getTaskCodeBody()%>
                    </p>
                </td>
                <td>
                    <p class="text-center" >
                    <%=tasks.get(i).getScore()%>
                    </p>
                </td>
                <td>
                    <input class="form-control item" type="checkbox" name="enabledTask" onchange="updateTask(event,<%=tasks.get(i).getId()%>)" <% if (taskIDs.contains(String.valueOf(tasks.get(i).getId()))) {%>checked<%}%>>
                </td>
            </tr>
            <%}%>
            </tbody>
        </table>
    </br>
        <p class="h2">Udostępnianie testu grupom</p>
        <table class="table table-active word-break">
            <thead class="thead-dark">
            <tr>
                <th scope="col" class="text-center">Id</th>
                <th scope="col" class="text-center">Nazwa grupy</th>
                <th scope="col" class="text-center">Opis grupy</th>
                <th scope="col" class="text-center">Obecny test udostępniony dla grupy?</th>
            </tr>
            </thead>
            <tbody>
            <% for(int i=0;i<groups.size();i++) { %>
            <tr>
                <td><p class="text-center" ><%=groups.get(i).getId()%></p>

                </td>
                <td><p class="text-center" ><%=groups.get(i).getName()%></p>

                </td>
                <td><p class="text-center" ><%=groups.get(i).getDescription()%></p>

                </td>
                <td>
                    <input class="form-control item" type="checkbox" name="enabledGroup" onchange="updateGroup(event,<%=groups.get(i).getId()%>)" <% if (groupIDs.contains(String.valueOf(groups.get(i).getId()))) {%>checked<%}%>>
                </td>
            </tr>
            <%}%>
            </tbody>
        </table>
    </br>
        <div class="form-group">
            <button onclick="saveTestTemplate()" class="btn btn-success">Zapisz zmiany</button>
        </div>
    </form>

</div>

</body>
</html>
