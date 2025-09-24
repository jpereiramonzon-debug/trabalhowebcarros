package br.edu.ifpr.irati.ads.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "loginservlet", urlPatterns = "/loginservlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String usuario = req.getParameter("usuario");
        String senha = req.getParameter("senha");

        //verificar no banco de dados se há um usuario como
        //o informado e se sua senha está correta
        if (usuario.equals("admin") && senha.equals("admin")) {
            String chaveAcesso = "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918";
            Cookie token = new Cookie("token", chaveAcesso);
            token.setMaxAge(60);
            resp.addCookie(token);
        }else{
            resp.sendRedirect("login.jsp");
        }
        resp.sendRedirect("home.jsp");
    }
}
