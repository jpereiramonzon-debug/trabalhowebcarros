package br.edu.ifpr.irati.ads.dao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

@WebServlet(name = "db_parameters", loadOnStartup = 0, urlPatterns = "/db")
public class DBParametersServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        DBProperties.loadProperties(this.getServletContext());
        System.out.println("Database properties loaded");
    }
}
