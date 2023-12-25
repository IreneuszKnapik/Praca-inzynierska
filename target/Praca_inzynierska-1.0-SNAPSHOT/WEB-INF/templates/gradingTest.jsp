        <%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.model.TaskGroupTemplate" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.TaskGroup" %>
<%@ page import="inz.model.Task" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%@page buffer="8192kb" autoFlush="false" %>

<%
    TaskDao taskDao = new TaskDao();
    List<Task> tasks;
    String testId = request.getParameter("testId");

    tasks = taskDao.getAllTasksByTest(Integer.parseInt(testId));
    System.out.println(tasks.size() + "tasks is empty?: " + tasks.isEmpty());
    Task task = null;
    String answer = "";
    String corrected_answer = "";
    int taskPos = 0;
    int score = 0;

    ArrayList<String> testCasesInputs = null;
    ArrayList<String> testCasesOutputs = null;
    if (!tasks.isEmpty()) {
        taskPos = Integer.parseInt(request.getParameter("taskPos"));
        System.out.print("taskId " + taskPos + " \n");


        task = tasks.get(taskPos);
        answer = task.getTaskCodeHeader() + "\n";
        answer += task.getTaskCodeBody() + "\n";
        answer += task.getAnswer();

        corrected_answer = task.getCorrected_answer();


        score = task.getGraded();
        System.out.print("answer " + answer + "/n");
        System.out.print("corrected_answer " + corrected_answer + "/n");

        testCasesInputs = new ArrayList<>();
        testCasesOutputs = new ArrayList<>();
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
        testCasesInputs.add("2 2");
        testCasesOutputs.add("4");
        testCasesInputs.add("3 3");
        testCasesOutputs.add("6");
    }


    assert task != null;%>



<html>
<head>
    <style><%@include file="/static/prism/prism.css"%></style>
    <style><%@include file="/static/css/test.css"%></style>
    <title><%=currentUser.getUsername()%> - C++ testing portal</title>

</head>


<body>
<div style="width:90%" class="container align-items-center justify-content-center">

<%if (tasks.isEmpty()) {%>
<h2 class="text-center">W teście nie zajdują się żadne zadania</h2>
<%
} else { %>

    <% if (task == null) {%>
    <h2 class="text-center">W teście nie znajdują się żadne zadania</h2>
    <%
    } else { %>

    <div>

        <div class="testNav">
            <p class="h2">Nawigacja</p>
            <p>Odpowiedzi zapisują się automatycznie przy przechodzeniu między zadaniami</p>
            <% for (int i = 0; i < tasks.size(); i++) {
                if (i == taskPos) {
            %>
            <button style="display:inline-block; ;width:50px;height:50px"  class="btn btn-info active" onclick="setTaskPos(
                <%=i%>);saveGrading()"><%=i + 1%></button>
            <%
            } else {

            %>
            <button style="display:inline-block; ;width:50px;height:50px"  class="btn" onclick="setTaskPos(<%=i%>
                    );saveGrading()"><%=i + 1%></button>

            <%
                    }
                }%>

        </div>

        <form id="testForm" action="index?action=gradeTask&taskId=<%=task.getId()%>&targetTest=<%=testId%>&targetTask=0" method="post" enctype="multipart/form-data">

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
                        <%=task.getGraded()%>/<%=task.getScore()%>
                    </td>
                </tr>



            </table>
            <div>
                <p class="h2">Odpowiedź z testu</p>
                    <pre id="highlightingOriginal" class="PrismElement">
                        <code id="highlighting-content-originalAnswer" readonly class="language-cpp h-100 w-100 PrismElement" ></code>
                        </pre>
                <textarea id="originalAnswer"  class="PrismElement" spellcheck="false" aria-hidden="true" hidden>
                    <%=answer%></textarea>
                <button style="display:inline-block; " onclick="testCodeSocket()" class="btn btn-success">Testuj kod manualnie</button>
                <button style="display:inline-block; " onclick="testCodeAuto()" class="btn btn-info">Testuj kod automatycznie</button>

            </div>
        </br>
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
            <div id="autoTestingInterface" hidden="true">
                <div id="autoTestingInterfaceArea" class="container justify-content-center">

                    <p class="h2">Wynik kompilacji kodu - automatyczne testowanie</p>

                </div>
            </div>

            <p class="h2">Poprawki do odpowiedzi, komentarze oceniającego</p>
            <div id="answerEditor">
                <pre id="highlighting"  class="PrismElement" aria-hidden="true">
                    <code id="highlighting-content" class="language-cpp PrismElement h-100 w-100" ><%=corrected_answer%></code>
                </pre>
                <textarea id="editing" class="PrismElement" name="correctedAnswer" spellcheck="false" oninput="updateAnswer(this.value);sync_scroll(this);" onscroll="sync_scroll(this)" onkeydown="check_tab(this, event);" class="h-100 w-100" form="testForm">
                    <%=corrected_answer%></textarea>
            </div>

            <div>
                <p class="h2">Ilość zdobytych punktów</p>
                <input style="width:100px" type="number" class="form-control item" name="score" form="testForm" required="required" min="0" max="
                    <%=task.getScore()%>" defaultValue="<%=score%>" value="<%=score%>">
                </br>
                <button style="display:inline-block; " onclick="setTaskPos(<%=taskPos%>);saveGrading()" form ="testForm" class="btn btn-warning">Zapisz punktację za zadanie</button>
            </div>

            <p class="h2">Ilość zdobytych punktów ze wszsystkich zadań:
            <%
                int currSum = 0;
                int totalSum = 0;
                for (int i = 0; i < tasks.size(); i++) {
                        currSum += tasks.get(i).getGraded();
                        totalSum += tasks.get(i).getScore();
                }
            %><%=currSum%>/<%=totalSum%></p>
            <div>
                <p class="h2">Ocena za cały test</p>
                <input type="number" class="form-control item" name="gradeTest" style="width:100px" min="1" max="6" defaultValue="" value="0">
            </br>
            <button style="display:inline-block; " onclick="markTest()" class="btn btn-danger">Wystaw ocenę za cały test</button>
            </div>


        </form>
    </div>


    <%}%>

    <%}%>
