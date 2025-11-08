<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.edu.ifpr.irati.ads.model.Veiculo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // Busca o Veículo em edição/novo do escopo de sessão
    Veiculo veiculo = (Veiculo) session.getAttribute("veiculo");
    // Busca a lista de Veículos do escopo de sessão
    List<Veiculo> veiculos = (List<Veiculo>) session.getAttribute("veiculos");

    // Inicializa a variável se estiver nula
    if (veiculo == null){
        veiculo = new Veiculo();
    }
    if (veiculos == null){
        veiculos = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Veículos</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">

    <%  if (veiculo.getId() > 0){ %>
    <script type="text/javascript">
        window.onload = () => {
            // Abre o modal automaticamente se um Veículo estiver em edição (ID > 0)
            const cadastroModal = new bootstrap.Modal('#cadastroModal');
            cadastroModal.show();
        }
    </script>
    <%  } %>
</head>
<body>
<div class="container">
    <h2 class="mt-4 mb-4">Gestão de Veículos</h2>
    <div class="row">
        <div class="col">
            <table class="table table-hover table-responsive">
                <thead>
                <tr>
                    <th scope="col">Marca</th>
                    <th scope="col">Modelo</th>
                    <th scope="col">Ano</th>
                    <th scope="col">Preço</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <% for (Veiculo v: veiculos){ %>
                <tr>
                    <td><%=v.getMarca()%></td>
                    <td><%=v.getModelo()%></td>
                    <td><%=v.getAno()%></td>
                    <td>R$ <%=String.format("%,.2f", v.getPreco())%></td>
                    <td class="text-end">
                        <a class="btn btn-success" href="veiculo/findbyid?id=<%=v.getId()%>" role="button">Alterar</a>
                        <a class="btn btn-danger" href="veiculo/delete?id=<%=v.getId()%>" role="button">Excluir</a>
                    </td>
                </tr>
                <%}%>
                </tbody>
            </table>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cadastroModal">
                Novo Veículo
            </button>
            <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
        </div>
    </div>
</div>

<form method="post" action="veiculo/<%=veiculo.getId()==0?"create":"update"%>">
    <div class="modal fade" tabindex="-1" id="cadastroModal" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">Veículo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden"
                           id="id"
                           name="id"
                           value="<%=veiculo.getId()%>">

                    <div class="mb-3">
                        <label for="marca" class="form-label">Marca</label>
                        <input type="text"
                               class="form-control"
                               id="marca"
                               name="marca"
                               value="<%=veiculo.getMarca()%>" required>
                    </div>
                    <div class="mb-3">
                        <label for="modelo" class="form-label">Modelo</label>
                        <input type="text"
                               class="form-control"
                               id="modelo"
                               name="modelo"
                               value="<%=veiculo.getModelo()%>" required>
                    </div>
                    <div class="mb-3">
                        <label for="ano" class="form-label">Ano</label>
                        <input type="number"
                               class="form-control"
                               id="ano"
                               name="ano"
                               value="<%=veiculo.getAno()%>" required min="1900" max="2100">
                    </div>
                    <div class="mb-3">
                        <label for="quilometragem" class="form-label">Quilometragem (Km)</label>
                        <input type="number"
                               class="form-control"
                               id="quilometragem"
                               name="quilometragem"
                               value="<%=veiculo.getQuilometragem()%>" required min="0">
                    </div>
                    <div class="mb-3">
                        <label for="preco" class="form-label">Preço (R$)</label>
                        <input type="number"
                               step="0.01"
                               class="form-control"
                               id="preco"
                               name="preco"
                               value="<%=veiculo.getPreco()%>" required min="0">
                    </div>
                    <div class="mb-3">
                        <label for="fotosUrl" class="form-label">URL da Foto</label>
                        <input type="url"
                               class="form-control"
                               id="fotosUrl"
                               name="fotosUrl"
                               value="<%=veiculo.getFotosUrl()%>">
                        <div id="fotosUrlHelp" class="form-text">Link para a imagem principal do veículo.</div>
                    </div>
                    <div class="mb-3">
                        <label for="historico" class="form-label">Histórico/Detalhes</label>
                        <textarea class="form-control"
                                  id="historico"
                                  name="historico"
                                  rows="3"><%=veiculo.getHistorico()%></textarea>
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

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
</html>