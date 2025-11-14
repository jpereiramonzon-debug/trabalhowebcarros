<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="br.edu.ifpr.irati.ads.model.Veiculo" %>
<%@ page import="br.edu.ifpr.irati.ads.dao.GenericDao" %>
<%@ page import="br.edu.ifpr.irati.ads.dao.HibernateUtil" %>
<%@ page import="org.hibernate.Session" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Bloco de código de backend (Java) mantido para gerenciamento da Sessão e DAO
    Session hibernateSession = HibernateUtil.getSessionFactory().openSession();

    // CORREÇÃO: Usando o FQCN (Fully Qualified Class Name) para Veiculo e Proposta na HQL
    String hql = "SELECT v FROM br.edu.ifpr.irati.ads.model.Veiculo v WHERE v.id NOT IN " +
            "(SELECT p.veiculo.id FROM br.edu.ifpr.irati.ads.model.Proposta p WHERE p.statusNegociacao = 'EM_NEGOCIACAO' OR p.statusNegociacao = 'ACEITA')";

    // Busca apenas os veículos disponíveis (não reservados/negociados)
    List<Veiculo> veiculos = hibernateSession.createQuery(hql, Veiculo.class).getResultList();

    if (veiculos == null){
        veiculos = new ArrayList<>();
    }

    // Expõe a lista de veículos e o contexto da aplicação para Expression Language (EL)
    request.setAttribute("veiculos", veiculos);
    request.setAttribute("contextPath", request.getContextPath());
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
<div class="container mt-5">
    <h2 class="mt-4 mb-4">Veículos em Estoque</h2>
    <a href="index.jsp" class="btn btn-secondary mb-4">Voltar ao Portal</a>

    <div class="row">
        <c:forEach var="v" items="${veiculos}">
            <div class="col-md-4 mb-4">

                <div class="card h-100 shadow-sm">
                    <img src="${v.fotosUrl.isEmpty() ? 'https://via.placeholder.com/300x200?text=Sem+Foto' : v.fotosUrl}"
                         class="card-img-top" alt="${v.modelo}" style="object-fit: cover; height: 200px;">

                    <div class="card-body d-flex flex-column">

                        <h5 class="card-title text-dark">${v.marca} ${v.modelo}</h5>

                        <p class="card-text mb-1 text-muted">Ano: ${v.ano} |
                            Km: ${v.quilometragem}</p>

                        <p class="card-text flex-grow-1 small text-truncate">
                            Histórico: ${v.historico.length() > 100 ?
                                v.historico.substring(0, 100).concat('...') : v.historico}
                        </p>

                        <h4 class="text-primary mt-3">R$ <fmt:formatNumber value="${v.preco}" pattern="#,##0.00"/></h4>

                        <a href="${contextPath}/simulacao/calcular" class="btn btn-warning mt-2">Simular Financiamento</a>

                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty veiculos}">
            <p class="text-center">Nenhum veículo encontrado no estoque.</p>
        </c:if>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>
<%
    // Bloco de cleanup mantido
    hibernateSession.close();
%>