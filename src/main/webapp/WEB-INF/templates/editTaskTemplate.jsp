<%@ page import="inz.dao.GroupDao" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    TaskTemplateDao taskTemplateDao = new TaskTemplateDao();

    String taskTemplateId = request.getParameter("taskTemplateId");
    TaskTemplate taskTemplate = null;
    taskTemplate = taskTemplateDao.getTaskTemplateById(Integer.parseInt(taskTemplateId));
%>

<script>

    function saveTaskTemplate (){
        let baseUrl = "index?action=updateTaskTemplate&user=<%=currentUser.getId()%>&taskTemplateID="+ <%=taskTemplateId%>;
        console.log(baseUrl);
        let form = document.getElementById("addTaskForm");
        form.action = baseUrl;
        form.submit();


    }



</script>

<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>


<div style="width:90%" class="container align-items-center justify-content-center">
    <h2 class="text-center">Edytuj zadanie: <%=taskTemplate.getId()%></h2>
    <form id="addTaskForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <p class="h2">Opis zadania</p>
            <textarea placeholder="Opis zadania" name="description" class="h-100 w-100 form-control " form="addTaskForm" required="required" defaultValue="<%=taskTemplate.getDescription()%>" ><%=taskTemplate.getDescription()%></textarea>
        </div>
        <div class="form-group">
            <p class="h2">Dodatkowe parametry</p>
            <textarea placeholder="
int main() {

return 0;
}" name="answer" class="h-100 w-100 form-control" form="addTaskForm" required="required" defaultValue="<%=taskTemplate.getAnswer()%>" ><%=taskTemplate.getAnswer()%></textarea>
        </div>
        <div class="form-group" >
            <p class="h2">Punkty za zadanie</p>
            <input style="width:100px" type="number" class="form-control item" name="score" form="addTaskForm" required="required" defaultValue="<%=taskTemplate.getScore()%>" value="<%=taskTemplate.getScore()%>">
        </div>
    </br>
        <div class="form-group">
            <button onclick="saveTaskTemplate()" class="btn btn-success">Zapisz zmiany</button>
        </div>
    </form>

</div>

</body>
</html>
