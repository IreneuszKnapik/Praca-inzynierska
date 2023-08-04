<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<head>
    <meta charset="UTF-8">
    <title>Rejestracja</title>

    <link href="static/css/register2.css" rel="stylesheet" />

    <link href="https://cdnjs.cloudflare.com/ajax/libs/simple-line-icons/2.4.1/css/simple-line-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

</head>

<body>
    <div class="registration-form">
        <form method="post" onsubmit="" action="index?action=register" >
            <div class="form-icon">
                <span><i class="icon icon-user"></i></span>
            </div>
            <div class="form-group">
                <input type="text" class="form-control item" id="nazwaUsera" name="username" placeholder="Login" required="required">
            </div>

            <div class="form-group">
                <input type="password" class="form-control item" id="hasło" name="password"  placeholder="Hasło" required="required">
            </div>
            <div class="form-group">
                <input type="text" class="form-control item" id="email" name="email" placeholder="Adres email" required="required">
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-block create-account submit">Rejestruj</button>
            </div>
        </form>

    </div>

</body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.15/jquery.mask.min.js"></script>