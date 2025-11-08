<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.edu.ifpr.irati.ads.model.Proposta" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.stream.Collectors" %>

<%
    // Recupera a lista de propostas do escopo da requisição (definido no Servlet)
    List<Proposta> propostas = (List<Proposta>) request.getAttribute("propostas");

    if (propostas == null){
        propostas = new ArrayList<>();
    }

    // Lógica para indicadores/resumo (Funcionalidade Não-CRUD)
    int totalPropostas = propostas.size();
    long propostasAceitas = propostas.stream()
            .filter(p -> "ACEITA".equals(p.getStatusNegociacao())) // Apenas ACEITA após a simplificação
            .count();

    // Calcula o valor total proposto (usando Java 8 Stream API)
    BigDecimal valorTotalProposto = propostas.stream()
            .map(Proposta::getValorProposto)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
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
<div class="container">
    <h2 class="mt-4 mb-4">Relatório Gerencial de Propostas</h2>

    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-white bg-info mb-3">
                <div class="card-header">Total de Propostas</div>
                <div class="card-body">
                    <h5 class="card-title"><%=totalPropostas%></h5>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-success mb-3">
                <div class="card-header">Propostas Aceitas</div>
                <div class="card-body">
                    <h5 class="card-title"><%=propostasAceitas%></h5>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-primary mb-3">
                <div class="card-header">Valor Total Proposto</div>
                <div class="card-body">
                    <h5 class="card-title">R$ <%=String.format("%,.2f", valorTotalProposto)%></h5>
                </div>
            </div>
        </div>
    </div>

    <h4>Detalhes das Propostas</h4>
    <div class="table-responsive">
        <table class="table table-hover table-bordered">
            <thead>
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
            <% for (Proposta p: propostas){ %>
            <tr>
                <td><%=p.getId()%></td>
                <td><%=p.getDataProposta().toLocalDate()%></td>
                <td><%=p.getVeiculo().getMarca() + " " + p.getVeiculo().getModelo()%></td>
                <td><%=p.getCliente().getNome()%> (<%=p.getCliente().getTipo()%>)</td>
                <td><%=p.getVendedor().getNome()%></td>
                <td>R$ <%=String.format("%,.2f", p.getValorProposto())%></td>
                <td><%=p.getStatusNegociacao()%></td>
            </tr>
            <%}%>
            </tbody>
        </table>
    </div>

    <a href="home.jsp" class="btn btn-secondary mb-4">Voltar ao Início</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
</html>