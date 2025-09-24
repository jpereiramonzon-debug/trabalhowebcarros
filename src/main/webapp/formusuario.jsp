<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.edu.ifpr.irati.ads.model.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    List<Usuario> usuarios = (List<Usuario>) session.getAttribute("usuarios");
    if (usuario == null){
        usuario = new Usuario();
    }
    if (usuarios == null){
        usuarios = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Usuários</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
          crossorigin="anonymous">
    <%  if (usuario.getId() > 0){ %>
        <script type="text/javascript">
            window.onload = () => {
                const cadastroModal = new bootstrap.Modal('#cadastroModal');
                cadastroModal.show();
            }
        </script>

    <%  } %>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col">
                <table class="table table-hover table-responsive">
                    <thead>
                    <tr>
                        <th scope="col">Nome</th>
                        <th scope="col">Email</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Usuario u: usuarios){ %>
                    <tr>
                        <td><%=u.getNome()%></td>
                        <td><%=u.getEmail()%></td>
                        <td class="text-end">
                            <a class="btn btn-success" href="usuario/findbyid?id=<%=u.getId()%>" role="button">Alterar</a>
                            <a class="btn btn-danger" href="usuario/delete?id=<%=u.getId()%>" role="button">Excluir</a>
                        </td>
                    </tr>
                    <%}%>
                    </tbody>
                </table>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#cadastroModal">
                    Novo usuário
                </button>
            </div>
        </div>
    </div>

    <form method="post" action="usuario/<%=usuario.getId()==0?"create":"update"%>">
        <div class="modal" tabindex="-1" id="cadastroModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Usuário</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden"
                               class="form-control"
                               id="id"
                               name="id"
                               value="<%=usuario.getId()%>">
                        <div class="mb-3">
                            <label for="nome" class="form-label">Nome</label>
                            <input type="text"
                                   class="form-control"
                                   id="nome"
                                   aria-describedby="nomeHelp"
                                   name="nome"
                                   value="<%=usuario.getNome()%>">
                            <div id="nomeHelp" class="form-text">Informe seu nome completo.</div>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email"
                                   class="form-control"
                                   id="email"
                                   aria-describedby="emailHelp"
                                   name="email"
                                   value="<%=usuario.getEmail()%>">
                            <div id="emailHelp" class="form-text">Utilize seu e-mail empresarial.</div>
                        </div>
                        <div class="mb-3">
                            <label for="senha" class="form-label">Senha</label>
                            <input type="password"
                                   class="form-control"
                                   id="senha"
                                   name="senha"
                                   aria-describedby="senhaHelp"
                                   value="<%=usuario.getSenha()%>">
                            <div id="senhaHelp" class="form-text">Informe uma senha entre 6 e 10 caracteres.</div>
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
