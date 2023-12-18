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
    List<TestTemplate> testTemplates=null;
    testTemplates = testDao.getAllTestTemplates();

%>

<script>

    function deleteTest(testid){
        if (confirm("Czy na pewno usunąć test" + testid) == true) {
            let baseUrl = "index?action=deleteTestTemplate&user=<%=currentUser.getId()%>&testTemplateID="+testid;
            let form = document.createElement("form");
            form.action = baseUrl;
            form.method = "POST";
            document.body.appendChild(form);
            form.submit()
        } else {

        }
    }
</script>


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
</head>
<body>



<%if(testTemplates.isEmpty()){%>
<h2 class="text-center">W bazie nie ma żadnych szablonów testów</h2>
<button  class="btn  "><a href="index.jsp?webpage=addTestTemplate">Dodaj test</a></button>

<%
} else{ %>
<button  class="btn  "><a href="index.jsp?webpage=addTestTemplate">Dodaj test</a></button>
<table id="groups" class="table table-active">
    <tr>
        <th scope="col" class="text-center">Id</th>
        <th scope="col" class="text-center">Nazwa szablonu testu</th>
        <th scope="col" class="text-center">Opis testu</th>
    </tr>
    <% for(int i=0;i<testTemplates.size();i++) { %>
        <tr>
            <td>
                <%=testTemplates.get(i).getId()%>
            </td>
            <td>
                <%=testTemplates.get(i).getName()%>
            </td>
            <td>
                <%=testTemplates.get(i).getDescription()%>
            </td>
            <td>
                <button class="btn  "><a href="index.jsp?webpage=editTestTemplate&testTemplateId=<%=testTemplates.get(i).getId()%>">Edytuj test</a></button>
            </td>
            <td>
                <button class="btn " onclick="deleteTest(<%=testTemplates.get(i).getId()%>)"> Usuń test</button>
            </td>
        </tr>

<%}%>
</table>

<%}%>

</body>
</html>
