package br.edu.ifpr.irati.ads.service;

import br.edu.ifpr.irati.ads.dao.Dao;
import br.edu.ifpr.irati.ads.dao.GenericDao;
import br.edu.ifpr.irati.ads.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;

public class UsuarioService implements Service{

    @Override
    public void findById(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Usuario> dao = new GenericDao<>(Usuario.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        req.getSession().setAttribute("usuario", dao.buscarPorId(id));
        req.getSession().setAttribute("usuarios", dao.buscarTodos());
        resp.sendRedirect("../formusuario.jsp");
    }

    @Override
    public void findAll(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Usuario> dao = new GenericDao<>(Usuario.class, session);
        req.getSession().setAttribute("usuario", new Usuario());
        req.getSession().setAttribute("usuarios", dao.buscarTodos());
        resp.sendRedirect("../formusuario.jsp");
    }

    @Override
    public void update(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Usuario> dao = new GenericDao<>(Usuario.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        String  nome = req.getParameter("nome");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        String cpf = req.getParameter("cpf");
        String telefone = req.getParameter("telefone");
        String tipo = req.getParameter("tipo");

        Usuario usuario = dao.buscarPorId(id);
        usuario.setNome(nome);
        usuario.setEmail(email);

        // NOVO: Lógica para NÃO SOBRESCREVER a senha se o campo vier vazio
        if (senha != null && !senha.trim().isEmpty()) {
            usuario.setSenha(senha);
        }


        usuario.setCpf(cpf);
        usuario.setTelefone(telefone);
        usuario.setTipo(tipo);

        dao.alterar(usuario);
        req.getSession().setAttribute("usuario", new Usuario());
        req.getSession().setAttribute("usuarios", dao.buscarTodos());
        resp.sendRedirect("../formusuario.jsp");
    }

    @Override
    public void create(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Usuario> dao = new GenericDao<>(Usuario.class, session);
        Long id = 0L;
        try {
            id = Long.parseLong(req.getParameter("id"));
        } catch (NumberFormatException e) {
            id = 0L;
        }

        String  nome = req.getParameter("nome");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        String cpf = req.getParameter("cpf");
        String telefone = req.getParameter("telefone");
        String tipo = req.getParameter("tipo");

        Usuario usuario = new Usuario(id, nome, email, senha, cpf, telefone, tipo);
        dao.salvar(usuario);
        req.getSession().setAttribute("usuario", new Usuario());
        req.getSession().setAttribute("usuarios", dao.buscarTodos());
        resp.sendRedirect("../formusuario.jsp");

    }

    @Override
    public void delete(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Usuario> dao = new GenericDao<>(Usuario.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        Usuario usuario = dao.buscarPorId(id);
        dao.excluir(usuario);
        req.getSession().setAttribute("usuario", new Usuario());
        req.getSession().setAttribute("usuarios", dao.buscarTodos());
        resp.sendRedirect("../formusuario.jsp");
    }
}