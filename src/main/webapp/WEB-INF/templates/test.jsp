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
                document.querySelector("#asyncCodeTestOutput").innerHTML +=received_msg;
                console.log("Message is received...: "+ received_msg);
            };
            ws.onclose = function () {

                // websocket is closed.
                console.log("Connection is closed...");
            };
        }

    }

    function sendInputToTest(){
        let testInput = document.querySelector("#testInput");

        if(getWebSocket() != null){
            getWebSocket().send(testInput.value);
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



    async function testCodeAsync(){
        document.querySelector("#asyncCodeTestOutput").innerHTML ="";
        event.preventDefault();
        console.log("testCodeAsync");
        let inputCode = document.querySelector("#editing").innerHTML;
        console.log(inputCode);
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                document.querySelector("#asyncCodeTestCompile").innerHTML = this.responseText;
                if(this.responseText.includes(".exe")){
                    testCodeRun(this.responseText,"")
                }
            }
        };
        let request = "index?action=testCodeCompile&testId=<%=testId%>&taskId=<%=task.getId()%>";
        console.log(request);
        xmlhttp.open("POST",request, true);
        xmlhttp.send(inputCode);

    }

    function sleep (time) {
        return new Promise((resolve) => setTimeout(resolve, time));
    }

    let waitingForOutput;

    function getWaitingForOutput(){
        return this.waitingForOutput;
    }

    function setWaitingForOutput(val){
        this.waitingForOutput = val;
    }

    async function testCodeRun(executable,input){
        console.log("runCodeAsync");
        event.preventDefault();
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                if(this.responseText === "created" ){
                    document.querySelector("#asyncCodeTestCompile").innerHTML = executable + " running";

                    /*
                    let finished = false;
                    while(!finished){
                        sleep(500).then(() => {
                            if(!getWaitingForOutput){
                                setWaitingForOutput(true);
                                testCodeOutput(executable);
                                testCodeInput(executable,2);

                            }

                        })
                    }

*/
                            if(getWaitingForOutput() === false){
                                setWaitingForOutput(true);
                                testCodeIO(executable,2)
                            }
                }


            }
        }
        let request = "index?action=testCodeRun&execName="+executable;
        console.log(request);
        xmlhttp.open("POST",request, true);
        xmlhttp.send(input);

    }
    function testCodeIO(executable,argument = ""){

        document.querySelector("#asyncCodeTestInput").value = '';
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                setWaitingForOutput(false);
                console.log(this.responseText);
                document.querySelector("#asyncCodeTestOutput").innerHTML += this.responseText;
                document.querySelector("#processArgument").addEventListener('click',function handler() {
                    console.log("processArgument");

                        this.removeEventListener("click", handler);
                        testCodeIO(executable,document.querySelector("#asyncCodeTestInput").value)


                })
            }
        };
        let request = "index?action=testCodeIO&execName="+executable+"&argument="+argument;
        console.log(request);
        xmlhttp.open("POST",request, true);
        xmlhttp.send();
    }



    function testCodeOutput(executable,input){
        console.log("runCodeOutput");
        event.preventDefault();
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                setWaitingForOutput(false);
                document.querySelector("#asyncCodeTestOutput").innerHTML += this.responseText;
            }
        };
        let request = "index?action=testCodeOutput&execName="+executable;
        console.log(request);
        xmlhttp.open("POST",request, true);
        xmlhttp.send(input);
    }

    function testCodeInput(executable,input){
        console.log("runCodeInput");
        event.preventDefault();
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {

            }
        };
        let request = "index?action=testCodeInput&execName="+executable+"&argument="+input;
        console.log(request);
        xmlhttp.open("POST",request, true);
        xmlhttp.send(input);
    }



</script>

<html>
<head>
    <style><%@include file="/static/prism/prism.css"%></style>
    <style><%@include file="/static/css/test.css"%></style>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>



<p>Id testu:<%=testId%> </p>

<% if(task.equals(null)){%>
<h2 class="text-center">W teście nie znajdują się żadne zadania</h2>
<%
} else{ %>

<div class="testForm">

    <div class="testNav">
        <% for(int i=0;i<tasks.size();i++) { %>
            <button style="display:inline-block;margin:5px;width:50px;height:50px"  class="btn" onclick="setTaskPos(<%=i%>);saveAnswer()"><%=i+1%></button>
        <%}%>
    </div>

    <form id="testForm" action="index?action=saveAnswer&taskId=<%=task.getId()%>&targetTest=<%=testId%>&taskPos=0" method="post" enctype="multipart/form-data">

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
            <textarea id="editing" name="answer" spellcheck="false" oninput="updateAnswer(this.value);sync_scroll(this);" onscroll="sync_scroll(this)" onkeydown="check_tab(this, event);" class="h-100 w-100" form="testForm"><%=answer%></textarea>
        </div>
        <div>
            <button type="button" onclick="testCodeSocket()">Testuj kod</button>
        <% if(codeOutput != null){ %>
        <p>Wynik testowania kodu:</p>
        <textarea  class="h-100 w-100" ><%=codeOutput%></textarea>
        <% } %>
        </div>
        <p id="asyncCodeTestCompile"></p>
        <p>Wynik kompilacji kodu</p>
        <textarea  class="h-100 w-100" id="asyncCodeTestOutput"></textarea>
        <p>Oczekiwanie na wartośc wejściową od użytkownika</p>
        <textarea  class="h-100 w-100" id="testInput"></textarea></br>
        <button type="button" id="processArgument" class="btn">Wprowadź nowy argument</button>

        <button type="button" id="sendInput" class="btn" onclick="sendInputToTest()" >Wyślij wiadomość</button>



        <button style="display:inline-block;margin:5px" onclick="setTaskPos(<%=taskPos%>);saveAnswerWithSubmit()" form ="testForm" class="btn">Wyślij test do oceny</button>

    </form>
</div>
<%}%>



</body>


</html>
