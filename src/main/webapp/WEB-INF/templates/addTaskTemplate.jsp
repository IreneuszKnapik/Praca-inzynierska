<%@ page import="inz.dao.GroupDao" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<script>

    function saveTaskTemplate (){
        let baseUrl = "index?action=addTaskTemplate&user=<%=currentUser.getId()%>";
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

<h2 class="text-center">Dodaj nowy test do bazy</h2>
<div>
    <form id="addTaskForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <p class="h2">Opis zadania</p>
        <div class="form-group">
            <textarea placeholder="Opis zadania" name="description" class="h-100 w-100" form="addTaskForm" required="required"></textarea>
        </div>
        <p class="h2">Odpowiedź</p>
        <div class="form-group">
            <textarea placeholder="Odpowiedź" name="answer" class="h-100 w-100" form="addTaskForm" required="required"></textarea>
        </div>
        <p class="h2">Punkty za zadanie</p>
        <div class="form-group">
            <input type="number" class="form-control item" name="score" placeholder="Punkty za zadanie" required="required">
        </div>

        <div class="form-group">
            <button onclick="saveTaskTemplate()" class="btn ">Dodaj test</button>
        </div>
    </form>

</div>

</body>
</html>
