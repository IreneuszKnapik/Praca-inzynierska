<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<head>
    <meta charset="UTF-8">
    <title>Błąd logowania</title>


</head>

<body>
<p><%= request.getParameter("errors") %></p>

<button type="submit" class="btn btn-block return-landing submit"><a href="index.jsp?webpage=register">Powrót do strony głównej</a></button>
</body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.15/jquery.mask.min.js"></script>