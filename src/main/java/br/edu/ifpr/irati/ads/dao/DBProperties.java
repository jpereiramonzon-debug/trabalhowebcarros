package br.edu.ifpr.irati.ads.dao;

import jakarta.servlet.ServletContext;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DBProperties {

    private static Properties properties = null;

    static void loadProperties(ServletContext sc) {
        Properties props = new Properties();
        try{
            FileInputStream file = new FileInputStream(sc.getResource("/WEB-INF/db.properties").getPath());
            props.load(file);
            properties = props;
        }catch (IOException ioe){
            props.setProperty("db_host","localhost");
            props.setProperty("db_port","3306");
            props.setProperty("db_schema","db_proj_base");
            props.setProperty("db_user","root");
            props.setProperty("db_password","");
            properties = props;
        }
    }

    public static Properties getProperties(){
        return properties;
    }
}
