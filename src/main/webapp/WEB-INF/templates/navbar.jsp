<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:useBean id="currentUser" class="inz.model.User" scope="session"/>
<header>
    <nav class="navbar navbar-light bg-light navbar-expand-xl">
        <a class="navbar-brand" href="index.jsp?webpage=landing">Platforma testowa C++</a>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#mainmenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainmenu">
            <ul class="navbar-nav">
                <li class="navbar-item">
                    <a class="nav-link" href="index.jsp?webpage=landing">Strona główna</a>
                </li>


                <li class="navbar-item">
                    <a class="nav-link" href="index.jsp?webpage=register">Rejestracja</a>
                </li>


                <li class="navbar-item">
                    <a class="nav-link" href="index.jsp?webpage=login">Zaloguj się</a>
                </li>

            </ul>
        </div>

    </nav>

</header>