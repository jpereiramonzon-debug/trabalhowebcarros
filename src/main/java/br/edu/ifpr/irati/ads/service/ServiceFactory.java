package br.edu.ifpr.irati.ads.service;

public class ServiceFactory {

    public static Service getService(String name){

        switch (name){
            case "usuario":
                return new UsuarioService();
            default:
                break;
        }

        return new UsuarioService();
    }

}
