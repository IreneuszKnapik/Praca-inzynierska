<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<head>
    <meta charset="UTF-8">
    <title>Logowanie</title>




</head>

<body>
<div class="container w-75">
    <div class="login-form ">
        <form method="post" onsubmit="" action="index?action=login">
            <div class="form-icon">
                <span><i class="icon icon-user"></i></span>
            </div>
            <div class="form-group">
                <p>Nazwa użytkownika</p>
                <input type="text" class="form-control item" id="uname"  name="username" placeholder="Login" required="required">
            </div>
            <div class="form-group">
                <p>Hasło:</p>
                <input type="password" class="form-control item" id="passwd" name="password"  placeholder="Hasło" required="required">
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-lg btn-primary login-button">Zaloguj</button>
            </div>

            <div class="form-group">
                <label>Nie posiadasz konta?</label><br>
                <button type="submit" class="btn register-button btn-lg btn-success submit"><a href="index.jsp?webpage=register" style="color:black">Zarejestruj się</a></button>
            </div>
        </form>

    </div>
</div>


</body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.15/jquery.mask.min.js"></script>
