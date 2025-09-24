package br.edu.ifpr.irati.ads.util;

import jakarta.servlet.ServletContext;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class JwtProperties {

    private static Properties properties = null;

    public static void loadProperties(ServletContext sc) {
        Properties props = new Properties();
        try{
            FileInputStream file = new FileInputStream(sc.getResource("/WEB-INF/jwt.properties").getPath());
            props.load(file);
            properties = props;
        }catch (IOException ioe){
            props.setProperty("jwt_passwd","my_jwt_passwd");
            props.setProperty("jwt_default_expiration","60000");
            properties = props;
        }
    }

}
