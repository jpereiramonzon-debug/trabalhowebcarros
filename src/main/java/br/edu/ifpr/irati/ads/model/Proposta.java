package br.edu.ifpr.irati.ads.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity(name = "tb_proposta")
public class Proposta implements Serializable {

    @Id
    @GeneratedValue(
            generator = "sequence_proposta",
            strategy = GenerationType.SEQUENCE
    )
    @SequenceGenerator(
            name = "sequence_proposta",
            allocationSize = 1
    )
    private Long id;

    // Relacionamento com o Veículo da proposta
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "veiculo_id", nullable = false)
    private Veiculo veiculo;

    // Relacionamento com o Usuário que é o Cliente/Comprador (tipo COMPRADOR/INTERESSADO)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cliente_id", nullable = false)
    private Usuario cliente;

    // Relacionamento com o Usuário Vendedor (tipo VENDEDOR/ADMIN)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "vendedor_id", nullable = false)
    private Usuario vendedor;

    @Column(name = "data_proposta", nullable = false)
    private LocalDateTime dataProposta;

    @Column(name = "valor_proposto", precision = 12, scale = 2, nullable = false)
    private BigDecimal valorProposto;

    @Column(name = "status_negociacao", length = 50, nullable = false)
    private String statusNegociacao; // Ex: ORCAMENTO, NEGOCIACAO, ACEITA, RECUSADA, CONTRATO

    public Proposta() {
        this.id = 0L;
        // Inicialização de objetos relacionados para evitar NullPointer
        this.veiculo = new Veiculo();
        this.cliente = new Usuario();
        this.vendedor = new Usuario();
        this.dataProposta = LocalDateTime.now();
        this.valorProposto = BigDecimal.ZERO;
        this.statusNegociacao = "ORCAMENTO";
    }

    public Proposta(Long id, Veiculo veiculo, Usuario cliente, Usuario vendedor, LocalDateTime dataProposta, BigDecimal valorProposto, String statusNegociacao) {
        this.id = id;
        this.veiculo = veiculo;
        this.cliente = cliente;
        this.vendedor = vendedor;
        this.dataProposta = dataProposta;
        this.valorProposto = valorProposto;
        this.statusNegociacao = statusNegociacao;
    }

    public Long getId() {return id;}
    public void setId(Long id) {this.id = id;}
    public Veiculo getVeiculo() {return veiculo;}
    public void setVeiculo(Veiculo veiculo) {this.veiculo = veiculo;}
    public Usuario getCliente() {return cliente;}
    public void setCliente(Usuario cliente) {this.cliente = cliente;}
    public Usuario getVendedor() {return vendedor;}
    public void setVendedor(Usuario vendedor) {this.vendedor = vendedor;}
    public LocalDateTime getDataProposta() {return dataProposta;}
    public void setDataProposta(LocalDateTime dataProposta) {this.dataProposta = dataProposta;}
    public BigDecimal getValorProposto() {return valorProposto;}
    public void setValorProposto(BigDecimal valorProposto) {this.valorProposto = valorProposto;}
    public String getStatusNegociacao() {return statusNegociacao;}
    public void setStatusNegociacao(String statusNegociacao) {this.statusNegociacao = statusNegociacao;}
}