<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

    <form action="loginservlet" method="post">
        Usuário: <input type="text" name="usuario"/> <br>
        Senha: <input type="password" name="senha"/> <br>
        <input type="submit" value="Entrar"/>
    </form>

</body>
</html>