<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sobre o Projeto</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-info">Sobre o Projeto Final WEB3</h2>
    <p class="lead">Este é um exemplo de sistema de gestão de concessionárias desenvolvido com as seguintes tecnologias:</p>

    <ul class="list-group list-group-flush mb-4">
        <li class="list-group-item"><strong>Backend:</strong> Java (Jakarta EE / Servlets)</li>
        <li class="list-group-item"><strong>Persistência:</strong> Hibernate ORM (JPA)</li>
        <li class="list-group-item"><strong>Frontend:</strong> JSP (JavaServer Pages)</li>
        <li class="list-group-item"><strong>Estilização:</strong> Bootstrap 5</li>
        <li class="list-group-item"><strong>Segurança:</strong> Filtros de Segurança e JWT (JSON Web Tokens)</li>
        <li class="list-group-item"><strong>Arquitetura:</strong> Modelo MVC (Model-View-Controller)</li>
    </ul>

    <p class="text-muted">O projeto cumpre todos os requisitos de CRUD, funções não-CRUD (Relatórios e Simulação), e segurança.</p>

    <a href="index.jsp" class="btn btn-primary mt-3">Voltar ao Início</a>
</div>
</body>
</html>