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

    String codeOutput = null;
    codeOutput = request.getParameter("codeOutput");

    tasks = taskDao.getTasksByTest(Integer.parseInt(testId),currentUser.getId());
    System.out.println(tasks.size());

    int taskPos = 0;
    taskPos = Integer.parseInt(request.getParameter("taskPos"));

    Task task;
    task = tasks.get(taskPos);

    String answer;
    answer = task.getAnswer();
    System.out.print("answer " + answer + "/n");


%>

<script>

    let taskId;
    let ws;
    let newLineWatchdog;

    function setNewLineWatchdog(arg){
        this.newLineWatchdog = arg;
    }
    function getNewLineWatchdog(){
        return this.newLineWatchdog;
    }

    function getWebSocket(){
        return this.ws;
    }
    function setWebSocket(ws){
        this.ws = ws;
    }


    window.onload = function (){
        setWaitingForOutput(false);

        let loadPrism = document.createElement("script");
        loadPrism.type = 'text/javascript';
        loadPrism.src = "${pageContext.request.contextPath}/static/prism/prism.js";
        document.getElementsByTagName("head")[0].appendChild(loadPrism);

        let editing = document.querySelector("#editing");
        updateAnswer(editing.value);
        sync_scroll(editing)

    }

    function testCodeSocket() {
        if ("WebSocket" in window) {

            document.querySelector("#testingInterface").removeAttribute("hidden");
            document.querySelector("#testOutput").innerHTML = "";
            // Let us open a web socket

            let ws = new WebSocket("ws://localhost:5057/socket");
            setWebSocket(ws)

            ws.onopen = function () {


                // Web Socket is connected, send data using send()

                let inputCode = document.querySelector("#editing").innerHTML;
                console.log(inputCode);

                console.log("sending header request");
                ws.send("action=testCodeCompile&testId=<%=testId%>&taskId=<%=task.getId()%>&"+inputCode);


            }
            ws.onmessage = function (evt) {

                let received_msg = evt.data;
                document.querySelector("#testOutput").innerHTML +=received_msg;
                document.querySelector("#testOutput").focus();
                console.log("Message is received...: "+ received_msg);
                setNewLineWatchdog(true)
            };
            ws.onclose = function () {

                // websocket is closed.
                console.log("Connection is closed...");
            };
        }

    }



    function sendInputToTest(){
        let testInput = document.querySelector("#testInput");
        console.log(testInput.value);
        if(getWebSocket() != null){
            getWebSocket().send(testInput.value);
            document.querySelector("#testOutput").innerHTML
            if(getNewLineWatchdog()){
                document.querySelector("#testOutput").innerHTML += "\n"
            }
            document.querySelector("#testOutput").innerHTML += ">" + testInput.value +"\n";
            setNewLineWatchdog(false);
            testInput.value ="";
        }
    }

    function saveAnswerWithSubmit () {
        let baseUrl = "index?action=saveAnswerWithSubmit&taskId=<%=task.getId()%>&test=<%=testId%>"+"&user=<%=currentUser.getId()%>"+"&test=<%=testId%>";
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }

    function saveAnswer () {
        let baseUrl = "index?action=saveAnswer&user=<%=currentUser.getId()%>&taskId=<%=task.getId()%>&targetTest=<%=testId%>" + "&taskPos=" + this.taskPos;
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }
    function testCode () {
        let baseUrl = "index?action=testCode&testId=<%=testId%>&taskId=<%=task.getId()%>&target=testing&taskPos="+this.taskPos;
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }

    function setTaskPos(pos){
        this.taskPos = pos;
    }
    function getTaskPos(){
        return this.taskPos;
    }

    function cleanMarkdown(text){
        return text.replace(new RegExp("&", "g"), "&").replace(new RegExp("<", "g"), "&lt");
    }

    function updateAnswer(text) {

        let textarea = document.querySelector("#editing");
        textarea.innerHTML=text;

        let result_element = document.querySelector("#highlighting-content");
        text = cleanMarkdown(text);
        result_element.innerHTML=text;



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

    let waitingForOutput;

    function getWaitingForOutput(){
        return this.waitingForOutput;
    }

    function setWaitingForOutput(val){
        this.waitingForOutput = val;
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
            <% for(int i=0;i<tasks.size();i++) {
                if(i == taskPos){
            %>
            <button style="display:inline-block;margin:5px;width:50px;height:50px"  class="btn btn-info active" onclick="setTaskPos(<%=i%>);saveAnswer()"><%=i+1%></button>
            <%
            }
            else{

            %>
            <button style="display:inline-block;margin:5px;width:50px;height:50px"  class="btn" onclick="setTaskPos(<%=i%>);saveAnswer()"><%=i+1%></button>

            <%
                    }
                }%>
            <div class="container w-25">
                <button style="display:inline-block;margin:5px;color:black" onclick="setTaskPos(<%=taskPos%>);saveAnswerWithSubmit()" form ="testForm" class="btn btn-danger" >Wyślij test do oceny</button>
            </div>
        </div>
        <form id="testForm" action="index?action=saveAnswer&taskId=<%=task.getId()%>&targetTest=<%=testId%>&taskPos=0" method="post" enctype="multipart/form-data">

            <table id="groups" class="table table-active">
                <thead>
                <th scope="col" class="text-right">Możliwe punkty do zdobycia: <%=task.getScore()%></th>
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

            <div id="answerEditor" style="width:100%">
                <pre id="highlighting" style="width:100%" aria-hidden="true">
                    <code id="highlighting-content" class="language-cpp" ></code>
                </pre>
                <textarea id="editing" name="answer" style="width:100%" spellcheck="false" oninput="updateAnswer(this.value);sync_scroll(this);" onscroll="sync_scroll(this)" onkeydown="check_tab(this, event);" form="testForm"><%=answer%></textarea>
            </div>
        </br>
        </form>
        <div class="container w-25 inline-block mb-4 mt-4">
            <button type="button" class="btn  btn-success" style="color:black" onclick="testCodeSocket()">Testuj kod</button>
        </div>
        <div id="testingInterface" hidden="true">


            <div class="container justify-content-center">

                <p id="asyncCodeTestCompile" class="h2">Wynik kompilacji kodu</p>
                <textarea readonly  style="resize:none;min-height:100px" class="w-100 form-control" id="testOutput"></textarea>
                </br>

                <p class="container justify-content-center" class="h3" >Wprowadzanie zmiennych na wejście programu</p>
                <textarea  class="h-100 w-100 form-control" id="testInput"></textarea>
            </div>
        </br>
        <div class="container w-25">
            <button type="button" id="sendInput" class="btn btn-warning" style="color:black" onclick="sendInputToTest()" >Wyślij dane wejściowe do programu</button>
        </div>
        </br>
        </div>

    </div>
</div>
<%}%>



</body>


</html>
