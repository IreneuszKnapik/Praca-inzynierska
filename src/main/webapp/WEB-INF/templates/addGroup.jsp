<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page import="inz.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
%>

<script>
    function addGroup (){
        let baseUrl = "index?action=addGroup";
        console.log(baseUrl);
        let form = document.getElementById("addGroupForm");
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
<h2 class="text-center">Dodaj nową grupę</h2>
<div>
    <form id="addGroupForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="groupName" placeholder="Nazwa grupy" required="required">
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="groupDescription"  placeholder="Opis grupy" required="required">
        </div>


        <div class="form-group">
            <button onclick="addGroup()" class="btn btn-block">Dodaj grupę</button>
        </div>
    </form>

</div>

</body>
</html>
