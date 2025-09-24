package br.edu.ifpr.irati.ads.util;

import com.mysql.cj.xdevapi.Client;
import io.jsonwebtoken.Claims;

public class JwtTeste {

    public static void main(String[] args) {

        String subject = "admin";
        String[] roles = {"adm","coord","comum"};

        System.out.println("*** Gerando o token ***");
        String token = JwtUtils.generateToken(subject, roles, 60000, "123");
        System.out.println(token);

        System.out.println("*** Validando o token recebido ***");
        try{
            Claims claims = JwtUtils.validateToken(token, "123");
            System.out.println("Subject : " + claims.getSubject());
            System.out.println("Expiration : " + claims.getExpiration());
            System.out.println("IssuedAt: " + claims.getIssuedAt());
            System.out.println("Roles : " +
                        claims.getAudience().toString()
                        .replace("[", "")
                        .replace("]", "")
                        .split(",")[0]);
        }catch (Exception e){
            System.out.println("Jwt token inválido" + e.getMessage());
        }

    }

}
