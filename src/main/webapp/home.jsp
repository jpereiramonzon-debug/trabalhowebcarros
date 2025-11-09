<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Home - Administrativo</title>
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
        .list-group-item-dark-tool {
            color: white !important;
            background-color: #6c757d; /* Cinza secundário escuro */
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
            font-weight: 600;
        }
        .list-group-item-dark-tool:hover {
            background-color: #5c636a;
            border-color: rgba(255, 255, 255, 0.5) !important;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-success">Área Administrativa</h2>

    <h4 class="mb-3">Controle de Dados</h4>
    <div class="list-group mb-4">
        <a href="usuario/findall" class="list-group-item list-group-item-action list-group-item-strong">
            Cadastrar Usuários/Clientes
        </a>
        <a href="veiculo/findall" class="list-group-item list-group-item-action list-group-item-strong">
            Cadastrar Veículos
        </a>
        <a href="proposta/findall" class="list-group-item list-group-item-action list-group-item-strong">
            Controle de Propostas
        </a>
    </div>

    <hr>

    <h4 class="mb-3">Relatórios e Ferramentas</h4>
    <div class="list-group">
        <a href="relatorio/propostas" class="list-group-item list-group-item-action list-group-item-dark-tool">
            Relatório de Propostas
        </a>
        <a href="simulacao/calcular" class="list-group-item list-group-item-action list-group-item-dark-tool">
            Simulação de Financiamento
        </a>
    </div>

    <hr>
    <a href="index.jsp" class="btn btn-outline-secondary mt-3">Voltar ao Início</a>
</div>
</body>
</html>