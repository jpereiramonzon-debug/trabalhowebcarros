<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home - Administrativo</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">

</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-success">Área Administrativa</h2>

    <h4 class="mb-3">Controle de Dados</h4>
    <div class="list-group mb-4">
        <a href="usuario/findall" class="list-group-item list-group-item-action list-group-item-primary">
            Cadastrar Usuários/Clientes
        </a>

        <a href="veiculo/findall" class="list-group-item list-group-item-action list-group-item-primary">
            Cadastrar Veículos
        </a>
        <a href="proposta/findall" class="list-group-item list-group-item-action list-group-item-primary">
            Controle de Propostas
        </a>
        <a href="venda/findall" class="list-group-item list-group-item-action list-group-item-primary">
            Vendas Finalizadas </a>
    </div>

    <hr>

    <h4 class="mb-3">Relatórios e Ferramentas</h4>
    <div class="list-group">
        <a href="relatorio/propostas" class="list-group-item list-group-item-action list-group-item-secondary">

            Relatório de Propostas
        </a>
        <a href="simulacao/calcular" class="list-group-item list-group-item-action list-group-item-secondary">
            Simulação de Financiamento
        </a>
    </div>

    <hr>
    <a href="index.jsp" class="btn btn-outline-secondary mt-3">Voltar ao Início</a>
</div>
</body>
</html>