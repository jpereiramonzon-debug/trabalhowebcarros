package br.edu.ifpr.irati.ads.dao;

import jakarta.servlet.ServletContext;

import java.util.HashMap;
import java.util.Map;

public class DatabaseParams {

    public static Map<String, String> getParams(ServletContext sc){
        Map<String, String> params = new HashMap<>();
        params.put("db_host", sc.getInitParameter("db_host"));
        params.put("db_port", sc.getInitParameter("db_port"));
        params.put("db_schema", sc.getInitParameter("db_schema"));
        params.put("db_user", sc.getInitParameter("db_user"));
        params.put("db_password", sc.getInitParameter("db_password"));
        return params;
    }

}
