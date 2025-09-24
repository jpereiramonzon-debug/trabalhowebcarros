package br.edu.ifpr.irati.ads.service;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;

public interface Service {

    public void findById(HttpServletRequest req, HttpServletResponse resp, Session session)
            throws ServletException, IOException;

    public void findAll(HttpServletRequest req, HttpServletResponse resp, Session session)
            throws ServletException, IOException;

    public void update(HttpServletRequest req, HttpServletResponse resp, Session session)
            throws ServletException, IOException;

    public void create(HttpServletRequest req, HttpServletResponse resp, Session session)
            throws ServletException, IOException;

    public void delete(HttpServletRequest req, HttpServletResponse resp, Session session)
            throws ServletException, IOException;
}
