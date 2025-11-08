package br.edu.ifpr.irati.ads.servlet;

import br.edu.ifpr.irati.ads.util.CalculadoraFinanceira;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet(name = "simulacaocontroleservlet", urlPatterns = "/simulacao/calcular")
public class SimulacaoControleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processarSimulacao(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Se for um GET, apenas encaminha para a tela para exibição do formulário
        req.getRequestDispatcher("/simulacaofinanciamento.jsp").forward(req, resp);
    }

    private void processarSimulacao(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Receber parâmetros
            BigDecimal valorVeiculo = new BigDecimal(req.getParameter("valorVeiculo"));
            BigDecimal valorEntrada = new BigDecimal(req.getParameter("valorEntrada"));
            BigDecimal taxaJurosAnual = new BigDecimal(req.getParameter("taxaJuros")); // Taxa anual
            int prazoMeses = Integer.parseInt(req.getParameter("prazo"));

            // 2. Cálculo
            BigDecimal valorFinanciado = valorVeiculo.subtract(valorEntrada);
            // Converter taxa anual para mensal (taxa simples, para simplificar)
            BigDecimal taxaJurosMensal = taxaJurosAnual.divide(new BigDecimal("12"), 10, BigDecimal.ROUND_HALF_UP);

            // 3. Gerar a Tabela Price
            List<Map<String, BigDecimal>> tabelaPrice = CalculadoraFinanceira.gerarTabelaPrice(
                    valorFinanciado,
                    taxaJurosMensal,
                    prazoMeses
            );

            // 4. Salvar resultados na requisição
            req.setAttribute("tabelaPrice", tabelaPrice);
            req.setAttribute("valorFinanciado", valorFinanciado);
            req.setAttribute("valorVeiculo", valorVeiculo);
            req.setAttribute("taxaJuros", taxaJurosAnual);
            req.setAttribute("prazo", prazoMeses);

            // 5. Encaminhar para a página de exibição
            req.getRequestDispatcher("/simulacaofinanciamento.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("erro", "Verifique se todos os campos foram preenchidos corretamente.");
            req.getRequestDispatcher("/simulacaofinanciamento.jsp").forward(req, resp);
        }
    }
}