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


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<%if(users.isEmpty()){%>
<h2 class="text-center">Żadni użytkownicy nie zostali pobrani z bazy</h2>
<button  class="btn btn-block "><a href="index.jsp?webpage=addUser">Dodaj użytkownika</a></button>
<%
} else{ %>
<button  class="btn btn-block "><a href="index.jsp?webpage=addUser">Dodaj użytkownika</a></button>

<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Username</th>
        <th scope="col" class="text-center">Adres email</th>
        <th scope="col" class="text-center">Typ</th>

    </tr>
    <% for(int i=0;i<users.size();i++) { %>
        <tr>
            <td>
                <%=users.get(i).getId()%>
            </td>
            <td>
                <%=users.get(i).getUsername()%>
            </td>
            <td>
                <%=users.get(i).getEmail()%>
            </td>

            <td>
                <%=users.get(i).getType()%>
            </td>


        </tr>

<%}%>
</table>

<%}%>

</body>
</html>