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

    window.onload = function (){
        let loadPrism = document.createElement("script");
        loadPrism.type = 'text/javascript';
        loadPrism.src = "${pageContext.request.contextPath}/static/prism/prism.js";
        document.getElementsByTagName("head")[0].appendChild(loadPrism);
        let editing = document.querySelector("#editing");
        updateAnswer(editing.value);
    }

    function saveAnswerWithSubmit () {
        let baseUrl = "index?action=saveAnswerWithSubmit&taskId=<%=task.getId()%>&test=<%=testId%>"+"&user=<%=currentUser.getId()%>"+"&test=<%=testId%>";
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }

    function saveAnswer () {
        let baseUrl = "index?action=saveAnswer&user=<%=currentUser.getId()%>&taskId=<%=task.getId()%>&targetTest=<%=testId%>" + "&targetTask=" + this.taskId;
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }

    function setTaskId(id){
        this.taskId = id;
    }

    function cleanMarkdown(text){
        return text.replace(new RegExp("&", "g"), "&").replace(new RegExp("<", "g"), "&lt");
    }

    function updateAnswer(text) {
        let result_element = document.querySelector("#highlighting-content");

        if(text[text.length-1] == "\n") {
            text += " ";
        }
        text = cleanMarkdown(text);
        result_element.innerHTML= text
        Prism.highlightElement(result_element);

    }
    function sync_scroll(element) {
        let result_element = document.querySelector("#highlighting");
        result_element.scrollTop = element.scrollTop;
        result_element.scrollLeft = element.scrollLeft;
    }



    function check_tab(element, event) {
        let code = element.value;
        if(event.key == "Tab") {
            event.preventDefault(); // stop normal
            let before_tab = code.slice(0, element.selectionStart);
            let after_tab = code.slice(element.selectionEnd, element.value.length);
            let cursor_pos = element.selectionEnd + 1;
            element.value = before_tab + "\t" + after_tab;
            element.selectionStart = cursor_pos;
            element.selectionEnd = cursor_pos;
            updateAnswer(element.value);
        }
    }

</script>

<html>
<head>
    <style><%@include file="/static/prism/prism.css"%></style>
    <style><%@include file="/static/css/test.css"%></style>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>


<p>Zalogowany jako:<%=currentUser.getUsername() %></p>
<p>Id testu:<%=testId%> </p>

<% if(task.equals(null)){%>
<h2 class="text-center">W teście nie znajdują się żadne zadania</h2>
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
        <div id="answerEditor">
            <pre id="highlighting" aria-hidden="true">
                <code id="highlighting-content" class="language-cpp h-100 w-100" ></code>
            </pre>
            <textarea id="editing" name="answer" spellcheck="false" oninput="updateAnswer(this.value);sync_scroll(this);" onscroll="sync_scroll(this)" onkeydown="check_tab(this, event);" class="h-100 w-100" form="testForm">
<%=answer%>
            </textarea>
        </div>


        <button style="display:inline-block;margin:5px" onclick="setTaskId(<%=taskId%>);saveAnswerWithSubmit()" form ="testForm" class="btn">Wyślij test do oceny</button>

    </form>
</div>
<%}%>



</body>


</html>
