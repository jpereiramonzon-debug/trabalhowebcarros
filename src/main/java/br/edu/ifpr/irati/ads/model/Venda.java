package br.edu.ifpr.irati.ads.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity(name = "tb_venda")
public class Venda implements Serializable {

    @Id
    @GeneratedValue(
            generator = "sequence_venda",
            strategy = GenerationType.SEQUENCE
    )
    @SequenceGenerator(
            name = "sequence_venda",
            allocationSize = 1
    )
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "proposta_id", nullable = false)
    private Proposta propostaOrigem;

    @Column(name = "data_venda", nullable = false)
    private LocalDateTime dataVenda;

    @Column(name = "valor_final", precision = 12, scale = 2, nullable = false)
    private BigDecimal valorFinal;

    @Column(name = "status_venda", length = 50, nullable = false)
    private String statusVenda; // Ex: ATIVA (Aguardando Baixa), CONCLUIDA (Baixa Dada)

    public Venda() {
        this.id = 0L;
        this.dataVenda = LocalDateTime.now();
        this.valorFinal = BigDecimal.ZERO;
        this.propostaOrigem = new Proposta();
        this.statusVenda = "ATIVA"; // Estado inicial
    }

    // Construtor para criar a venda a partir da proposta
    public Venda(Proposta proposta) {
        this.id = 0L;
        this.propostaOrigem = proposta;
        this.dataVenda = LocalDateTime.now();
        this.valorFinal = proposta.getValorProposto();
        this.statusVenda = "ATIVA";
    }


    public Venda(Long id, Proposta propostaOrigem, LocalDateTime dataVenda, BigDecimal valorFinal, String statusVenda) {
        this.id = id;
        this.propostaOrigem = propostaOrigem;
        this.dataVenda = dataVenda;
        this.valorFinal = valorFinal;
        this.statusVenda = statusVenda;
    }

    public Long getId() {return id;}
    public void setId(Long id) {this.id = id;}
    public Proposta getPropostaOrigem() {return propostaOrigem;}
    public void setPropostaOrigem(Proposta propostaOrigem) {this.propostaOrigem = propostaOrigem;}
    public LocalDateTime getDataVenda() {return dataVenda;}
    public void setDataVenda(LocalDateTime dataVenda) {this.dataVenda = dataVenda;}
    public BigDecimal getValorFinal() {return valorFinal;}
    public void setValorFinal(BigDecimal valorFinal) {this.valorFinal = valorFinal;}

    public String getStatusVenda() {return statusVenda;}
    public void setStatusVenda(String statusVenda) {this.statusVenda = statusVenda;}

    // Métodos de acesso convenientes (via propostaOrigem)
    public Veiculo getVeiculo() { return propostaOrigem.getVeiculo(); }
    public Usuario getCliente() { return propostaOrigem.getCliente(); }
    public Usuario getVendedor() { return propostaOrigem.getVendedor(); }
}