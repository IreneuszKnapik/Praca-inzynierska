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
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>
<h2 class="text-center">Dodaj nowy test do bazy</h2>
<div>
    <form id="addTaskForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <textarea placeholder="Opis zadania" name="description" class="h-100 w-100" form="addTaskForm" required="required"></textarea>
        </div>
        <div class="form-group">
            <textarea placeholder="Odpowiedź" name="answer" class="h-100 w-100" form="addTaskForm" required="required"></textarea>
        </div>
        <div class="form-group">
            <input type="number" class="form-control item" name="score" placeholder="Punkty za zadanie" required="required">
        </div>

        <div class="form-group">
            <button onclick="saveTaskTemplate()" class="btn btn-block">Dodaj test</button>
        </div>
    </form>

</div>

</body>
</html>