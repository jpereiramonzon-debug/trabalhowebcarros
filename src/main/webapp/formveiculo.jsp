<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Imports e declarações de variáveis locais removidos --%>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Veículos</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">

    <c:if test="${sessionScope.veiculo.id > 0}">
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
    <h2 class="mb-4">Gestão de Veículos</h2>
    <div class="row">
        <div class="col">
            <table class="table table-hover table-striped table-responsive">
                <thead class="table-dark">
                <tr>
                    <th scope="col">Marca</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">Ano</th>
                    <th scope="col">Preço</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${sessionScope.veiculos}">
                    <tr>
                        <td>${v.marca}</td>
                        <td>${v.modelo}</td>
                        <td>${v.ano}</td>
                        <td>R$ <fmt:formatNumber value="${v.preco}" pattern="#,##0.00"/></td>
                        <td class="text-end">
                            <a class="btn btn-success btn-sm" href="veiculo/findbyid?id=${v.id}" role="button">Alterar</a>
                            <a class="btn btn-danger btn-sm" href="veiculo/delete?id=${v.id}" role="button">Excluir</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cadastroModal">
                Novo Veículo
            </button>
            <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
        </div>
    </div>
</div>

<form method="post" action="veiculo/${sessionScope.veiculo.id == 0 ? 'create' : 'update'}">
    <div class="modal fade" tabindex="-1" id="cadastroModal" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title" id="modalLabel">Veículo</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden"
                           id="id"
                           name="id"
                           value="${sessionScope.veiculo.id}">

                    <div class="mb-3">
                        <label for="marca" class="form-label">Marca</label>
                        <input type="text" class="form-control" id="marca" name="marca" value="${sessionScope.veiculo.marca}" required>
                    </div>
                    <div class="mb-3">
                        <label for="modelo" class="form-label">Modelo</label>
                        <input type="text" class="form-control" id="modelo" name="modelo" value="${sessionScope.veiculo.modelo}" required>
                    </div>
                    <div class="mb-3">
                        <label for="ano" class="form-label">Ano</label>
                        <input type="number" class="form-control" id="ano" name="ano" value="${sessionScope.veiculo.ano}" required min="1900" max="2100">
                    </div>
                    <div class="mb-3">
                        <label for="quilometragem" class="form-label">Quilometragem (Km)</label>
                        <input type="number" class="form-control" id="quilometragem" name="quilometragem" value="${sessionScope.veiculo.quilometragem}" required min="0">
                    </div>
                    <div class="mb-3">
                        <label for="preco" class="form-label">Preço (R$)</label>
                        <input type="number" step="0.01" class="form-control" id="preco" name="preco" value="${sessionScope.veiculo.preco}" required min="0">
                    </div>
                    <div class="mb-3">
                        <label for="fotosUrl" class="form-label">URL da Foto</label>
                        <input type="url" class="form-control" id="fotosUrl" name="fotosUrl" value="${sessionScope.veiculo.fotosUrl}">
                        <div id="fotosUrlHelp" class="form-text">Link para a imagem principal do veículo.</div>
                    </div>
                    <div class="mb-3">
                        <label for="historico" class="form-label">Histórico/Detalhes</label>
                        <textarea class="form-control" id="historico" name="historico" rows="3">${sessionScope.veiculo.historico}</textarea>
                        <div id="historicoHelp" class="form-text">Informações sobre o estado e procedência do veículo.</div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Salvar</button>
                </div>
            </div>
        </div>
    </div>
</form>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
</body>
</html>