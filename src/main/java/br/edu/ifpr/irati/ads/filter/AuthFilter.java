package br.edu.ifpr.irati.ads.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;


@WebFilter(urlPatterns = {"/home.jsp",
                          "/usuario/*",
                          "/formusuario.jsp"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("Iniciando o Filter");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        // Timestamp
        System.out.println("Data e hora: " + LocalDateTime.now());

        // Endereço IP da requisição
        System.out.println("IP: "+ servletRequest.getRemoteHost());

        /**
         * Lógica da aplicação de filtro
         */
        Cookie token = getToken((HttpServletRequest) servletRequest);

        boolean valido = validarToken(token);

        if (valido){
            filterChain.doFilter(servletRequest, servletResponse);
        }else{
            ((HttpServletResponse) servletResponse).sendRedirect("login.jsp");
        }

    }

    private boolean validarToken(Cookie token) {
        boolean valido = false;
        if (token != null) {
            //buscar no banco de dados se existe o token
            //solicitado e a qual usuário corresponde
            if (token.getValue().equals("8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918")) {
                valido = true;
            }
        }
        return valido;
    }

    private Cookie getToken(HttpServletRequest servletRequest) {
        Cookie[] cookies = servletRequest.getCookies();
        Cookie token = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("token")) {
                    token = cookie;
                    break;
                }
            }
        }
        return token;
    }

    @Override
    public void destroy() {
        System.out.println("Destruindo o Filter");
    }
}
