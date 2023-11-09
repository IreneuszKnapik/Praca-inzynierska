<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page import="inz.dao.UserDao" %>
<%@ page import="inz.dao.GroupDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    GroupDao groupDao = new GroupDao();
    UserDao userDao = new UserDao();

    List<User> users = null;
    users = userDao.getAllUsers();


    Integer groupId = Integer.parseInt(request.getParameter("groupId"));
    Group group = null;
    group = groupDao.getGroupById(groupId);


    List<String> userIDs = groupDao.getUserIDfromGroup(groupId);


%>

<script>

    let userChanges = [];

    function updateUser (event, user_id){

        if (userChanges.includes(user_id)) {
            userChanges.splice(userChanges.indexOf(user_id),1);

        } else {
            userChanges.push(user_id);
        }


    }

    function saveGroup (){

        if(userChanges.length === 0){
            userChanges=[0];
        }
        let baseUrl = "index?action=updateGroup&groupId=<%=group.getId()%>&userChanges="+userChanges;
        console.log(baseUrl);
        let form = document.getElementById("editGroupForm");
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
<h2 class="text-center">Edytuj grupę <%=group.getId()%></h2>
<div>
    <form id="editGroupForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" form="editGroupForm" name="groupName" placeholder="Nazwa grupy" required="required" defaultValue="<%=group.getName()%>" value="<%=group.getName()%>">
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" form="editGroupForm" name="groupDescription"  placeholder="Opis grupy" required="required" defaultValue="<%=group.getDescription()%>" value="<%=group.getDescription()%>">
        </div>




        <table>
            <tr>
                <th scope="col" class="text-center">Id</th>
                <th scope="col" class="text-center">Użytkownik</th>
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
                    <input class="form-control item" type="checkbox" name="enabledUser" onchange="updateUser(event,<%=users.get(i).getId()%>)" <% if (userIDs.contains(String.valueOf(users.get(i).getId()))) {%>checked<%}%>>
                </td>
            </tr>
            <%}%>
        </table>

        <div class="form-group">
            <button onclick="saveGroup()" class="btn btn-block">Zapisz grupę</button>
        </div>
    </form>

</div>

</body>
</html>
