<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.model.TaskGroupTemplate" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.TaskGroup" %>
<%@ page import="inz.model.Task" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%@page buffer="8192kb" autoFlush="false" %>

<%
    TaskDao taskDao = new TaskDao();
    List<Task> tasks;
    String testId = request.getParameter("testId");


    tasks = taskDao.getTasksByTest(Integer.parseInt(testId),currentUser.getId());
    System.out.println(tasks.size());

    int taskPos = 0;
    taskPos = Integer.parseInt(request.getParameter("taskPos"));

    Task task;
    task = tasks.get(taskPos);

%>

<script>

    let taskId;


    window.onload = function (){

        let loadPrism = document.createElement("script");
        loadPrism.type = 'text/javascript';
        loadPrism.src = "${pageContext.request.contextPath}/static/prism/prism.js";
        document.getElementsByTagName("head")[0].appendChild(loadPrism);
        let originalCodeText = document.querySelector("#originalCodeText").value;
        document.querySelector("#originalCode").innerHTML = "\n" + cleanMarkdown(originalCodeText)
        let correctedCodeText = document.querySelector("#correctedCodeText").value;
        document.querySelector("#correctedCode").innerHTML = "\n" + cleanMarkdown(correctedCodeText)
        Prism.highlightAll();

    }

    function cleanMarkdown(text){
        return text.replace(new RegExp("&", "g"), "&").replace(new RegExp("<", "g"), "&lt");
    }



</script>

<html>
<head>
    <style><%@include file="/static/prism/prism.css"%></style>
    <style><%@include file="/static/css/test.css"%></style>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>

<% if(task.equals(null)){%>
<h2 class="text-center">W teście nie znajdują się żadne zadania</h2>
<%
} else{ %>

<div>


    <div class = "w-75 container justify-content-center">
        <div class="testNav">
            <p class="h2">Nawigacja</p>
            <% for(int i=0;i<tasks.size();i++) {
                if(i == taskPos){
            %>
            <button style="display:inline-block; ;width:50px;height:50px"  class="btn btn-info active" onclick="location.href = 'index.jsp?webpage=viewTest&testId=<%=testId%>&taskPos=<%=i%>'"><%=i+1%></button>
            <%
            }
            else{

            %>
            <button style="display:inline-block; ;width:50px;height:50px"  class="btn" onclick="location.href = 'index.jsp?webpage=viewTest&testId=<%=testId%>&taskPos=<%=i%>'"><%=i+1%></button>

            <%
                    }
                }%>
        </div>
        <form id="testForm" action="index?action=saveAnswer&taskId=<%=task.getId()%>&targetTest=<%=testId%>&taskPos=0" method="post" enctype="multipart/form-data">

            <table id="groups" class="table table-active">
                <thead>
                <th scope="col" class="text-center">Zdobyte punkty: <%=task.getGraded()%>/<%=task.getScore()%></th>
                </thead>
            </table>
            <table class="table table-active">
                <thead>
                <th scope="col" class="text-center">Opis zadania</th>
                </thead>
                <tbody>
                <tr>
                    <td scope="row"><%=task.getDescription()%></td>
                </tr>
                </tbody>
            </table>
            <p class="h2">Udzielona odpowiedź</p>
            <div style="width:100%">
                <pre style="width:100%;margin-left:0">
                    <code id="originalCode" class="language-cpp" ><%=task.getAnswer()%></code>
                </pre>
                <textarea hidden id="originalCodeText"><%=task.getAnswer()%></textarea>
            </div>
            <p class="h2">Poprawiona odpowiedź, komentarze</p>
            <div style="width:100%">
                <pre style="width:100%">
                    <code id="correctedCode" class="language-cpp" ></code>
                </pre>
                <textarea hidden id="correctedCodeText"><%=task.getCorrected_answer()%></textarea>
            </div>
        </form>
</div>
<%}%>



</body>


</html>
