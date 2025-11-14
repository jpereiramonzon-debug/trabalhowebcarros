<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="br.edu.ifpr.irati.ads.model.Proposta" %>
<%@ page import="br.edu.ifpr.irati.ads.model.Veiculo" %>
<%@ page import="br.edu.ifpr.irati.ads.model.Usuario" %>
<%@ page import="br.edu.ifpr.irati.ads.dao.GenericDao" %>
<%@ page import="br.edu.ifpr.irati.ads.dao.HibernateUtil" %>
<%@ page import="org.hibernate.Session" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // Bloco de controle de sessão/dados mantido, conforme a regra de não alterar funcionalidades
    Session hibernateSession = HibernateUtil.getSessionFactory().openSession();
    GenericDao<Veiculo> veiculoDao = new GenericDao<>(Veiculo.class, hibernateSession);
    GenericDao<Usuario> usuarioDao = new GenericDao<>(Usuario.class, hibernateSession);

    List<Veiculo> veiculosDisponiveis = veiculoDao.buscarTodos();
    List<Usuario> clientesDisponiveis = usuarioDao.buscarTodos();
    List<Usuario> vendedoresDisponiveis = usuarioDao.buscarTodos();

    Proposta proposta = (Proposta) session.getAttribute("proposta");
    List<Proposta> propostas = (List<Proposta>) session.getAttribute("propostas");
    if (proposta == null){
        proposta = new Proposta();
    }
    if (propostas == null){
        propostas = new ArrayList<>();
    }

    // Configura variáveis no escopo 'request' para que o EL possa acessá-las
    request.setAttribute("veiculosDisponiveis", veiculosDisponiveis);
    request.setAttribute("clientesDisponiveis", clientesDisponiveis);
    request.setAttribute("vendedoresDisponiveis", vendedoresDisponiveis);
    request.setAttribute("proposta", proposta);
    request.setAttribute("propostas", propostas);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Controle de Propostas</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">

    <c:if test="${proposta.id > 0}">
        <script type="text/javascript">
            window.onload = () => {

                const cadastroModal = new bootstrap.Modal('#cadastroModal');
                cadastroModal.show();
            }
        </script>
    </c:if>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Controle de Propostas</h2>
    <div class="row">
        <div class="col">
            <table class="table table-hover table-striped table-responsive">
                <thead class="table-dark">
                <tr>

                    <th scope="col">Data</th>
                    <th scope="col">Veículo</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Vendedor</th>
                    <th scope="col">Valor</th>

                    <th scope="col">Status</th>
                    <th>Ações</th>
                </tr>
                </thead>
                <tbody>

                <c:forEach var="p" items="${propostas}">
                    <tr>
                        <td>${p.dataProposta.toLocalDate()}</td>
                        <td>${p.veiculo.marca} ${p.veiculo.modelo}</td>
                        <td>${p.cliente.nome}</td>

                        <td>${p.vendedor.nome}</td>
                        <td>R$ <fmt:formatNumber value="${p.valorProposto}" pattern="#,##0.00"/></td>
                        <td>${p.statusNegociacao}</td>
                        <td class="text-end">

                            <a class="btn btn-success btn-sm" href="proposta/findbyid?id=${p.id}" role="button">Alterar</a>
                            <a class="btn btn-danger btn-sm" href="proposta/delete?id=${p.id}" role="button">Excluir</a>
                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cadastroModal">
                Nova Proposta
            </button>

            <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
        </div>
    </div>
</div>

<form method="post" action="proposta/${proposta.id == 0 ?
 'create' : 'update'}">
    <div class="modal fade" tabindex="-1" id="cadastroModal" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title" id="modalLabel">Proposta</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="id" name="id" value="${proposta.id}">

                    <div class="mb-3">

                        <label for="veiculoId" class="form-label">Veículo</label>
                        <select class="form-select" id="veiculoId" name="veiculoId" required>
                            <option value="">Selecione um Veículo</option>
                            <c:forEach var="v" items="${veiculosDisponiveis}">

                                <option value="${v.id}" ${v.id == proposta.veiculo.id ?
                                        'selected' : ''}>
                                        ${v.marca} ${v.modelo} (R$ <fmt:formatNumber value="${v.preco}" pattern="#,##0.00"/>)
                                </option>

                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="clienteId" class="form-label">Cliente (Comprador)</label>

                        <select class="form-select" id="clienteId" name="clienteId" required>
                            <option value="">Selecione um Cliente</option>
                            <c:forEach var="u" items="${clientesDisponiveis}">

                                <c:if test="${u.tipo != 'ADMIN' && u.tipo != 'VENDEDOR'}">
                                    <option value="${u.id}" ${u.id == proposta.cliente.id ?
                                            'selected' : ''}>
                                            ${u.nome} (${u.tipo})
                                    </option>

                                </c:if>
                            </c:forEach>
                        </select>
                    </div>


                    <div class="mb-3">
                        <label for="vendedorId" class="form-label">Vendedor (Usuário do Sistema)</label>
                        <select class="form-select" id="vendedorId" name="vendedorId" required>
                            <option value="">Selecione um Vendedor</option>

                            <c:forEach var="u" items="${vendedoresDisponiveis}">
                                <c:if test="${u.tipo == 'ADMIN' || u.tipo == 'VENDEDOR'}">

                                    <option value="${u.id}" ${u.id == proposta.vendedor.id ? 'selected' : ''}>
                                            ${u.nome} (${u.tipo})
                                    </option>

                                </c:if>
                            </c:forEach>
                        </select>
                    </div>


                    <div class="mb-3">
                        <label for="valorProposto" class="form-label">Valor Proposto (R$)</label>
                        <input type="number" step="0.01" class="form-control" id="valorProposto" name="valorProposto" value="${proposta.valorProposto}" required min="0">
                    </div>


                    <c:if test="${proposta.id > 0}">
                        <div class="mb-3">
                            <label for="statusNegociacao" class="form-label">Status da Negociação</label>

                            <select class="form-select" id="statusNegociacao" name="statusNegociacao" required>
                                <option value="EM_NEGOCIACAO" ${proposta.statusNegociacao == 'EM_NEGOCIACAO' ?
                                        'selected' : ''}>Em Negociação</option>
                                <option value="ACEITA" ${proposta.statusNegociacao == 'ACEITA' ?
                                        'selected' : ''}>Aceita</option>
                                <option value="CANCELADA" ${proposta.statusNegociacao == 'CANCELADA' ?
                                        'selected' : ''}>Cancelada</option>
                            </select>
                            <div class="form-text">O status 'Aceita' irá finalizar a proposta e criar um registro de Venda.</div>
                        </div>

                    </c:if>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Salvar</button>

                </div>
            </div>
        </div>
    </div>
</form>

<%
    // Bloco de cleanup mantido
    hibernateSession.close();
%>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>