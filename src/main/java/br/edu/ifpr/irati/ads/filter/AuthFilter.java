package br.edu.ifpr.irati.ads.filter;

import br.edu.ifpr.irati.ads.util.JwtProperties;
import br.edu.ifpr.irati.ads.util.JwtUtils;
import io.jsonwebtoken.Claims;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Properties;


@WebFilter(urlPatterns = {"/home.jsp",
        "/usuario/*",
        "/formusuario.jsp",
        "/veiculo/*", // NOVO: Protege CRUD Veículo
        "/formveiculo.jsp", // NOVO: Protege JSP Veículo
        "/proposta/*", // NOVO: Protege CRUD Proposta
        "/formproposta.jsp", // NOVO: Protege JSP Proposta
        "/relatorio/*", // NOVO: Protege Relatórios
        "/simulacao/*", // NOVO: Protege Simulação
        "/simulacaofinanciamento.jsp" // NOVO: Protege JSP Simulação
})
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
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        Cookie token = getToken(req);

        JwtProperties.loadProperties(req.getServletContext());
        Properties props = JwtProperties.getProperties();
        boolean valido = validarToken(token, props);

        if (valido){
            filterChain.doFilter(servletRequest, servletResponse);
        }else{
            // CORREÇÃO ESSENCIAL: Redireciona para o caminho ABSOLUTO.
            String contextPath = req.getContextPath();
            resp.sendRedirect(contextPath + "/login.jsp");
        }

    }

    private boolean validarToken(Cookie token, Properties props) {
        boolean valido = false;
        if (token != null) {
            //buscar no banco de dados se existe o token
            //solicitado e a qual usuário corresponde
            String jwtToken = token.getValue();
            String jwtPasswd = props.getProperty("jwt_passwd");

            //validar
            try{
                JwtUtils.validateToken(jwtToken, jwtPasswd);
                valido = true;
            }catch (Exception e){
                System.out.println(e.getMessage());
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