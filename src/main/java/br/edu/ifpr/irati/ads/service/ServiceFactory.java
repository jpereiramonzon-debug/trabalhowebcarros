package br.edu.ifpr.irati.ads.service;

public class ServiceFactory {

    public static Service getService(String name){

        switch (name){
            case "usuario":
                return new UsuarioService();
            case "veiculo":
                return new VeiculoService();
            case "proposta": // NOVO: Retorna o serviço para a entidade Proposta
                return new PropostaService();
            default:
                break;
        }

        // Mantém o comportamento original de fallback
        return new UsuarioService();
    }

}