<%@ page import="inz.dao.GroupDao" %>

<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TaskTemplateDao" %>

<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.dao.TaskDao" %>
<%@ page import="inz.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%
    TaskTemplateDao taskTemplateDao = new TaskTemplateDao();

    String taskTemplateId = request.getParameter("taskTemplateId");
    TaskTemplate taskTemplate = null;
    taskTemplate = taskTemplateDao.getTaskTemplateById(Integer.parseInt(taskTemplateId));

    List<TestCase> testCases = taskTemplateDao.getTestCasesByTaskTemplateId(Integer.parseInt(taskTemplateId));
%>

<script>

    function saveTaskTemplate (){
        let baseUrl = "index?action=updateTaskTemplate&user=<%=currentUser.getId()%>&taskTemplateID="+ <%=taskTemplateId%>;
        console.log(baseUrl);
        let form = document.getElementById("addTaskForm");
        form.action = baseUrl;
        form.submit();


    }



</script>

<html>
<head>
    <style><%@include file="/static/prism/prism.css"%></style>
    <style><%@include file="/static/css/test.css"%></style>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
    <style>
        td > p {
            word-break: break-all;
        }
    </style>
</head>
<body>


<div style="width:90%" class="container align-items-center justify-content-center">
    <h2 class="text-center">Edytuj zadanie: <%=taskTemplate.getId()%></h2>
    <form id="addTaskForm" method="post" enctype="multipart/form-data">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <p class="h2">Opis zadania</p>
            <textarea placeholder="Opis zadania" name="description" class="h-100 w-100 form-control " form="addTaskForm" required="required" defaultValue="<%=taskTemplate.getDescription()%>" ><%=taskTemplate.getDescription()%></textarea>
        </div>
        <p class="h2">Kod zadania</p>
        <div id="answerEditor" style="width:100%">

                <pre id="highlighting" style="width:100%" aria-hidden="true">
                    <code id="highlightingContent" class="language-cpp" ></code>
                </pre>
            <textarea id="editing" name="taskCodeBody" style="width:100%" spellcheck="false" oninput="updateAnswer(this.value,'editing','highlightingContent');sync_scroll(this,'highlighting');" onscroll="sync_scroll(this,'highlighting')" onkeydown="check_tab(this, event);" form="addTaskForm"><%=taskTemplate.getTaskCodeBody()%></textarea>
        </div>
        <div class="form-group" >
            <p class="h2">Punkty za zadanie</p>
            <input style="width:100px" type="number" class="form-control item" name="score" form="addTaskForm" required="required" defaultValue="<%=taskTemplate.getScore()%>" value="<%=taskTemplate.getScore()%>">
        </div>
        <div>
            <p class="h2">Przypadki do testów automatycznych</p>
            <p class="h3">Dodaj nowy przypadek</p>
            <table class="table table-active word-break">
                <thead class="thead-dark">
                    <th scope="col" >Zestaw wejść do programu</th>
                    <th scope="col" >Oczekiwana wartość na wyjściu </th>
                </thead>
                <tbody>
                <tr>
                    <td style="width:40%">
                        <textarea id="testCaseInputs" style="height: 100px; width:100%;overflow: scroll;resize:none"></textarea>
                    </td>
                    <td style="width:40%">
                        <textarea id="testCaseOutputs" style="height: 100px; width:100%;overflow: scroll;resize:none"></textarea>
                    </td>
                    <td><button type="button" class="btn btn-success" onclick="addTestCase(document.querySelector('#testCaseInputs'),document.querySelector('#testCaseOutputs'))"> Dodaj przypadek</button> </td>
                </tr>
                </tbody>
            </table>
            <p class="h3">Lista testowanych przypadków</p>
            <table class="table table-active word-break">
                <thead class="thead-dark">
                <th scope="col" >Id</th>
                <th scope="col" >Zestaw wejść do programu</th>
                <th scope="col" >Oczekiwana wartość na wyjściu </th>
                </thead>
                <tbody id="testCaseList">

                </tbody>
            </table>
        </div>


    </br>
        <div class="form-group">
            <button onclick="saveTaskTemplate()" class="btn btn-success">Zapisz zmiany</button>
        </div>
    </form>

</div>

</body>

