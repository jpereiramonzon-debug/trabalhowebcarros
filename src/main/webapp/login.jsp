<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-lg border-primary">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Acesso ao Sistema</h4>
                </div>
                <div class="card-body">
                    <form action="loginservlet" method="post">
                        <div class="mb-3">
                            <label for="usuario" class="form-label">Usuário (E-mail)</label>
                            <input type="text" class="form-control" id="usuario" name="usuario" required/>
                        </div>
                        <div class="mb-3">
                            <label for="senha" class="form-label">Senha</label>
                            <input type="password" class="form-control" id="senha" name="senha" required/>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success">Entrar</button>
                            <a href="index.jsp" class="btn btn-outline-secondary">Voltar ao Portal</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>