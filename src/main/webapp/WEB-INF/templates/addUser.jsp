<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page import="inz.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
%>

<script>
    function addUser (){
        let baseUrl = "index?action=addUser";
        console.log(baseUrl);
        let form = document.getElementById("addUserForm");
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
<h2 class="text-center">Dodaj nowego użytkownika</h2>
<div>
    <form id="addUserForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="username" placeholder="Login" required="required">
        </div>
        <div class="form-group">
            <input type="password" class="form-control item" name="password"  placeholder="Hasło" required="required">
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="email" placeholder="Adres email" required="required">
        </div>
        <p>Uprawnienia użytkownika</p>
        <div class="form-group">
            <input type="radio" id="type0" name="type" value="0">
            <label for="type0">Typ 0 - zablokowany użytkownik</label>
            <input type="radio" id="type1" name="type" value="1">
            <label for="type1">Typ 1 - zwykły użytkownik - rozwiązuje testy</label>
            <input type="radio" id="type2" name="type" value="2">
            <label for="type1">Typ 2 - twórca testów - tworzy i ocenia testy</label>
            <input type="radio" id="type3" name="type" value="3">
            <label for="type3">Typ 3 - administrator - ma dostęp do wszystkiego</label>
        </div>

        <div class="form-group">
            <button onclick="addUser()" class="btn btn-block">Dodaj użytkownika</button>
        </div>
    </form>

</div>

</body>
</html>
