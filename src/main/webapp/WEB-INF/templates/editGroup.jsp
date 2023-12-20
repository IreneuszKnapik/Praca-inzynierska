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
    <style>
        td > p {
            word-break: break-all;
        }
    </style>
</head>
<body>

<h2 class="text-center">Edytuj grupę:  <%=group.getId()%></h2>
<div style="width:90%" class="container align-items-center justify-content-center">
    <form id="editGroupForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <p class="h2">Nazwa grupy</p>
        <div class="form-group">
            <input type="text" class="form-control item" form="editGroupForm" name="groupName" placeholder="Nazwa grupy" required="required" defaultValue="<%=group.getName()%>" value="<%=group.getName()%>">
        </div>
        <p class="h2">Opis grupy</p>
        <div class="form-group">
            <input type="text" class="form-control item" form="editGroupForm" name="groupDescription"  placeholder="Opis grupy" required="required" defaultValue="<%=group.getDescription()%>" value="<%=group.getDescription()%>">
        </div>
        <p class="h2" >Przypisanie użytkowników do grupy</p>
        <div>
            <% for(int i=0;i<users.size();i++) { %>
            <div class="checkbox-inline" style="border-right: 1px solid;padding-right:5px;margin-bottom:5px">
                <input class="form-check-input " type="checkbox" name="enabledUser" id="checkbox<%=i%>>"onchange="updateUser(event,<%=users.get(i).getId()%>)" <% if (userIDs.contains(String.valueOf(users.get(i).getId()))) {%>checked<%}%>>
                <label class="form-check-label" for="checkbox<%=i%>"><%=users.get(i).getUsername()%></label>
            </div>
            <%}%>

        </div>
    </br>
        <button onclick="saveGroup()" class="btn btn-success">Zapisz grupę</button>



    </form>

</div>

</body>
</html>
