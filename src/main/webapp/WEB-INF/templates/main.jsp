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



<div class="container w-75 p-3">
    <div class="row">
        <nav class="col-sm-3">
            <ul class="nav nav-pills nav-stacked" data-spy="affix">
                <%if(currentUser.getType() > 2){%>
                <li><a href="index.jsp?webpage=users">Zarządzanie uzytkownikami</a></li>
                <li><a href="index.jsp?webpage=groups">Zarządzanie grupami</a></li>
                <%}%>
                <%if(currentUser.getType() > 1){%>
                    <li><a href="index.jsp?webpage=testTemplates">Szablony testów</a></li>
                    <li><a href="index.jsp?webpage=taskTemplates">Szablony zadań</a></li>
                    <li><a href="index.jsp?webpage=gradingTests">Ocenianie testów</a></li>
                <%}%>
                <li><a href="index.jsp?webpage=tests">Testy</a></li>
            </ul>
        </nav>
        <div class="col-sm-9">
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
            <h1>Some text to enable scrolling</h1>
        </div>
    </div>
</div>
<div class="container">
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
</div>

</body>
</html>
