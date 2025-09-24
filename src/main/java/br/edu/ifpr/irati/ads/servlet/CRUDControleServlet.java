package br.edu.ifpr.irati.ads.servlet;

import br.edu.ifpr.irati.ads.dao.HibernateUtil;
import br.edu.ifpr.irati.ads.service.Service;
import br.edu.ifpr.irati.ads.service.ServiceFactory;
import br.edu.ifpr.irati.ads.service.UsuarioService;
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
})
public class CRUDControleServlet extends HttpServlet {

    private Session session;

    @Override
    public void init() throws ServletException {
        session = HibernateUtil.getSessionFactory().openSession();
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try{
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
                default:
                    //enviar para uma tela de 404.
                    break;
            }


        }catch (Exception e){
            throw new ServletException(e.getMessage());
        }

    }
}
