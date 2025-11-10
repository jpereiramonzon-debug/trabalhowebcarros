<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Imports e declarações de variáveis locais removidos --%>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Usuários/Clientes</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">

    <c:if test="${sessionScope.usuario.id > 0}">
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
    <h2 class="mb-4">Gestão de Usuários e Clientes</h2>
    <div class="row">
        <div class="col">
            <table class="table table-hover table-striped table-responsive">
                <thead class="table-dark">
                <tr>
                    <th scope="col">Nome</th>
                    <th scope="col">Email</th>
                    <th scope="col">CPF</th>
                    <th scope="col">Tipo</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${sessionScope.usuarios}">
                    <tr>
                        <td>${u.nome}</td>
                        <td>${u.email}</td>
                        <td>${u.cpf}</td>
                        <td>${u.tipo}</td>
                        <td class="text-end">
                            <a class="btn btn-success btn-sm" href="usuario/findbyid?id=${u.id}" role="button">Alterar</a>
                            <a class="btn btn-danger btn-sm" href="usuario/delete?id=${u.id}" role="button">Excluir</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cadastroModal">
                Novo Usuário/Cliente
            </button>
            <a href="home.jsp" class="btn btn-secondary">Voltar ao Início</a>
        </div>
    </div>
</div>

<form method="post" action="usuario/${sessionScope.usuario.id == 0 ? 'create' : 'update'}">
    <div class="modal fade" tabindex="-1" id="cadastroModal" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title" id="modalLabel">Usuário/Cliente</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden"
                           class="form-control"
                           id="id"
                           name="id"
                           value="${sessionScope.usuario.id}">
                    <div class="mb-3">
                        <label for="nome" class="form-label">Nome</label>
                        <input type="text"
                               class="form-control"
                               id="nome"
                               aria-describedby="nomeHelp"
                               name="nome"
                               value="${sessionScope.usuario.nome}" required>
                        <div id="nomeHelp" class="form-text">Informe seu nome completo.</div>
                    </div>

                    <div class="mb-3">
                        <label for="cpf" class="form-label">CPF</label>
                        <input type="text"
                               class="form-control"
                               id="cpf"
                               name="cpf"
                               value="${sessionScope.usuario.cpf}" aria-describedby="cpfHelp">
                        <div id="cpfHelp" class="form-text">Para clientes e usuários do sistema.</div>
                    </div>

                    <div class="mb-3">
                        <label for="telefone" class="form-label">Telefone</label>
                        <input type="tel"
                               class="form-control"
                               id="telefone"
                               name="telefone"
                               value="${sessionScope.usuario.telefone}">
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email"
                               class="form-control"
                               id="email"
                               aria-describedby="emailHelp"
                               name="email"
                               value="${sessionScope.usuario.email}" required>
                        <div id="emailHelp" class="form-text">Utilize seu e-mail (necessário para login ou contato).</div>
                    </div>

                    <div class="mb-3">
                        <label for="tipo" class="form-label">Tipo (Perfil)</label>
                        <select class="form-select" id="tipo" name="tipo" required onchange="toggleSenhaRequirement()">
                            <option value="COMPRADOR" ${sessionScope.usuario.tipo == 'COMPRADOR' ? 'selected' : ''}>Comprador</option>
                            <option value="VENDEDOR" ${sessionScope.usuario.tipo == 'VENDEDOR' ? 'selected' : ''}>Vendedor (Usuário do Sistema)</option>
                            <option value="ADMIN" ${sessionScope.usuario.tipo == 'ADMIN' ? 'selected' : ''}>Administrador (Usuário do Sistema)</option>
                        </select>
                        <div id="tipoHelp" class="form-text">Define o papel da pessoa no sistema ou transação.</div>
                    </div>

                    <div class="mb-3">
                        <label for="senha" class="form-label">Senha</label>
                        <input type="password"
                               class="form-control"
                               id="senha"
                               name="senha"
                               aria-describedby="senhaHelp"
                               value="${sessionScope.usuario.senha}"
                        >
                        <div id="senhaHelp" class="form-text">Informe uma senha. Obrigatório para Vendedor e Administrador.</div>
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

<script type="text/javascript">
    /**
     * Controla o atributo 'required' do campo senha baseado no tipo de usuário selecionado.
     */
    function toggleSenhaRequirement() {
        const tipoSelect = document.getElementById('tipo');
        const senhaInput = document.getElementById('senha');
        const tipo = tipoSelect.value;

        const isSystemUser = (tipo === 'ADMIN' || tipo === 'VENDEDOR');

        if (isSystemUser) {
            senhaInput.setAttribute('required', 'required');
        } else {
            senhaInput.removeAttribute('required');
        }
    }

    window.onload = function() {
        <c:if test="${sessionScope.usuario.id > 0}">
        const cadastroModal = new bootstrap.Modal('#cadastroModal');
        cadastroModal.show();
        </c:if>

        toggleSenhaRequirement();
    };

    document.getElementById('tipo').addEventListener('change', toggleSenhaRequirement);
</script>
</body>
</html>