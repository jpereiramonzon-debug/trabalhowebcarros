<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Portal do Cliente - Concessionária</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">
    <style>
        .list-group-item-strong {
            color: white !important;
            background-color: #0d6efd; /* Azul primário escuro */
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
            font-weight: 600;
        }
        .list-group-item-strong:hover {
            background-color: #0a58ca;
            border-color: rgba(255, 255, 255, 0.5) !important;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-primary">Portal do Cliente</h2>
    <div class="list-group">
        <a href="listaveiculos.jsp" class="list-group-item list-group-item-action list-group-item-strong">Visualizar Veículos</a>
        <a href="<%= request.getContextPath() %>/simulacao/calcular" class="list-group-item list-group-item-action list-group-item-strong">Realizar Simulação de Financiamento</a>
    </div>

    <hr class="my-4">

    <h4 class="mb-3">Acesso</h4>
    <div class="list-group">
        <a href="login.jsp" class="list-group-item list-group-item-action list-group-item-success">Entrar (Usuários do Sistema)</a>
        <a href="sobre.jsp" class="list-group-item list-group-item-action list-group-item-light">Sobre</a>
    </div>
</div>
</body>
</html>