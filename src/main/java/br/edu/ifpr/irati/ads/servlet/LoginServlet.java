package br.edu.ifpr.irati.ads.servlet;

import br.edu.ifpr.irati.ads.util.JwtProperties;
import br.edu.ifpr.irati.ads.util.JwtUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Properties;

@WebServlet(name = "loginservlet", urlPatterns = "/loginservlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String usuario = req.getParameter("usuario");
        String senha = req.getParameter("senha");

        //verificar no banco de dados se há um usuario como
        //o informado e se sua senha está correta
        if (usuario.equals("admin") && senha.equals("admin")) {

            JwtProperties.loadProperties(req.getServletContext());
            Properties props = JwtProperties.getProperties();
            String[] roles = {"admin"};
            String chaveAcesso =
                    JwtUtils.generateToken(usuario,
                                           roles,
                                           Integer.parseInt(props.getProperty("jwt_default_expiration")),
                                           props.getProperty("jwt_passwd"));
            Cookie token = new Cookie("token", chaveAcesso);
            token.setMaxAge(Integer.parseInt(props.getProperty("jwt_default_expiration"))/1000);
            resp.addCookie(token);
        }else{
            resp.sendRedirect("login.jsp");
        }
        resp.sendRedirect("home.jsp");
    }
}
