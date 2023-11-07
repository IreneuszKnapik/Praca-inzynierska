<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<head>
    <meta charset="UTF-8">
    <title>Logowanie</title>




</head>

<body>

<div class="login-form">
    <form method="post" onsubmit="" action="index?action=login">
        <div class="form-icon">
            <span><i class="icon icon-user"></i></span>
        </div>
        <div class="form-group">
            <input type="text" class="form-control item" id="uname"  name="username" placeholder="Login" required="required">
        </div>
        <div class="form-group">
            <input type="password" class="form-control item" id="passwd" name="password"  placeholder="Hasło" required="required">
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-block login-button">Zaloguj</button>
        </div>
        <label>Nie posiadasz konta?</label>
        <div class="form-group">
            <button type="submit" class="btn btn-block register-button submit"><a href="index.jsp?webpage=register">Zarejestruj się</a></button>
        </div>
    </form>

</div>

</body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.15/jquery.mask.min.js"></script>
