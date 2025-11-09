package br.edu.ifpr.irati.ads.servlet;

import br.edu.ifpr.irati.ads.dao.HibernateUtil;
import br.edu.ifpr.irati.ads.dao.GenericDao;
import br.edu.ifpr.irati.ads.model.Proposta;
import br.edu.ifpr.irati.ads.util.UrlParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "relatoriocontroleservlet", urlPatterns = {
        "/relatorio/propostas"
})
public class RelatorioControleServlet extends HttpServlet {

    private Session session;

    @Override
    public void init() throws ServletException {
        session = HibernateUtil.getSessionFactory().openSession();
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            UrlParser urlParser = new UrlParser(req.getServletPath());
            String relatorioType = urlParser.getMethod();

            switch (relatorioType) {
                case "propostas":
                    gerarRelatorioPropostas(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Relatório não encontrado");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Erro ao gerar relatório: " + e.getMessage(), e);
        }
    }

    private void gerarRelatorioPropostas(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Usa o GenericDao para buscar todas as propostas
        GenericDao<Proposta> propostaDao = new GenericDao<>(Proposta.class, session);
        List<Proposta> propostas = propostaDao.buscarTodos();

        // Salva a lista na requisição para ser exibida pelo JSP
        req.setAttribute("propostas", propostas);

        // CORREÇÃO: Usando ServletContext para resolver o caminho de forma mais robusta.
        req.getServletContext().getRequestDispatcher("/relatoriopropostas.jsp").forward(req, resp);
    }
}