<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Erro na Operação</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">
</head>
<body>
<div class="container mt-5">
    <div class="alert alert-danger" role="alert">
        <h4 class="alert-heading">🚫 Erro na Operação!</h4>
        <hr>
        <p class="mb-0">
            <%-- Exibe a mensagem específica do Service ou a mensagem de erro padrão --%>
            <c:choose>
                <c:when test="${not empty requestScope.errorMessage}">
                    <strong>Detalhe:</strong> ${requestScope.errorMessage}
                </c:when>
                <c:otherwise>
                    Não foi possível completar a ação solicitada. Por favor, volte e tente novamente.
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <a href="home.jsp" class="btn btn-secondary mt-3">Voltar à Área Administrativa</a>
    <%-- Usa o header 'referer' para voltar para a página de onde o usuário veio --%>
    <a href="${pageContext.request.getHeader('referer')}" class="btn btn-primary mt-3">Voltar à Página Anterior</a>
</div>
</body>
</html>