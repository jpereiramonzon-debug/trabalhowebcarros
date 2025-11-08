package br.edu.ifpr.irati.ads.util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CalculadoraFinanceira {

    /**
     * Calcula a parcela fixa (prestação) utilizando o método Tabela Price.
     * M = VP * [ i * (1 + i)^n ] / [ (1 + i)^n – 1 ]
     *
     * @param valorFinanciado Valor principal (VP)
     * @param taxaJurosMensal Taxa de juros por período (i)
     * @param prazoMeses Número de períodos (n)
     * @return Valor da prestação mensal
     */
    public static BigDecimal calcularPrestacaoPrice(BigDecimal valorFinanciado, BigDecimal taxaJurosMensal, int prazoMeses) {
        if (valorFinanciado.compareTo(BigDecimal.ZERO) <= 0 || prazoMeses <= 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal i = taxaJurosMensal.divide(new BigDecimal("100"), 10, RoundingMode.HALF_UP);
        BigDecimal umMaisI = i.add(BigDecimal.ONE);

        // (1 + i)^n
        BigDecimal umMaisINelevadoN = umMaisI.pow(prazoMeses);

        // Numerador: i * (1 + i)^n
        BigDecimal numerador = i.multiply(umMaisINelevadoN);

        // Denominador: (1 + i)^n – 1
        BigDecimal denominador = umMaisINelevadoN.subtract(BigDecimal.ONE);

        // Prestação: Numerador / Denominador
        BigDecimal prestacao = valorFinanciado.multiply(
                numerador.divide(denominador, 10, RoundingMode.HALF_UP)
        );

        return prestacao.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Gera o cronograma de amortização (Tabela Price)
     * @param valorFinanciado Valor principal a ser financiado
     * @param taxaJurosMensal Taxa de juros ao mês (%)
     * @param prazoMeses Prazo em meses
     * @return Lista de mapas contendo: "parcela", "prestacao", "juros", "amortizacao", "saldo"
     */
    public static List<Map<String, BigDecimal>> gerarTabelaPrice(BigDecimal valorFinanciado, BigDecimal taxaJurosMensal, int prazoMeses) {
        List<Map<String, BigDecimal>> tabela = new ArrayList<>();

        BigDecimal i = taxaJurosMensal.divide(new BigDecimal("100"), 10, RoundingMode.HALF_UP);
        BigDecimal saldoDevedor = valorFinanciado;
        BigDecimal prestacao = calcularPrestacaoPrice(valorFinanciado, taxaJurosMensal, prazoMeses);

        for (int parcela = 1; parcela <= prazoMeses; parcela++) {
            Map<String, BigDecimal> linha = new HashMap<>();

            BigDecimal juros = saldoDevedor.multiply(i).setScale(2, RoundingMode.HALF_UP);
            BigDecimal amortizacao = prestacao.subtract(juros).setScale(2, RoundingMode.HALF_UP);

            // Corrige a amortização na última parcela devido a arredondamentos
            if (parcela == prazoMeses) {
                // A amortização deve ser igual ao saldo devedor restante
                amortizacao = saldoDevedor.setScale(2, RoundingMode.HALF_UP);
                // Ajusta a prestação final
                prestacao = amortizacao.add(juros).setScale(2, RoundingMode.HALF_UP);
            }

            saldoDevedor = saldoDevedor.subtract(amortizacao).setScale(2, RoundingMode.HALF_UP);

            // Garante que o saldo devedor seja 0 na última parcela
            if (parcela == prazoMeses && saldoDevedor.compareTo(BigDecimal.ZERO) != 0) {
                // Pequeno ajuste no saldo para garantir que termine em 0
                saldoDevedor = BigDecimal.ZERO;
            }

            linha.put("parcela", new BigDecimal(parcela));
            linha.put("prestacao", prestacao);
            linha.put("juros", juros);
            linha.put("amortizacao", amortizacao);
            linha.put("saldo", saldoDevedor);

            tabela.add(linha);
        }

        return tabela;
    }
}