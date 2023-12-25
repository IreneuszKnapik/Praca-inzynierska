<%@ page import="inz.dao.GroupDao" %>
<%@ page import="inz.model.Group" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="inz.dao.TestDao" %>
<%@ page import="inz.model.Test" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>

<%

    GroupDao groupDao = new GroupDao();
    List<Group> groups=null;
    groups = groupDao.getGroupsByUserId(currentUser.getId());

    TestDao testDao = new TestDao();
    List<Test> tests = null;
    tests = testDao.getGradedTestsByUser(currentUser.getId());


%>


<html>
<head>
    <title><%=currentUser.getUsername() %> - C++ testing portal</title>
    <style>
        td > p {
            word-break: break-all;
        }
    </style>
</head>
<body>



<div class="container w-75 p-3">
    <div class="row">
        <nav class="col-sm-3">
            <ul class="nav nav-pills nav-stacked" data-spy="affix">
                <%if(currentUser.getType() > 2){%>
                <li><a href="index.jsp?webpage=users">Zarządzanie użytkownikami</a></li>
                <li><a href="index.jsp?webpage=groups">Zarządzanie grupami</a></li>
                <%}%>
                <%if(currentUser.getType() > 1){%>
                    <li><a href="index.jsp?webpage=testTemplates">Szablony testów</a></li>
                    <li><a href="index.jsp?webpage=taskTemplates">Szablony zadań</a></li>
                    <li><a href="index.jsp?webpage=gradingTests">Ocenianie testów</a></li>
                <%}%>
                <li><a href="index.jsp?webpage=tests">Testy</a></li>
            </ul>
        </nav>
        <div class="col-sm-9">
            <div class="container justify-content-center">
                <%if(groups.isEmpty()){%>
                <h2 class="text-center">Użytkownik nie należy do żadnej grupy</h2>
                <%
                } else{ %>
                <p class="h2 text-center">Grupy do których należysz</p>
                <table class="table table-active">
                    <thead class="thead-dark">
                    <tr>
                        <th scope="col" class="text-center">Nazwa grupy</th>
                        <th scope="col" class="text-center">Opis grupy</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for(int i=0;i<groups.size();i++) { %>
                    <tr>
                        <td>
                        <p class="text-center" ><%=groups.get(i).getName()%></p>
                        </td>
                        <td>
                            <p class="text-center" ><%=groups.get(i).getDescription()%></p>
                        </td>
                    </tr>
                    <%}%>
                    </tbody>
                </table>
                <p class="h2 text-center">Twoje ocenione testy</p>
                <table class="table table-active word-break table-dark">
                    <thead>
                    <tr>
                        <th scope="col" class="text-center">Data rozpoczęcia</th>
                        <th scope="col" class="text-center">Data wysłania</th>
                        <th scope="col" class="text-center">Opis testu</th>
                        <th scope="col" class="text-center">Ocena</th>
                    </tr>
                    </thead>
                    <tbody>

                    <% for(int i=0;i<tests.size();i++) { %>
                    <tr>
                        <td class="text-center"><p><%=tests.get(i).getStart_date()%></p></td>
                        <td class="text-center"><p><%=tests.get(i).getSubmit_date()%></p></td>
                        <td class="text-center"><p><%=testDao.getTestTemplateById(tests.get(i).getTest_template_id()).getDescription()%></p></td>
                        <td class="text-center"><p><%=tests.get(i).getGrade()%></p></td>
                        <td class="text-center"><p><button class="btn btn-info" onclick="location.href = 'index.jsp?webpage=viewTest&testId=<%=tests.get(i).getId()%>&taskPos=0'">Zobacz test</button></p></td>
                    </tr>

                    <%}%>
                    </tbody>
                </table>


                <%}%>
            </div>
        </div>
    </div>
</div>


</body>
</html>
