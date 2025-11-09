package br.edu.ifpr.irati.ads.servlet;

import br.edu.ifpr.irati.ads.dao.HibernateUtil;
import br.edu.ifpr.irati.ads.service.Service;
import br.edu.ifpr.irati.ads.service.ServiceFactory;
import br.edu.ifpr.irati.ads.service.PropostaService;
import br.edu.ifpr.irati.ads.util.UrlParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;

@WebServlet(name = "crudcontroleservlet", urlPatterns = {
        "/usuario/findbyid",
        "/usuario/findall",
        "/usuario/create",
        "/usuario/update",
        "/usuario/delete",
        "/veiculo/findbyid",
        "/veiculo/findall",
        "/veiculo/create",
        "/veiculo/update",
        "/veiculo/delete",
        "/proposta/findbyid",
        "/proposta/findall",
        "/proposta/create",
        "/proposta/update",
        "/proposta/delete",
        "/proposta/gerarcontrato"
})
public class CRUDControleServlet extends HttpServlet {

    // REMOVIDO: A variável 'session' como campo de classe

    @Override
    public void init() throws ServletException {
        // REMOVIDO: A abertura única de sessão.
        // A sessão será aberta e fechada por requisição.
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Session session = null; // DECLARAÇÃO DA SESSÃO LOCAL

        try{
            // ABRINDO SESSÃO POR REQUISIÇÃO (UNIT OF WORK)
            session = HibernateUtil.getSessionFactory().openSession();

            UrlParser urlParser = new UrlParser(req.getServletPath());
            Service service = ServiceFactory.getService(urlParser.getEntity());

            switch (urlParser.getMethod()){
                case "findbyid":
                    service.findById(req, resp, session);
                    break;
                case "findall":
                    service.findAll(req, resp, session);
                    break;
                case "create":
                    service.create(req, resp, session);
                    break;
                case "update":
                    service.update(req, resp, session);
                    break;
                case "delete":
                    service.delete(req, resp, session);
                    break;
                case "gerarcontrato":
                    if (service instanceof PropostaService) {
                        ((PropostaService) service).gerarContrato(req, resp, session);
                    } else {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Funcionalidade de contrato não disponível.");
                    }
                    break;
                default:
                    //enviar para uma tela de 404.
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Método não encontrado.");
                    break;
            }


        }catch (Exception e){
            throw new ServletException(e.getMessage());
        }finally {
            // FECHANDO SESSÃO APÓS A REQUISIÇÃO
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}