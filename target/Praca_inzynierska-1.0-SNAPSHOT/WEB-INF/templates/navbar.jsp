<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>
<header>
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="index.jsp?webpage=landing">Platforma testowania programów C++</a>
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
            </div>
            <div class="collapse navbar-collapse" id="myNavbar">
                <ul class="nav navbar-nav">
                    <% if(currentUser.getUsername() != null){ %>
                    <li class="navbar-item">
                        <a class="nav-link">Zalogowany jako:<%=currentUser.getUsername() %></a>
                    </li>
                    <li class="navbar-item">
                        <a class="nav-link" href="index?action=logout">Wyloguj</a>
                    </li>

                    <% if(currentUser.getType() != null && currentUser.getType() > 0) {%>
                    <li class="navbar-item">
                        <a class="nav-link" href="index.jsp?webpage=main">Menu</a>
                    </li>
                    <%}%>
                    <%}
                    else {
                    %>
                    <li class="navbar-item">
                        <a class="nav-link" href="index.jsp?webpage=register">Rejestracja</a>
                    </li>
                    <li class="navbar-item">
                        <a class="nav-link" href="index.jsp?webpage=login">Zaloguj się</a>
                    </li>
                    <%}%>
                    <li class="navbar-item">
                        <a class="nav-link" href="index.jsp?webpage=landing">O stronie</a>
                    </li>
                </ul>
            </div>

        </div>
    </nav>
</header>