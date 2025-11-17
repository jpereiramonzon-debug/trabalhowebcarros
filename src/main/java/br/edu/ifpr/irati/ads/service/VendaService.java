package br.edu.ifpr.irati.ads.service;

import br.edu.ifpr.irati.ads.dao.Dao;
import br.edu.ifpr.irati.ads.dao.GenericDao;
import br.edu.ifpr.irati.ads.model.Proposta;
import br.edu.ifpr.irati.ads.model.Venda;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;

public class VendaService implements Service {

    private final String REDIRECT_PAGE = "../formvenda.jsp";

    @Override
    public void findById(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Venda> dao = new GenericDao<>(Venda.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        req.getSession().setAttribute("venda", dao.buscarPorId(id));
        req.getSession().setAttribute("vendas", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void findAll(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Venda> dao = new GenericDao<>(Venda.class, session);
        req.getSession().setAttribute("venda", new Venda());
        req.getSession().setAttribute("vendas", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void update(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Venda> dao = new GenericDao<>(Venda.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        Venda venda = dao.buscarPorId(id);

        dao.alterar(venda);

        req.getSession().setAttribute("venda", new Venda());
        req.getSession().setAttribute("vendas", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    @Override
    public void create(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Vendas são criadas apenas através de Propostas Aceitas.");
    }

    @Override
    public void delete(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
        Dao<Venda> dao = new GenericDao<>(Venda.class, session);
        Long id = Long.parseLong(req.getParameter("id"));

        Venda venda = dao.buscarPorId(id);
        dao.excluir(venda);

        req.getSession().setAttribute("venda", new Venda());
        req.getSession().setAttribute("vendas", dao.buscarTodos());
        resp.sendRedirect(REDIRECT_PAGE);
    }

    public void finalizarVenda(Venda venda, Session session) throws ServletException, IOException {
        Dao<Venda> dao = new GenericDao<>(Venda.class, session);
        dao.salvar(venda);
    }


     //Implementação da Baixa Final (UPDATE de Status).

    public void darBaixa(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Venda> dao = new GenericDao<>(Venda.class, session);
        Dao<Proposta> propostaDao = new GenericDao<>(Proposta.class, session);

        Long id = Long.parseLong(req.getParameter("idVendaBaixa"));

        Venda venda = dao.buscarPorId(id);

        //Proposta vinculada para FINALIZADA
        Proposta proposta = venda.getPropostaOrigem();
        proposta.setStatusNegociacao("FINALIZADA");
        propostaDao.alterar(proposta);

        //status da Venda
        venda.setStatusVenda("CONCLUIDA");
        dao.alterar(venda);

        findAll(req, resp, session);
    }


     //Funcionalidade de geração de Contrato/Recibo (HTML formatado) baseado na Venda.

    public void gerarPdf(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {

        Dao<Venda> dao = new GenericDao<>(Venda.class, session);
        Long id = Long.parseLong(req.getParameter("id"));
        Venda venda = dao.buscarPorId(id);

        resp.setContentType("text/html;charset=UTF-8");

        String contratoContent = "<html>" +
                "<head><title>Recibo de Venda " + venda.getId() + "</title>" +
                "<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css' rel='stylesheet'>" +
                "</head>" +
                "<body><div class='container mt-5'>" +
                "<h2 class='text-center'>RECIBO / CONTRATO DE VENDA FINALIZADA</h2>" +
                "<hr>" +
                "<h4 class='mt-4'>Detalhes da Transação</h4>" +
                "<p><strong>ID da Venda:</strong> " + venda.getId() + "</p>" +
                "<p><strong>Data da Venda:</strong> " + venda.getDataVenda().toLocalDate() + "</p>" +
                "<p class='fs-4 text-success'><strong>VALOR FINAL DA VENDA:</strong> R$ " + String.format("%,.2f", venda.getValorFinal()) + "</p>" +
                "<p><strong>Status:</strong> " + venda.getStatusVenda() + "</p>" +
                "<p><strong>Proposta de Origem ID:</strong> " + venda.getPropostaOrigem().getId() + "</p>" +
                "<h4 class='mt-5'>Dados do Cliente/Comprador</h4>" +
                "<p><strong>Nome:</strong> " + venda.getCliente().getNome() + "</p>" +
                "<p><strong>Email:</strong> " + venda.getCliente().getEmail() + "</p>" +
                "<p><strong>CPF:</strong> " + venda.getCliente().getCpf() + "</p>" +
                "<p><strong>Telefone:</strong> " + venda.getCliente().getTelefone() + "</p>" +
                "<h4 class='mt-5'>Dados do Veículo</h4>" +
                "<p><strong>Marca:</strong> " + venda.getVeiculo().getMarca() + "</p>" +
                "<p><strong>Modelo:</strong> " + venda.getVeiculo().getModelo() + "</p>" + // CORRIGIDO: de getModelos() para getModelo()
                "<p><strong>Ano:</strong> " + venda.getVeiculo().getAno() + "</p>" +
                "<p><strong>Quilometragem:</strong> " + venda.getVeiculo().getQuilometragem() + " Km</p>" +
                "<p><strong>Preço de Tabela:</strong> R$ " + String.format("%,.2f", venda.getVeiculo().getPreco()) + "</p>" +
                "<h4 class='mt-5'>Dados do Vendedor</h4>" +
                "<p><strong>Nome:</strong> " + venda.getVendedor().getNome() + "</p>" +
                "<p><strong>Email:</strong> " + venda.getVendedor().getEmail() + "</p>" +
                "<hr class='mt-5'>" +
                "<p class='text-center'>Este documento formaliza a venda concluída e o valor pago.</p>" +
                "</div></body></html>";

        resp.getWriter().write(contratoContent);
        resp.getWriter().flush();
    }
}