<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.model.TaskGroupTemplate" %>
<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.model.TestTemplate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    TestDao testDao = new TestDao();


%>


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>
<h2 class="text-center">Dodaj nowy test do bazy</h2>
<div>
    <form id="addTest-form" method="post" onsubmit="" action="index?action=addTestTemplate" >
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" name="name" placeholder="Nazwa testu" required="required">
        </div>
        <div class="form-group">
            <textarea placeholder="Opis testu" name="description" class="h-100 w-100" form="addTest-form"></textarea>
        </div>
        <div class="form-group">
            <input type="datetime-local" class="form-control item" name="due_date"  required="required">
        </div>
        <div class="form-group">
            <input type="number" class="form-control item" name="allowed_attempts" placeholder="Ilośc mozliwych podejść" required="required">
        </div>


        <div class="form-group">
            <button type="submit" class="btn btn-block submit">Dodaj test</button>
        </div>
    </form>

</div>

</body>
</html>
