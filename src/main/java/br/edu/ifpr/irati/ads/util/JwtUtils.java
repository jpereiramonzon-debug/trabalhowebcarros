package br.edu.ifpr.irati.ads.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.util.Date;

public class JwtUtils {

    public static String generateToken(String subject,
                                       String[] roles,
                                       long exprirationMillis,
                                       String jwtPasswd){
        jwtPasswd = jwtPasswd + "0".repeat(Math.max(0, 32 - jwtPasswd.length()));
        SecretKey key = Keys.hmacShaKeyFor(jwtPasswd.getBytes());
        return Jwts.builder()
                .setSubject(subject)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis()+exprirationMillis))
                .signWith(SignatureAlgorithm.HS256, key)
                .setAudience(String.join(",", roles))
                .compact();

    }

    public static Claims validateToken(String token, String jwtPasswd){
        jwtPasswd = jwtPasswd + "0".repeat(Math.max(0, 32 - jwtPasswd.length()));
        SecretKey secretKey = Keys.hmacShaKeyFor(jwtPasswd.getBytes());
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

}
