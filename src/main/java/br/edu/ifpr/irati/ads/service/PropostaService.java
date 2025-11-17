package br.edu.ifpr.irati.ads.service;

import br.edu.ifpr.irati.ads.dao.Dao;
import br.edu.ifpr.irati.ads.dao.GenericDao;
import br.edu.ifpr.irati.ads.model.Proposta;
import br.edu.ifpr.irati.ads.model.Veiculo;
import br.edu.ifpr.irati.ads.model.Usuario;
import br.edu.ifpr.irati.ads.model.Venda; // NOVO: Import da classe Venda
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PropostaService implements Service{

    private final String REDIRECT_PAGE = "../formproposta.jsp";

    @Override
    public void findById(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Proposta> dao = new GenericDao<>(Proposta.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        req.getSession().setAttribute("proposta", dao.buscarPorId(id));
        req.getSession().setAttribute("propostas", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void findAll(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Proposta> dao = new GenericDao<>(Proposta.class, session);
        req.getSession().setAttribute("proposta", new Proposta());
        req.getSession().setAttribute("propostas", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void update(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        // DAOs para buscar entidades relacionadas
        Dao<Proposta> propostaDao = new GenericDao<>(Proposta.class, session);
        Dao<Veiculo> veiculoDao = new GenericDao<>(Veiculo.class, session);
        Dao<Usuario> usuarioDao = new GenericDao<>(Usuario.class, session);

        Long id = Long.parseLong(req.getParameter("id"));
        Long veiculoId = Long.parseLong(req.getParameter("veiculoId"));
        Long clienteId = Long.parseLong(req.getParameter("clienteId"));
        Long vendedorId = Long.parseLong(req.getParameter("vendedorId"));
        BigDecimal valorProposto = new BigDecimal(req.getParameter("valorProposto"));
        String statusNegociacao = req.getParameter("statusNegociacao");


        Proposta proposta = propostaDao.buscarPorId(id);
        Veiculo veiculo = veiculoDao.buscarPorId(veiculoId);
        Usuario cliente = usuarioDao.buscarPorId(clienteId);
        Usuario vendedor = usuarioDao.buscarPorId(vendedorId);


        String statusAnterior = proposta.getStatusNegociacao();

        proposta.setVeiculo(veiculo);
        proposta.setCliente(cliente);
        proposta.setVendedor(vendedor);
        proposta.setValorProposto(valorProposto);
        proposta.setStatusNegociacao(statusNegociacao);

        // NOVO: Lógica de transição para Venda
        if ("ACEITA".equals(statusNegociacao) && !"ACEITA".equals(statusAnterior)) {
            try {
                VendaService vendaService = new VendaService();
                Venda novaVenda = new Venda(proposta);
                vendaService.finalizarVenda(novaVenda, session);
            } catch (Exception e) {
                throw new ServletException("Erro ao finalizar Venda (criar registro): " + e.getMessage(), e);
            }
        }

        propostaDao.alterar(proposta);

        req.getSession().setAttribute("proposta", new Proposta());
        req.getSession().setAttribute("propostas", propostaDao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void create(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        // DAOs para buscar entidades relacionadas
        Dao<Proposta> propostaDao = new GenericDao<>(Proposta.class, session);
        Dao<Veiculo> veiculoDao = new GenericDao<>(Veiculo.class, session);
        Dao<Usuario> usuarioDao = new GenericDao<>(Usuario.class, session);

        Long veiculoId = Long.parseLong(req.getParameter("veiculoId"));
        Long clienteId = Long.parseLong(req.getParameter("clienteId"));
        Long vendedorId = Long.parseLong(req.getParameter("vendedorId"));
        BigDecimal valorProposto = new BigDecimal(req.getParameter("valorProposto"));
        String statusNegociacao = "EM_NEGOCIACAO";

        // Busca as entidades relacionadas
        Veiculo veiculo = veiculoDao.buscarPorId(veiculoId);
        Usuario cliente = usuarioDao.buscarPorId(clienteId);
        Usuario vendedor = usuarioDao.buscarPorId(vendedorId);

        // Cria a nova proposta (ID 0L e data atual)
        Proposta proposta = new Proposta(0L, veiculo, cliente, vendedor, LocalDateTime.now(), valorProposto, statusNegociacao);

        propostaDao.salvar(proposta);

        req.getSession().setAttribute("proposta", new Proposta());
        req.getSession().setAttribute("propostas", propostaDao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void delete(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Proposta> dao = new GenericDao<>(Proposta.class, session);
        Long id = Long.parseLong(req.getParameter("id"));

        Proposta proposta = dao.buscarPorId(id);
        dao.excluir(proposta);

        req.getSession().setAttribute("proposta", new Proposta());
        req.getSession().setAttribute("propostas", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }
}