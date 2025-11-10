<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Bloco de inicialização de variáveis mantido, conforme a regra de não alterar funcionalidades
    List<Map<String, BigDecimal>> tabelaPrice = (List<Map<String, BigDecimal>>) request.getAttribute("tabelaPrice");
    BigDecimal valorFinanciado = (BigDecimal) request.getAttribute("valorFinanciado");
    BigDecimal valorVeiculo = (BigDecimal) request.getAttribute("valorVeiculo");
    BigDecimal taxaJuros = (BigDecimal) request.getAttribute("taxaJuros");
    Integer prazo = (Integer) request.getAttribute("prazo");
    String erro = (String) request.getAttribute("erro");

    if (tabelaPrice == null){
        tabelaPrice = new ArrayList<>();
    }

    BigDecimal prestacaoFixa = tabelaPrice.isEmpty() ? BigDecimal.ZERO : tabelaPrice.get(0).get("prestacao");

    // Configura variável calculada no escopo 'request' para que o EL possa acessá-la
    request.setAttribute("prestacaoFixa", prestacaoFixa);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Simulação de Financiamento</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" crossorigin="anonymous">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Simulação de Financiamento (Tabela Price)</h2>

    <div class="card mb-4 shadow-sm border-primary">
        <div class="card-header bg-primary text-white">
            Parâmetros da Simulação
        </div>
        <div class="card-body">
            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">${erro}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/simulacao/calcular">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="valorVeiculo" class="form-label">Valor do Veículo (R$)</label>
                        <input type="number" step="0.01" class="form-control" id="valorVeiculo" name="valorVeiculo"
                               value="${valorVeiculo}" required min="1000">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="valorEntrada" class="form-label">Valor de Entrada (R$)</label>
                        <%-- O cálculo da entrada é feito usando o operador de subtração do EL --%>
                        <input type="number" step="0.01" class="form-control" id="valorEntrada" name="valorEntrada"
                               value="${valorFinanciado != null ? valorVeiculo - valorFinanciado : ''}" required min="0">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="taxaJuros" class="form-label">Taxa de Juros Anual (%)</label>
                        <input type="number" step="0.01" class="form-control" id="taxaJuros" name="taxaJuros"
                               value="${taxaJuros != null ? taxaJuros : '12.0'}" required min="0.01" max="100">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="prazo" class="form-label">Prazo (Meses)</label>
                        <input type="number" class="form-control" id="prazo" name="prazo"
                               value="${prazo != null ? prazo : '36'}" required min="1" max="120">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Simular</button>
                <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
            </form>
        </div>
    </div>

    <c:if test="${not empty tabelaPrice}">
        <div class="mb-4">
            <h4>Resumo do Financiamento</h4>
            <ul class="list-group">
                <li class="list-group-item"><strong>Valor do Veículo:</strong> R$ <fmt:formatNumber value="${valorVeiculo}" pattern="#,##0.00"/></li>
                <li class="list-group-item"><strong>Valor Financiado:</strong> R$ <fmt:formatNumber value="${valorFinanciado}" pattern="#,##0.00"/></li>
                <li class="list-group-item"><strong>Prazo (Meses):</strong> ${prazo}</li>
                <li class="list-group-item list-group-item-success"><strong>Prestação Mensal Fixa:</strong> R$ <fmt:formatNumber value="${prestacaoFixa}" pattern="#,##0.00"/></li>
            </ul>
        </div>

        <h4>Cronograma de Pagamentos (Tabela Price)</h4>
        <div class="table-responsive">
            <table class="table table-hover table-bordered table-striped table-sm">
                <thead class="table-dark">
                <tr>
                    <th scope="col"># Parcela</th>
                    <th scope="col">Prestação (Fixa)</th>
                    <th scope="col">Juros</th>
                    <th scope="col">Amortização</th>
                    <th scope="col">Saldo Devedor</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="linha" items="${tabelaPrice}">
                    <tr>
                        <td>${linha.parcela}</td>
                        <td>R$ <fmt:formatNumber value="${linha.prestacao}" pattern="#,##0.00"/></td>
                        <td>R$ <fmt:formatNumber value="${linha.juros}" pattern="#,##0.00"/></td>
                        <td>R$ <fmt:formatNumber value="${linha.amortizacao}" pattern="#,##0.00"/></td>
                        <td>R$ <fmt:formatNumber value="${linha.saldo}" pattern="#,##0.00"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>