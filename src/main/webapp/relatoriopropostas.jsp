<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="br.edu.ifpr.irati.ads.model.Proposta" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.stream.Collectors" %>

<%
    // Bloco de processamento de dados mantido, conforme a regra de não alterar funcionalidades
    List<Proposta> propostas = (List<Proposta>) request.getAttribute("propostas");
    if (propostas == null){
        propostas = new ArrayList<>();
    }

    int totalPropostas = propostas.size();

    // Calcula Propostas Aceitas
    long propostasAceitas = propostas.stream()
            .filter(p -> "ACEITA".equals(p.getStatusNegociacao()))
            .count();

    // NOVO: Calcula Propostas Recusadas (AGORA CONTA CANCELADA)
    long propostasRecusadas = propostas.stream()
            .filter(p -> "CANCELADA".equals(p.getStatusNegociacao()))
            .count();

    // Calcula Valor Total Aceito (soma APENAS as propostas ACEITAS)
    BigDecimal valorTotalAceito = propostas.stream()
            .filter(p -> "ACEITA".equals(p.getStatusNegociacao()))
            .map(Proposta::getValorProposto)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    // Configura variáveis no escopo 'request' para que o EL possa acessá-las
    request.setAttribute("totalPropostas", totalPropostas);
    request.setAttribute("propostasAceitas", propostasAceitas);
    request.setAttribute("propostasRecusadas", propostasRecusadas); // NOVO
    request.setAttribute("valorTotalAceito", valorTotalAceito);     // NOVO
%>
<!DOCTYPE html>
<html>
<head>
    <title>Relatório de Propostas</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-secondary">Relatório Gerencial de Propostas</h2>

    <div class="row mb-4">

        <div class="col-md-3">
            <div class="card text-white bg-primary shadow-sm">
                <div class="card-header">Total de Propostas</div>
                <div class="card-body">
                    <h5 class="card-title">${totalPropostas}</h5>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-success shadow-sm">
                <div class="card-header">Propostas Aceitas</div>
                <div class="card-body">
                    <h5 class="card-title">${propostasAceitas}</h5>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-danger shadow-sm">
                <div class="card-header">Propostas Recusadas</div>
                <div class="card-body">
                    <h5 class="card-title">${propostasRecusadas}</h5>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-info shadow-sm">
                <div class="card-header">Valor Total Aceito</div>
                <div class="card-body">
                    <h5 class="card-title">R$ <fmt:formatNumber value="${valorTotalAceito}" pattern="#,##0.00"/></h5>
                </div>
            </div>
        </div>

    </div>

    <h4>Detalhes das Propostas</h4>
    <div class="table-responsive">
        <table class="table table-hover table-bordered table-striped table-sm">
            <thead class="table-dark">
            <tr>
                <th scope="col">ID</th>

                <th scope="col">Data</th>
                <th scope="col">Veículo</th>
                <th scope="col">Cliente</th>
                <th scope="col">Vendedor</th>
                <th scope="col">Valor</th>
                <th scope="col">Status</th>

            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${propostas}">
                <tr>
                    <td>${p.id}</td>
                    <td>${p.dataProposta.toLocalDate()}</td>
                    <td>${p.veiculo.marca} ${p.veiculo.modelo}</td>
                    <td>${p.cliente.nome} (${p.cliente.tipo})</td>
                    <td>${p.vendedor.nome}</td>
                    <td>R$ <fmt:formatNumber value="${p.valorProposto}" pattern="#,##0.00"/></td>

                    <td>${p.statusNegociacao}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <a href="home.jsp" class="btn btn-secondary mb-4">Voltar ao Início</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>