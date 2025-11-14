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
                    <th scope="col">Status</th> <th>Ações</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${vendas}">
                    <tr>
                        <td>${v.id}</td>
                        <td>${v.dataVenda.toLocalDate()}</td>
                        <td>${v.veiculo.marca} ${v.veiculo.modelo}</td>
                        <td>${v.cliente.nome}</td>
                        <td>${v.vendedor.nome}</td>
                        <td>R$ <fmt:formatNumber value="${v.valorFinal}" pattern="#,##0.00"/></td>
                        <td>${v.statusVenda}</td> <td class="text-end">
                            <%-- Botão para gerar o PDF da Venda --%>
                        <a class="btn btn-info btn-sm text-white me-2" href="venda/gerarpdf?id=${v.id}" target="_blank" role="button">Gerar Contrato (PDF)</a>

                            <%-- Condicional: Botão Finalizar Venda só aparece se o status for ATIVA --%>
                        <c:if test="${v.statusVenda == 'ATIVA'}">
                            <button type="button" class="btn btn-success btn-sm" data-bs-toggle="modal"
                                    data-bs-target="#finalizarModal"
                                    onclick="prepararFinalizacao(
                                            '${v.id}',
                                            '${v.cliente.nome}',
                                            '${v.vendedor.nome}',
                                            '${v.veiculo.marca} ${v.veiculo.modelo}',
                                            '<fmt:formatNumber value="${v.valorFinal}" pattern="#,##0.00"/>'
                                            )">
                                Finalizar Venda
                            </button>
                        </c:if>
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

<div class="modal fade" tabindex="-1" id="finalizarModal" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="venda/darbaixa">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="modalLabel">Confirmação de Baixa (Venda Concluída)</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="idVendaBaixa" name="idVendaBaixa">

                    <p class="lead">Confirme a baixa final desta transação. Esta ação remove o registro da lista de Vendas Finalizadas.</p>

                    <div class="mb-3">
                        <label class="form-label">Veículo:</label>
                        <input type="text" class="form-control" id="veiculoDetalhes" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Valor Final:</label>
                        <input type="text" class="form-control" id="valorFinal" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Comprador:</label>
                        <input type="text" class="form-control" id="clienteNome" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Vendedor Responsável:</label>
                        <input type="text" class="form-control" id="vendedorNome" readonly>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-success">Dar Baixa e Concluir</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>

<script type="text/javascript">
    /**
     * Preenche os campos do modal com os dados da venda selecionada, incluindo Veículo e Valor.
     */
    function prepararFinalizacao(id, clienteNome, vendedorNome, veiculoDetalhes, valorFinal) {
        document.getElementById('idVendaBaixa').value = id;
        document.getElementById('clienteNome').value = clienteNome;
        document.getElementById('vendedorNome').value = vendedorNome;
        document.getElementById('veiculoDetalhes').value = veiculoDetalhes;
        document.getElementById('valorFinal').value = valorFinal;
    }
</script>
</body>
</html>