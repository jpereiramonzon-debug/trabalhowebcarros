package br.edu.ifpr.irati.ads.service;

import br.edu.ifpr.irati.ads.dao.Dao;
import br.edu.ifpr.irati.ads.dao.GenericDao;
import br.edu.ifpr.irati.ads.model.Veiculo;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import jakarta.persistence.PersistenceException; // Import necessário

import java.io.IOException;
import java.math.BigDecimal;

public class VeiculoService implements Service{

    private final String REDIRECT_PAGE = "../formveiculo.jsp";

    @Override
    public void findById(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Veiculo> dao = new GenericDao<>(Veiculo.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        req.getSession().setAttribute("veiculo", dao.buscarPorId(id));
        req.getSession().setAttribute("veiculos", dao.buscarTodos()); // CORREÇÃO: Usando 'veiculos'
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void findAll(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Veiculo> dao = new GenericDao<>(Veiculo.class, session);
        req.getSession().setAttribute("veiculo", new Veiculo());
        req.getSession().setAttribute("veiculos", dao.buscarTodos()); // CORREÇÃO: Usando 'veiculos'
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void update(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Veiculo> dao = new GenericDao<>(Veiculo.class, session);
        Long id = Long.parseLong(req.getParameter("id"));

        // Recupera os parâmetros da requisição
        String marca = req.getParameter("marca");
        String modelo = req.getParameter("modelo");
        Integer ano = Integer.parseInt(req.getParameter("ano"));
        Integer quilometragem = Integer.parseInt(req.getParameter("quilometragem"));
        BigDecimal preco = new BigDecimal(req.getParameter("preco"));
        String fotosUrl = req.getParameter("fotosUrl");
        String historico = req.getParameter("historico");

        // Busca a instância no banco, atualiza e persiste
        Veiculo veiculo = dao.buscarPorId(id);
        veiculo.setMarca(marca);
        veiculo.setModelo(modelo);
        veiculo.setAno(ano);
        veiculo.setQuilometragem(quilometragem);
        veiculo.setPreco(preco);
        veiculo.setFotosUrl(fotosUrl);
        veiculo.setHistorico(historico);

        dao.alterar(veiculo);

        req.getSession().setAttribute("veiculo", new Veiculo());
        req.getSession().setAttribute("veiculos", dao.buscarTodos()); // CORREÇÃO: Usando 'veiculos'
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void create(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Veiculo> dao = new GenericDao<>(Veiculo.class, session);
        Long id = 0L;
        try {
            id = Long.parseLong(req.getParameter("id"));
        } catch (NumberFormatException e) {
            id = 0L;
        }

        String marca = req.getParameter("marca");
        String modelo = req.getParameter("modelo");
        Integer ano = Integer.parseInt(req.getParameter("ano"));
        Integer quilometragem = Integer.parseInt(req.getParameter("quilometragem"));
        BigDecimal preco = new BigDecimal(req.getParameter("preco"));
        String fotosUrl = req.getParameter("fotosUrl");
        String historico = req.getParameter("historico");

        Veiculo veiculo = new Veiculo(id, marca, modelo, ano, quilometragem, preco, fotosUrl, historico);
        dao.salvar(veiculo);

        req.getSession().setAttribute("veiculo", new Veiculo());
        req.getSession().setAttribute("veiculos", dao.buscarTodos()); // CORREÇÃO: Usando 'veiculos'
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void delete(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Veiculo> dao = new GenericDao<>(Veiculo.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        Veiculo veiculo = dao.buscarPorId(id);

        try {
            dao.excluir(veiculo);
        } catch (PersistenceException e) {
            //chave estrangeira
            String errorMessage = "Impossível excluir o veículo. Ele está vinculado a uma Proposta Aceita/Finalizada ou Em Negociação.";

            //erro no REQUEST scope
            req.setAttribute("errorMessage", errorMessage);

            //erro
            req.getRequestDispatcher("/erro.jsp").forward(req, resp);
            return; // Sai do método
        }
        req.getSession().setAttribute("veiculo", new Veiculo());
        req.getSession().setAttribute("veiculos", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }
}