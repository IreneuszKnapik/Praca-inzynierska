<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.model.*" %>
<%@ page import="inz.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    UserDao userDao = new UserDao();
    List<User> users = null;
    users = userDao.getAllUsers();
%>

<script>

    function deleteUser(userId){
        if (confirm("Czy na pewno usunąć użytkownika" + userId) == true) {
            let baseUrl = "index?action=deleteUser&userId="+userId;
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
    <style>
        td > p {
            word-break: break-all;
        }
    </style>
</head>
<body>
<div style="width:90%" class="container align-items-center justify-content-center">
<%if(users.isEmpty()){%>
<h2 class="text-center">Żadni użytkownicy nie zostali pobrani z bazy</h2>
<button  class="btn btn-success"><a href="index.jsp?webpage=addUser">Dodaj użytkownika</a></button>
<%
} else{ %>
<p class ="h1 text-center">Zarządzanie użytkownikami</p>
<table id="groups" class="table table-active word-break table-dark">
    <thead>
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Username</th>
        <th scope="col" class="text-center">Adres email</th>
        <th scope="col" class="text-center">Typ</th>
        <th scope="col" class="text-center" ><button  class="btn btn-success"><a href="index.jsp?webpage=addUser">Dodaj użytkownika</a></button></th>
    </tr>
    </thead>
    <tbody>
    <% for(int i=0;i<users.size();i++) { %>
    <tr>
        <td><p class="text-center"><%=users.get(i).getId()%></p></td>
        <td><p class="text-center"><%=users.get(i).getUsername()%></p></td>
        <td><p class="text-center"><%=users.get(i).getEmail()%></p></td>
        <td><p class="text-center"><%=users.get(i).getType()%></p></td>
        <td><p class="text-center"><button class="btn btn-warning "><a href="index.jsp?webpage=editUser&userId=<%=users.get(i).getId()%>">Edytuj użytkownika</a></button></p></td>
        <td><p class="text-center"> <button class="btn btn-danger" onclick="deleteUser(<%=users.get(i).getId()%>)">Usuń użytkownika</button></p></td>
    </tr>

    <%}%>
    </tbody>

</table>

<%}%>
</div>
</body>
</html>
