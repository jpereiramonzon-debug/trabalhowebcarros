package br.edu.ifpr.irati.ads.service;

import br.edu.ifpr.irati.ads.dao.Dao;
import br.edu.ifpr.irati.ads.dao.GenericDao;
import br.edu.ifpr.irati.ads.model.Proposta;
import br.edu.ifpr.irati.ads.model.Veiculo;
import br.edu.ifpr.irati.ads.model.Usuario;
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

        // Busca as entidades relacionadas
        Proposta proposta = propostaDao.buscarPorId(id);
        Veiculo veiculo = veiculoDao.buscarPorId(veiculoId);
        Usuario cliente = usuarioDao.buscarPorId(clienteId);
        Usuario vendedor = usuarioDao.buscarPorId(vendedorId);

        // Atualiza os campos
        proposta.setVeiculo(veiculo);
        proposta.setCliente(cliente);
        proposta.setVendedor(vendedor);
        proposta.setValorProposto(valorProposto);
        proposta.setStatusNegociacao(statusNegociacao);

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
        // O status inicial deve ser EM_NEGOCIACAO, pois removemos ORCAMENTO
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

    /**
     * NOVO: Funcionalidade não-CRUD de geração de Contrato (HTML formatado).
     */
    public void gerarContrato(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Proposta> dao = new GenericDao<>(Proposta.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        Proposta proposta = dao.buscarPorId(id);

        // 1. Verifica se a proposta foi aceita antes de gerar o contrato
        if (!"ACEITA".equals(proposta.getStatusNegociacao())) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Contrato só pode ser gerado para propostas ACEITAS.");
            return;
        }

        // 2. CORREÇÃO: Define o tipo de conteúdo como HTML
        resp.setContentType("text/html;charset=UTF-8");
        // O cabeçalho Content-Disposition é removido para que o browser abra na tela

        // 3. Geração do conteúdo HTML formatado com os dados da proposta
        String contratoContent = "<html>" +
                "<head><title>Contrato da Proposta " + proposta.getId() + "</title>" +
                "<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css' rel='stylesheet'>" +
                "</head>" +
                "<body><div class='container mt-5'>" +
                "<h2 class='text-center'>CONTRATO DE COMPRA E VENDA DE VEÍCULO</h2>" +
                "<hr>" +

                "<h4 class='mt-4'>Detalhes da Proposta</h4>" +
                "<p><strong>ID:</strong> " + proposta.getId() + "</p>" +
                "<p><strong>Data de Geração:</strong> " + proposta.getDataProposta().toLocalDate() + "</p>" +
                "<p class='fs-4 text-success'><strong>VALOR FINAL ACORDADO:</strong> R$ " + String.format("%,.2f", proposta.getValorProposto()) + "</p>" +

                "<h4 class='mt-5'>Dados do Cliente/Comprador</h4>" +
                "<p><strong>Nome:</strong> " + proposta.getCliente().getNome() + "</p>" +
                "<p><strong>Email:</strong> " + proposta.getCliente().getEmail() + "</p>" +
                "<p><strong>CPF:</strong> " + proposta.getCliente().getCpf() + "</p>" +
                "<p><strong>Telefone:</strong> " + proposta.getCliente().getTelefone() + "</p>" +

                "<h4 class='mt-5'>Dados do Veículo</h4>" +
                "<p><strong>Marca:</strong> " + proposta.getVeiculo().getMarca() + "</p>" +
                "<p><strong>Modelo:</strong> " + proposta.getVeiculo().getModelo() + "</p>" +
                "<p><strong>Ano:</strong> " + proposta.getVeiculo().getAno() + "</p>" +
                "<p><strong>Quilometragem:</strong> " + proposta.getVeiculo().getQuilometragem() + " Km</p>" +
                "<p><strong>Preço de Venda:</strong> R$ " + String.format("%,.2f", proposta.getVeiculo().getPreco()) + "</p>" +

                "<h4 class='mt-5'>Dados do Vendedor</h4>" +
                "<p><strong>Nome:</strong> " + proposta.getVendedor().getNome() + "</p>" +
                "<p><strong>Email:</strong> " + proposta.getVendedor().getEmail() + "</p>" +

                "<hr class='mt-5'>" +
                "<p class='text-center'>Este documento formaliza a negociação conforme o valor proposto e as condições acordadas.</p>" +
                "</div></body></html>";

        resp.getWriter().write(contratoContent);
        resp.getWriter().flush();

        // Nenhuma redireção de volta
    }
}