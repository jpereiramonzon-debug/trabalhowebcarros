<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Imports necessários para o bloco de scriptlet --%>
<%@ page import="br.edu.ifpr.irati.ads.model.Venda" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Bloco de inicialização de variáveis, seguindo o padrão
    List<Venda> vendas = (List<Venda>) session.getAttribute("vendas");
    if (vendas == null){
        vendas = new ArrayList<>();
    }
    // Expõe a lista de vendas para a Expression Language (EL)
    request.setAttribute("vendas", vendas);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestão de Vendas Finalizadas</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-success">Vendas Finalizadas</h2>

    <div class="row">
        <div class="col">
            <table class="table table-hover table-striped table-responsive">
                <thead class="table-dark">
                <tr>
                    <th scope="col">ID Venda</th>
                    <th scope="col">Data Venda</th>
                    <th scope="col">Veículo</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Vendedor</th>
                    <th scope="col">Valor Final</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${vendas}">
                    <tr>
                        <td>${v.id}</td>
                            <%-- Usando toLocalDate() para evitar o erro de conversão de LocalDateTime --%>
                        <td>${v.dataVenda.toLocalDate()}</td>
                        <td>${v.veiculo.marca} ${v.veiculo.modelo}</td>
                        <td>${v.cliente.nome}</td>
                        <td>${v.vendedor.nome}</td>
                        <td>R$ <fmt:formatNumber value="${v.valorFinal}" pattern="#,##0.00"/></td>
                        <td class="text-end">
                                <%-- NOVO: Botão para gerar o PDF da Venda --%>
                            <a class="btn btn-info btn-sm text-white" href="venda/gerarpdf?id=${v.id}" target="_blank" role="button">Gerar Contrato (PDF)</a>
                                <%-- NOVO: Botão para Excluir a Venda (Estornar) --%>
                            <a class="btn btn-danger btn-sm" href="venda/delete?id=${v.id}" role="button">Excluir Venda</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty vendas}">
                <p class="text-center">Nenhuma venda finalizada encontrada.</p>
            </c:if>

            <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>