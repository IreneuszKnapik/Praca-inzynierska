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
    <title>Title</title>
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

        </tr>
        <tr>
            <td>
<%-- <%=groups.get(i).getName()%> --%>
    <%=groups.get(i).getName()%>
</td>

</tr>
<%}%>
</table>

<%}%>

</body>
</html>
