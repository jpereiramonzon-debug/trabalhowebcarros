package br.edu.ifpr.irati.ads.util;

public class UrlParser {

    private String entity;

    private String method;

    public UrlParser(String url) throws Exception{
        try{
            String arrayURL[] = url.split("/");
            this.entity = arrayURL[1];
            this.method = arrayURL[2];
        }catch (ArrayIndexOutOfBoundsException e){
            throw new Exception("URL inválida");
        }
    }

    public String getEntity() {
        return entity;
    }

    public String getMethod() {
        return method;
    }
}
