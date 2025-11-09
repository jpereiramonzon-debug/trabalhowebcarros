<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.edu.ifpr.irati.ads.model.Veiculo" %>
<%@ page import="br.edu.ifpr.irati.ads.dao.GenericDao" %>
<%@ page import="br.edu.ifpr.irati.ads.dao.HibernateUtil" %>
<%@ page import="org.hibernate.Session" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // Abre uma nova sessão para esta requisição (prática Session-per-Request)
    Session hibernateSession = HibernateUtil.getSessionFactory().openSession();
    GenericDao<Veiculo> veiculoDao = new GenericDao<>(Veiculo.class, hibernateSession);

    // Busca todos os veículos para exibição pública
    List<Veiculo> veiculos = veiculoDao.buscarTodos();

    // Fecha a sessão após buscar os dados
    hibernateSession.close();

    if (veiculos == null){
        veiculos = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Veículos Disponíveis - Portal</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">
</head>
<body>
<div class="container">
    <h2 class="mt-4 mb-4">Veículos em Estoque</h2>
    <a href="index.jsp" class="btn btn-secondary mb-4">Voltar ao Portal</a>

    <div class="row">
        <% for (Veiculo v: veiculos){ %>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <img src="<%=v.getFotosUrl().isEmpty() ? "https://via.placeholder.com/300x200?text=Sem+Foto" : v.getFotosUrl() %>" class="card-img-top" alt="<%=v.getModelo()%>" style="object-fit: cover; height: 200px;">

                <div class="card-body d-flex flex-column">
                    <h5 class="card-title text-dark"><%=v.getMarca()%> <%=v.getModelo()%></h5>

                    <p class="card-text mb-1 text-muted">Ano: <%=v.getAno()%> | Km: <%=v.getQuilometragem()%></p>

                    <p class="card-text flex-grow-1 small text-truncate">Histórico: <%=v.getHistorico().length() > 100 ? v.getHistorico().substring(0, 100) + "..." : v.getHistorico()%></p>

                    <h4 class="text-primary mt-3">R$ <%=String.format("%,.2f", v.getPreco())%></h4>

                    <a href="<%= request.getContextPath() %>/simulacao/calcular" class="btn btn-warning mt-2">Simular Financiamento</a>
                </div>
            </div>
        </div>
        <%}%>
        <% if (veiculos.isEmpty()) { %>
        <p class="text-center">Nenhum veículo encontrado no estoque.</p>
        <% } %>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>