<script>

    function buildNewTestCase(Id,inputs,outputs){
        let tr = document.createElement("tr");
        document.querySelector("#testCaseList").appendChild(tr);

        let td_id = document.createElement("td");
        td_id.innerHTML = Id;
        tr.appendChild(td_id);

        let td_inputs = document.createElement("td");
        td_inputs.style.width = "40%";
        tr.appendChild(td_inputs);

        let td_inputs_textarea = document.createElement("textarea");
        td_inputs_textarea.style.height="100px";
        td_inputs_textarea.style.width="100%";
        td_inputs_textarea.style.overflow = "scroll";
        td_inputs_textarea.style.resize = "none";

        td_inputs.appendChild(td_inputs_textarea);

        td_inputs_textarea.value = inputs;
        let td_outputs = document.createElement("td");
        td_outputs.style.width = "40%";
        tr.appendChild(td_outputs);

        let td_outputs_textarea = document.createElement("textarea");
        td_outputs_textarea.style.height="100px";
        td_outputs_textarea.style.width="100%";
        td_outputs_textarea.style.overflow = "scroll";
        td_outputs_textarea.style.resize = "none";
        td_outputs.appendChild(td_outputs_textarea);

        td_outputs_textarea.value = outputs;

        let td_edit = document.createElement("td");
        let td_delete = document.createElement("td");

        tr.appendChild(td_edit);
        tr.appendChild(td_delete);

        let td_edit_button = document.createElement("button");
        let td_delete_button = document.createElement("button");

        td_edit_button.type="button";
        td_delete_button.type="button";

        td_edit_button.classList.add("btn");
        td_edit_button.classList.add("btn-warning");

        td_delete_button.classList.add("btn");
        td_delete_button.classList.add("btn-danger");

        td_edit_button.innerHTML ="Zapisz zmiany";
        td_delete_button.innerHTML ="Usuń przypadek";

        td_edit.appendChild(td_edit_button);
        td_delete.appendChild(td_delete_button);

        td_edit_button.addEventListener("click",()=>{
            updateTestCase(Id,td_inputs_textarea,td_outputs_textarea)
        })
        td_delete_button.addEventListener("click",()=> {
            removeTestCase(Id,tr)
        })


    }

    function addTestCase(inputs, outputs) {
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                console.log(this.responseText);

                buildNewTestCase(this.responseText,inputs.value,outputs.value);
            }
        };

        let formData = new FormData;
        formData.append("outputs",outputs.value);
        formData.append("inputs",inputs.value);
        formData.append("tasktemplate_id",<%=taskTemplateId%>);

        let request = "http://localhost:8080/Praca_inzynierska_war_exploded/index?action=addTestCase";
        xmlhttp.open("POST", request, true);
        xmlhttp.send(formData);

    }

    function updateTestCase(id, inputs, outputs){

        console.log(inputs);
        console.log(inputs.value);
        console.log(outputs);
        console.log(outputs.value);
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                console.log(this.responseText);

            }
        };

        let formData = new FormData;
        formData.append("outputs",outputs.value);
        formData.append("inputs",inputs.value);
        formData.append("testCase_id",id);

        let request = "http://localhost:8080/Praca_inzynierska_war_exploded/index?action=updateTestCase";
        xmlhttp.open("POST", request, true);
        xmlhttp.send(formData);
    }
    function removeTestCase(id,tr){
        let xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                console.log(this.responseText);
                tr.remove();
            }
        };

        let formData = new FormData;
        formData.append("testCase_id",id);

        let request = "http://localhost:8080/Praca_inzynierska_war_exploded/index?action=deleteTestCase";
        xmlhttp.open("POST", request, true);
        xmlhttp.send(formData);
    }


    function getLoaded(){
        return this.loaded;
    }
    function setLoaded(loaded){
        this.loaded = loaded;
    }

    window.onload = function (){
        setLoaded(false);

        let loadPrism = document.createElement("script");
        loadPrism.type = 'text/javascript';
        loadPrism.src = "${pageContext.request.contextPath}/static/prism/prism.js";
        document.getElementsByTagName("head")[0].appendChild(loadPrism);

        let editing = document.querySelector("#editing");
        updateAnswer(editing.value,"editing","highlightingContent");
        sync_scroll(editing,"highlighting");

        <% for(int i=0;i<testCases.size();i++) { %>
        inputsFromDB = <%=new String( "\"" +testCases.get(i).getInputs()) + "\""%>;
        outputsFromDB = <%= new String( "\"" + testCases.get(i).getExpectedOutput()) +  "\""%>;
        id = <%=testCases.get(i).getId()%>;

        buildNewTestCase(id,inputsFromDB,outputsFromDB);
        <%}%>

        setLoaded(true);
        Prism.highlightAll();

    }

    function updateAnswer(text,textarea_id,code_id) {

        console.log("updating answer " +textarea_id +code_id)

        let textarea = document.querySelector("#"+textarea_id);
        textarea.innerHTML=text;

        let result_element = document.querySelector("#"+code_id);
        text = cleanMarkdown(text);
        result_element.innerHTML=text;
        if(getLoaded()){
            Prism.highlightElement(result_element);
        }

    }

    function cleanMarkdown(text){
        return text.replace(new RegExp("&", "g"), "&").replace(new RegExp("<", "g"), "&lt");
    }


    function sync_scroll(element,pre_id) {
        let result_element = document.querySelector("#"+pre_id);
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
