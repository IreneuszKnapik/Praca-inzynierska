<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.model.*" %>
<%@ page import="inz.dao.UserDao" %>
<%@ page import="inz.dao.GroupDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    GroupDao groupDao = new GroupDao();
    List<Group> groups = null;
    groups = groupDao.getAllGroups();
%>

<script>

    function deleteGroup(groupId){
        if (confirm("Czy na pewno usunąć grupę" + groupId) == true) {
            let baseUrl = "index?action=deleteGroup&groupId="+groupId;
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
</head>
<body>
<%if(groups.isEmpty()){%>
<h2 class="text-center">Żadne grupy nie zostały pobrane z bazy</h2>
<button  class="btn btn-success "><a href="index.jsp?webpage=addGroup">Dodaj grupę</a></button>
<%
} else{ %>
<button  class="btn btn-success "><a href="index.jsp?webpage=addGroup">Dodaj grupę</a></button>
<div class="container p-3">
    <table id="groups" class="table table-active table-condensed">
        <tr>
            <th scope="col" >Id</th>
            <th scope="col" >Nazwa grupy</th>
            <th scope="col" >Opis grupy</th>

        </tr>
        <% for(int i=0;i<groups.size();i++) { %>
        <tr>
            <td>
                <%=groups.get(i).getId()%>
            </td>
            <td>
                <%=groups.get(i).getName()%>
            </td>
            <td>
                <%=groups.get(i).getDescription()%>
            </td>
            <td>
                <button class="btn btn-warning" ><a href="index.jsp?webpage=editGroup&groupId=<%=groups.get(i).getId()%>">Edytuj grupę</a></button>
            </td>
            <td>
                <button class="btn btn-danger" onclick="deleteGroup(<%=groups.get(i).getId()%>)"> Usuń grupę</button>
            </td>

        </tr>

        <%}%>
    </table>
</div>


<%}%>

</body>
</html>