</div>
</body>

<script>

    let taskPos;
    let ws;
    let newLineWatchdog;


    window.onload = function (){
        setTaskPos(0);
        let loadPrism = document.createElement("script");
        loadPrism.type = 'text/javascript';
        loadPrism.src = "${pageContext.request.contextPath}/static/prism/prism.js";
        document.getElementsByTagName("head")[0].appendChild(loadPrism);

        let originalAnswer = document.querySelector("#originalAnswer");
        styleOriginalAnswer(originalAnswer.value);

        let editing = document.querySelector("#editing");
        updateAnswer(editing.value);






    }

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

    function testCodeAuto() {
        let testingDiv = document.querySelector("#autoTestingInterfaceArea");
        testingDiv.innerHTML ="";
        <% for (int i = 0; i < testCasesInputs.size(); i++) { %>

        if ("WebSocket" in window) {
            let outputArea = document.createElement("div");
            document.querySelector("#autoTestingInterface").removeAttribute("hidden");
            // Let us open a web socket

            let ws = new WebSocket("ws://localhost:5057/socket");
            setWebSocket(ws)

            ws.onopen = function () {


                // Web Socket is connected, send data using send()

                let inputCode = document.querySelector("#originalAnswer").innerHTML;
                console.log(inputCode);



                outputArea.style.overflow="hidden";
                outputArea.classList.add("card-text");
                outputArea.style.width = "18rem";



                let outputCard = document.createElement("div");
                outputCard.classList.add("card");
                outputCard.classList.add("alert");
                outputCard.classList.add("alert-success");

                let outputHeader = document.createElement("div");
                outputHeader.classList.add("card-title");
                outputHeader.classList.add("h4");
                outputHeader.innerHTML += "Argumenty wejściowe: "+ "<%=testCasesInputs.get(i)%>" + "\n";
                outputCard.appendChild(outputHeader);


                testingDiv.appendChild(outputCard);
                outputCard.appendChild(outputArea);

                console.log("sending header request");
                ws.send("action=testCodeCompile&testId=<%=testId%>&taskId=<%=task.getId()%>&"+inputCode);
                ws.send("<%=testCasesInputs.get(i)%>");



            }
            ws.onmessage = function (evt) {

                let received_msg = evt.data;
                outputArea.innerHTML +=received_msg;
                outputArea.focus();
                console.log("Message is received...: "+ received_msg);
                setNewLineWatchdog(true)
            };
            ws.onclose = function () {

                // websocket is closed.
                console.log("Connection is closed...");
            };

        }
        <% } %>

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

                let inputCode = document.querySelector("#originalAnswer").innerHTML;
                console.log(inputCode);

                console.log("sending header request");
                ws.send("action=testCodeCompile&testId=<%=testId%>&taskId=<%=task.getId()%>&"+inputCode);


            }
            ws.onmessage = function (evt) {

                let received_msg = evt.data;
                document.querySelector("#testOutput").innerHTML +=received_msg;
                document.querySelector("#testOutput").focus();
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

    function setTaskPos(id){
        this.taskPos = id;
    }
    function getTaskPos(){
        return this.taskPos;
    }

    function cleanMarkdown(text){
        return text.replace(new RegExp("&", "g"), "&").replace(new RegExp("<", "g"), "&lt");
    }
    <% if (!tasks.isEmpty()) { %>
    function saveGrading () {
        let baseUrl = "index?action=gradeTask&taskPos="+this.taskPos+"&testId=<%=testId%>&taskId=<%=task.getId()%>";
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }

    function markTest () {
        let baseUrl = "index?action=markTest&testId=<%=testId%>";
        let form = document.getElementById("testForm");
        form.action = baseUrl;
        form.submit();
    }
    <%}%>

    function updateAnswer(text) {

        console.log("Styling new answer");
        let result_element = document.querySelector("#highlighting-content");

        if(text[text.length-1] === "\n") {
            text += " ";
        }
        text = cleanMarkdown(text);
        result_element.innerHTML= text;
        Prism.highlightAll();
    }
    function styleOriginalAnswer(text) {

        console.log("Styling Original answer");
        let result_element = document.querySelector("#highlighting-content-originalAnswer");

        if(text[text.length-1] === "\n") {
            text += " ";
        }
        text = cleanMarkdown(text);
        result_element.innerHTML= text;

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


</html>
