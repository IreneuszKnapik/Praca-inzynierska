<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.model.TaskGroupTemplate" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.TaskGroup" %>
<%@ page import="inz.model.Task" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%@page buffer="8192kb" autoFlush="false" %>

<%
    TaskDao taskDao = new TaskDao();
    List<Task> tasks;
    String testId = request.getParameter("testId");

    tasks = taskDao.getTasksByTest(Integer.parseInt(testId),currentUser.getId());
    System.out.println(tasks.size());

    Integer taskId = Integer.valueOf(request.getParameter("taskId"));
    System.out.print("taskID " + taskId +" \n");


    Task task;
    task = tasks.get(taskId);

    String answer;
    answer = task.getAnswer();
    System.out.print("answer " + answer + "/n");


%>

<script>

    let taskId;

    function saveAnswerWithSubmit () {
        let baseUrl = "index?action=saveAnswerWithSubmit&taskId=<%=task.getId()%>&targetTest=<%=testId%>" + "&targetTask=" + this.taskId+"&user=<%=currentUser.getId()%>";
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }

    function saveAnswer () {
        let baseUrl = "index?action=saveAnswer&taskId=<%=task.getId()%>&targetTest=<%=testId%>" + "&targetTask=" + this.taskId;
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }

    function setTaskId(id){
        this.taskId = id;
    }


</script>

<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>
<p>Zalogowany jako:<%=currentUser.getUsername() %></p>
<p>Id testu:<%=testId%> </p>

<% if(task.equals(null)){%>
<h2 class="text-center">Użytkownik nie ma udostępnionych żadnych testów</h2>
<%
} else{ %>

<div class="testForm">

    <div class="testNav">
        <% for(int i=0;i<tasks.size();i++) { %>
            <button style="display:inline-block;margin:5px;width:50px;height:50px"  class="btn" onclick="setTaskId(<%=i%>);saveAnswer()"><%=i+1%></button>
        <%}%>
    </div>

    <form id="testForm" action="index?action=saveAnswer&taskId=<%=task.getId()%>&targetTest=<%=testId%>&targetTask=0" method="post" enctype="multipart/form-data">

        <table id="groups" class="table table-active">
            <tr>
                <th scope="col" class="text-center">Id</th>
                <th scope="col" class="text-center">Odpowiedź</th>
                <th scope="col" class="text-center">Punkty</th>
            </tr>
            <tr>
                <td>
                    <%=task.getId()%>
                </td>
                <td>
                    <%=task.getDescription()%>
                </td>
                <td>
                    <%=task.getScore()%>
                </td>
            </tr>



        </table>
            <textarea name="answer" class="h-100 w-100" form="testForm">
<%=answer%>
            </textarea>
        <button style="display:inline-block;margin:5px" onclick="setTaskId(<%=taskId%>);saveAnswer()" form ="testForm" class="btn">Zapisz</button>
        <button style="display:inline-block;margin:5px" onclick="setTaskId(<%=taskId%>);saveAnswerWithSubmit()" form ="testForm" class="btn">Wyślij test do oceny</button>

    </form>
</div>
<%}%>




</body>
</html>
