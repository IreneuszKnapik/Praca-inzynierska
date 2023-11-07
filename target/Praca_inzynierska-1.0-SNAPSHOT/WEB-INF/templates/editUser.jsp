<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page import="inz.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    Integer userId = Integer.parseInt(request.getParameter("userId"));

    UserDao userDao = new UserDao();
    User user = null;
    user = userDao.getUserById(userId);

%>

<script>




    function saveUser (){
        let baseUrl = "index?action=updateUser&userId=<%=user.getId()%>";
        console.log(baseUrl);
        let form = document.getElementById("editUserForm");
        form.action = baseUrl;
        form.submit();
    }

    window.onload = function () {
        let radio = document.querySelector("#type<%=user.getType() %>");
        radio.checked = true;
    }

</script>

<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>
<h2 class="text-center">Edytuj użytkownika <%=user.getUsername() %></h2>
<div>
    <form id="editUserForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="username" placeholder="Login" required="required" defaultValue="<%=user.getUsername()%>" value="<%=user.getUsername()%>">
        </div>
        <div class="form-group">
            <input type="password" class="form-control item" name="password1"  placeholder="Ustaw nowe hasło" required="required">
        </div>
        <div class="form-group">
            <input type="password" class="form-control item" name="password2"  placeholder="Powtórz hasło" required="required">
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="email" placeholder="Adres email" required="required" defaultValue="<%=user.getEmail()%>" value="<%=user.getEmail()%>">
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
            <button onclick="saveUser()" class="btn btn-block">Zapisz użytkownika</button>
        </div>
    </form>

</div>

</body>
</html>
