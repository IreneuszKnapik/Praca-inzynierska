<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<head>
    <meta charset="UTF-8">
    <title>Rejestracja</title>


</head>

<body>
    <div class="registration-form">
        <form method="post" onsubmit="" action="index?action=register" >
            <div class="form-icon">
                <span><i class="icon icon-user"></i></span>
            </div>
            <div class="form-group">
                <input type="text" class="form-control item" name="username" placeholder="Login" required="required">
            </div>

            <div class="form-group">
                <input type="password" class="form-control item" name="password1"  placeholder="Hasło" required="required">
            </div>
            <div class="form-group">
                <input type="password" class="form-control item" name="password2"  placeholder="Powtórz hasło" required="required">
            </div>
            <div class="form-group">
                <input type="text" class="form-control item" name="email" placeholder="Adres email" required="required">
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-block create-account submit">Rejestruj</button>
            </div>
        </form>

    </div>

</body>