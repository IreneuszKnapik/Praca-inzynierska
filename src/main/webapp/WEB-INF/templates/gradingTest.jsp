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

    tasks = taskDao.getAllTasksByTest(Integer.parseInt(testId));
    System.out.println(tasks.size() + "tasks is empty?: " + tasks.isEmpty());
    Task task = null;
    String answer = "";
    String corrected_answer = "";
    int taskPos = 0;
    int score = 0;
    String codeOutput = null;
    codeOutput = request.getParameter("codeOutput");
    if(!tasks.isEmpty()){
        taskPos= Integer.parseInt(request.getParameter("taskPos"));
        System.out.print("taskId " + taskPos +" \n");



        task = tasks.get(taskPos);

        answer = task.getAnswer();
        corrected_answer = task.getCorrected_answer();


        score = task.getGraded();
        System.out.print("answer " + answer + "/n");
        System.out.print("corrected_answer " + corrected_answer + "/n");
    }


    assert task != null;%>



<html>
<head>
    <style><%@include file="/static/prism/prism.css"%></style>
    <style><%@include file="/static/css/test.css"%></style>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>


<body>
<div style="width:90%" class="container align-items-center justify-content-center">


<p>Id testu:<%=testId%> </p>

<%if(tasks.isEmpty()){%>
<h2 class="text-center">W teście nie zajdują się żadne zadania</h2>
<%
} else{ %>

    <% if(task == null){%>
    <h2 class="text-center">W teście nie znajdują się żadne zadania</h2>
    <%
    } else{ %>

    <div>

        <div class="testNav">
            <% for(int i=0;i<tasks.size();i++) { %>
                <button style="display:inline-block;margin:5px;width:50px;height:50px"  class="btn" onclick="setTaskPos(<%=i%>);saveGrading()"><%=i+1%></button>
            <%}%>
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
                <p>Odpowiedź z testu</p>
                    <pre id="highlightingOriginal">
                        <code id="highlighting-content-originalAnswer" readonly class="language-cpp h-100 w-100" ></code>
                        </pre>
                <textarea id="originalAnswer" spellcheck="false" aria-hidden="true" hidden><%=answer%></textarea>
                <button style="display:inline-block;margin:5px" onclick="testCode()" class="btn">Testuj kod</button>

            </div>
            <% if(codeOutput != null){ %>
            <p>Wynik testowania kodu:</p>
            <textarea  class="h-100 w-100" ><%=codeOutput%></textarea>
            <% } %>
            <p>Poprawiona odpowiedź, komentarze oceniającego</p>
            <div id="answerEditor">
                <pre id="highlighting" aria-hidden="true">
                    <code id="highlighting-content" class="language-cpp h-100 w-100" ><%=corrected_answer%></code>
                </pre>
                <textarea id="editing" name="correctedAnswer" spellcheck="false" oninput="updateAnswer(this.value);sync_scroll(this);" onscroll="sync_scroll(this)" onkeydown="check_tab(this, event);" class="h-100 w-100" form="testForm"><%=corrected_answer%></textarea>
            </div>
            <p>Ilość zdobytych punktów</p>
            <div>
                <input type="number" class="form-control item" name="score" form="testForm" required="required" min="0" max="<%=task.getScore()%>" defaultValue="<%=score%>" value="<%=score%>">
                <button style="display:inline-block;margin:5px" onclick="setTaskPos(<%=taskPos%>);saveGrading()" form ="testForm" class="btn">Zapisz</button>
            </div>
            <p>Ilość zdobytych punktów ze wszsystkich zadań</p>
            <%
                int currSum = 0;
                int totalSum = 0;
                for(int i=0;i<tasks.size();i++) {
                        currSum += tasks.get(i).getGraded();
                        totalSum += tasks.get(i).getScore();
                }
            %>
            <%=currSum%>/<%=totalSum%>

            <p>Ocena za cały test</p>
            <div>
                <input type="number" class="form-control item" name="gradeTest" min="1" max="6" defaultValue="" value="0">
                <button style="display:inline-block;margin:5px" onclick="markTest()" class="btn">Wystaw ocenę za cały test</button>
            </div>

        </form>
    </div>


    <%}%>

<%}%>
</div>
</body>

<script>

    let taskPos;

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

    function setTaskPos(id){
        this.taskPos = id;
    }

    function cleanMarkdown(text){
        return text.replace(new RegExp("&", "g"), "&").replace(new RegExp("<", "g"), "&lt");
    }
    <% if(!tasks.isEmpty()){ %>
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
    function testCode () {
        let baseUrl = "index?action=testCode&taskPos="+this.taskPos+ "&testId=<%=testId%>&taskId=<%=task.getId()%>&target=grading";
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
