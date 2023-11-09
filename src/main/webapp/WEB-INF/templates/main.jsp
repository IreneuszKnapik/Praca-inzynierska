<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%

    GroupDao groupDao = new GroupDao();
    List<Group> groups=null;
    groups = groupDao.getGroupsByUserId(currentUser.getId());
%>


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>

<%if(groups.isEmpty()){%>
<h2 class="text-center">Użytkownik nie należy do żadnej grupy</h2>
<%
} else{ %>

<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Nazwa grupy</th>
    </tr>
    <% for(int i=0;i<groups.size();i++) { %>
        <tr>
            <td>
                <%=groups.get(i).getId()%>
            </td>
            <td>
                <%=groups.get(i).getName()%>
            </td>

        </tr>
<%}%>
</table>

<%}%>
<%if(currentUser.getType() > 2){%>
<div class="form-group">
    <button type="submit" class="btn btn-block register-button submit"><a href="index.jsp?webpage=users">Zarządzanie uzytkownikami</a></button>
</div>
<div class="form-group">
    <button type="submit" class="btn btn-block register-button submit"><a href="index.jsp?webpage=groups">Zarządzanie grupami</a></button>
</div>
<%}%>
<%if(currentUser.getType() > 1){%>
<div class="form-group">
    <button type="submit" class="btn btn-block register-button submit"><a href="index.jsp?webpage=testTemplates">Szablony testów</a></button>
</div>
<div class="form-group">
    <button type="submit" class="btn btn-block register-button submit"><a href="index.jsp?webpage=taskTemplates">Szablony zadań</a></button>
</div>
<div class="form-group">
    <button type="submit" class="btn btn-block register-button submit"><a href="index.jsp?webpage=gradingTests">Ocenianie testów</a></button>
</div>
<%}%>

<div class="form-group">
    <button type="submit" class="btn btn-block register-button submit"><a href="index.jsp?webpage=tests">Testy</a></button>
</div>

</body>
</html>
