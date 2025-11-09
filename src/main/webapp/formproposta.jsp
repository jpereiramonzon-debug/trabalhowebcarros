<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

    <%  if (proposta.getId() > 0){ %>
    <script type="text/javascript">
        window.onload = () => {
            const cadastroModal = new bootstrap.Modal('#cadastroModal');
            cadastroModal.show();
        }
    </script>
    <%  } %>
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
                <% for (Proposta p: propostas){ %>
                <tr>
                    <td><%=p.getDataProposta().toLocalDate()%></td>
                    <td><%=p.getVeiculo().getMarca() + " " + p.getVeiculo().getModelo()%></td>
                    <td><%=p.getCliente().getNome()%></td>
                    <td><%=p.getVendedor().getNome()%></td>
                    <td>R$ <%=String.format("%,.2f", p.getValorProposto())%></td>
                    <td><%=p.getStatusNegociacao()%></td>
                    <td class="text-end">
                        <a class="btn btn-success btn-sm" href="proposta/findbyid?id=<%=p.getId()%>" role="button">Alterar</a>
                        <a class="btn btn-danger btn-sm" href="proposta/delete?id=<%=p.getId()%>" role="button">Excluir</a>

                        <% if ("ACEITA".equals(p.getStatusNegociacao())) { %>
                        <a class="btn btn-info btn-sm text-white" href="proposta/gerarcontrato?id=<%=p.getId()%>" target="_blank" role="button">Gerar Contrato (PDF)</a>
                        <% } %>
                    </td>
                </tr>
                <%}%>
                </tbody>
            </table>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cadastroModal">
                Nova Proposta
            </button>
            <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
        </div>
    </div>
</div>

<form method="post" action="proposta/<%=proposta.getId()==0?"create":"update"%>">
    <div class="modal fade" tabindex="-1" id="cadastroModal" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title" id="modalLabel">Proposta</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="id" name="id" value="<%=proposta.getId()%>">

                    <div class="mb-3">
                        <label for="veiculoId" class="form-label">Veículo</label>
                        <select class="form-select" id="veiculoId" name="veiculoId" required>
                            <option value="">Selecione um Veículo</option>
                            <% for (Veiculo v : veiculosDisponiveis) { %>
                            <option value="<%=v.getId()%>" <%= v.getId().equals(proposta.getVeiculo().getId()) ? "selected" : "" %>>
                                <%=v.getMarca()%> <%=v.getModelo()%> (R$ <%=String.format("%,.2f", v.getPreco())%>)
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="clienteId" class="form-label">Cliente (Comprador)</label>
                        <select class="form-select" id="clienteId" name="clienteId" required>
                            <option value="">Selecione um Cliente</option>
                            <% for (Usuario u : clientesDisponiveis) {
                                if (!"ADMIN".equals(u.getTipo()) && !"VENDEDOR".equals(u.getTipo())) { %>
                            <option value="<%=u.getId()%>" <%= u.getId().equals(proposta.getCliente().getId()) ? "selected" : "" %>>
                                <%=u.getNome()%> (<%=u.getTipo()%>)
                            </option>
                            <% }} %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="vendedorId" class="form-label">Vendedor (Usuário do Sistema)</label>
                        <select class="form-select" id="vendedorId" name="vendedorId" required>
                            <option value="">Selecione um Vendedor</option>
                            <% for (Usuario u : vendedoresDisponiveis) {
                                if ("ADMIN".equals(u.getTipo()) || "VENDEDOR".equals(u.getTipo())) { %>
                            <option value="<%=u.getId()%>" <%= u.getId().equals(proposta.getVendedor().getId()) ? "selected" : "" %>>
                                <%=u.getNome()%> (<%=u.getTipo()%>)
                            </option>
                            <% }} %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="valorProposto" class="form-label">Valor Proposto (R$)</label>
                        <input type="number" step="0.01" class="form-control" id="valorProposto" name="valorProposto" value="<%=proposta.getValorProposto()%>" required min="0">
                    </div>

                    <% if (proposta.getId() > 0) { %>
                    <div class="mb-3">
                        <label for="statusNegociacao" class="form-label">Status da Negociação</label>
                        <select class="form-select" id="statusNegociacao" name="statusNegociacao" required>
                            <option value="EM_NEGOCIACAO" <%= "EM_NEGOCIACAO".equals(proposta.getStatusNegociacao()) ? "selected" : "" %>>Em Negociação</option>
                            <option value="ACEITA" <%= "ACEITA".equals(proposta.getStatusNegociacao()) ? "selected" : "" %>>Aceita</option>
                        </select>
                        <div class="form-text">Para gerar o contrato, o status deve ser ACEITA.</div>
                    </div>
                    <% } %>

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
    hibernateSession.close();
%>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>