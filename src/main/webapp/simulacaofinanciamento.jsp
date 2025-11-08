<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Recupera os resultados da requisição, se houver
    List<Map<String, BigDecimal>> tabelaPrice = (List<Map<String, BigDecimal>>) request.getAttribute("tabelaPrice");
    BigDecimal valorFinanciado = (BigDecimal) request.getAttribute("valorFinanciado");
    BigDecimal valorVeiculo = (BigDecimal) request.getAttribute("valorVeiculo");
    BigDecimal taxaJuros = (BigDecimal) request.getAttribute("taxaJuros");
    Integer prazo = (Integer) request.getAttribute("prazo");
    String erro = (String) request.getAttribute("erro");

    if (tabelaPrice == null){
        tabelaPrice = new ArrayList<>();
    }

    // Calcula o valor da prestação para o resumo
    BigDecimal prestacaoFixa = tabelaPrice.isEmpty() ? BigDecimal.ZERO : tabelaPrice.get(0).get("prestacao");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Simulação de Financiamento</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">
</head>
<body>
<div class="container">
    <h2 class="mt-4 mb-4">Simulação de Financiamento (Tabela Price)</h2>

    <div class="card mb-4">
        <div class="card-header">
            Parâmetros da Simulação
        </div>
        <div class="card-body">
            <% if (erro != null) { %>
            <div class="alert alert-danger" role="alert"><%=erro%></div>
            <% } %>
            <form method="post" action="simulacao/calcular">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="valorVeiculo" class="form-label">Valor do Veículo (R$)</label>
                        <input type="number" step="0.01" class="form-control" id="valorVeiculo" name="valorVeiculo"
                               value="<%=valorVeiculo != null ? valorVeiculo : ""%>" required min="1000">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="valorEntrada" class="form-label">Valor de Entrada (R$)</label>
                        <input type="number" step="0.01" class="form-control" id="valorEntrada" name="valorEntrada"
                               value="<%=valorFinanciado != null ? valorVeiculo.subtract(valorFinanciado) : ""%>" required min="0">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="taxaJuros" class="form-label">Taxa de Juros Anual (%)</label>
                        <input type="number" step="0.01" class="form-control" id="taxaJuros" name="taxaJuros"
                               value="<%=taxaJuros != null ? taxaJuros : "12.0"%>" required min="0.01" max="100">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="prazo" class="form-label">Prazo (Meses)</label>
                        <input type="number" class="form-control" id="prazo" name="prazo"
                               value="<%=prazo != null ? prazo : "36"%>" required min="1" max="120">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Simular</button>
                <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
            </form>
        </div>
    </div>

    <% if (!tabelaPrice.isEmpty()) { %>
    <div class="mb-4">
        <h4>Resumo do Financiamento</h4>
        <ul class="list-group">
            <li class="list-group-item"><strong>Valor do Veículo:</strong> R$ <%=String.format("%,.2f", valorVeiculo)%></li>
            <li class="list-group-item"><strong>Valor Financiado:</strong> R$ <%=String.format("%,.2f", valorFinanciado)%></li>
            <li class="list-group-item"><strong>Prazo (Meses):</strong> <%=prazo%></li>
            <li class="list-group-item list-group-item-success"><strong>Prestação Mensal Fixa:</strong> R$ <%=String.format("%,.2f", prestacaoFixa)%></li>
        </ul>
    </div>

    <h4>Cronograma de Pagamentos (Tabela Price)</h4>
    <div class="table-responsive">
        <table class="table table-hover table-bordered table-sm">
            <thead>
            <tr>
                <th scope="col"># Parcela</th>
                <th scope="col">Prestação (Fixa)</th>
                <th scope="col">Juros</th>
                <th scope="col">Amortização</th>
                <th scope="col">Saldo Devedor</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map<String, BigDecimal> linha : tabelaPrice){ %>
            <tr>
                <td><%=linha.get("parcela").intValue()%></td>
                <td>R$ <%=String.format("%,.2f", linha.get("prestacao"))%></td>
                <td>R$ <%=String.format("%,.2f", linha.get("juros"))%></td>
                <td>R$ <%=String.format("%,.2f", linha.get("amortizacao"))%></td>
                <td>R$ <%=String.format("%,.2f", linha.get("saldo"))%></td>
            </tr>
            <%}%>
            </tbody>
        </table>
    </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
</html>