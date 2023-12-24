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
    </br>
        <div class="form-group">
            <button onclick="saveTaskTemplate()" class="btn btn-success">Zapisz zmiany</button>
        </div>
    </form>

</div>

</body>

<script>

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
