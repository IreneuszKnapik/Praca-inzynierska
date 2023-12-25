<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<head>
    <meta charset="UTF-8">
    <title>Rejestracja</title>


</head>

<body>
    <div class="registration-form container w-75">
        <form method="post" onsubmit="" action="index?action=register" >
            <div class="form-group">
                <p>Nazwa użytkownika</p>
                <input type="text" class="form-control item" name="username" placeholder="Login" required="required">
            </div>
            <div class="form-group">
                <p>Hasło - wymagane co najmniej 10 znaków, mała i wielka litera, cyfra i/lub znak specjalny</p>
                <input type="password" class="form-control item" name="password1"  placeholder="Hasło" required="required">
            </div>
            <div class="form-group">
                <p>Powtórz hasło</p>
                <input type="password" class="form-control item" name="password2"  placeholder="Powtórz hasło" required="required">
            </div>
            <div class="form-group">
                <p>Adres e-mail</p>
                <input type="text" class="form-control item" name="email" placeholder="Adres email" required="required">
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-lg btn-primary create-account submit">Rejestruj</button>
            </div>
        </form>

    </div>

</body>