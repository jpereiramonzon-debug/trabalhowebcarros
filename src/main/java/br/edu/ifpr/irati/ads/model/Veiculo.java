package br.edu.ifpr.irati.ads.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity(name = "tb_veiculo")
public class Veiculo implements Serializable {

    @Id
    @GeneratedValue(
            generator = "sequence_veiculo",
            strategy = GenerationType.SEQUENCE
    )
    @SequenceGenerator(
            name = "sequence_veiculo",
            allocationSize = 1
    )
    private Long id;

    @Column(name = "marca", length = 50, nullable = false)
    private String marca;

    @Column(name = "modelo", length = 100, nullable = false)
    private String modelo;

    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Column(name = "quilometragem", nullable = false)
    private Integer quilometragem;

    @Column(name = "preco", precision = 10, scale = 2, nullable = false)
    private BigDecimal preco;

    @Column(name = "fotos_url", length = 255)
    private String fotosUrl;

    @Column(name = "historico", length = 500)
    private String historico;

    public Veiculo() {
        this.id = 0L;
        this.marca = "";
        this.modelo = "";
        this.ano = 0;
        this.quilometragem = 0;
        this.preco = BigDecimal.ZERO;
        this.fotosUrl = "";
        this.historico = "";
    }

    public Veiculo(Long id, String marca, String modelo, Integer ano, Integer quilometragem, BigDecimal preco, String fotosUrl, String historico) {
        this.id = id;
        this.marca = marca;
        this.modelo = modelo;
        this.ano = ano;
        this.quilometragem = quilometragem;
        this.preco = preco;
        this.fotosUrl = fotosUrl;
        this.historico = historico;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public Integer getAno() {
        return ano;
    }

    public void setAno(Integer ano) {
        this.ano = ano;
    }

    public Integer getQuilometragem() {
        return quilometragem;
    }

    public void setQuilometragem(Integer quilometragem) {
        this.quilometragem = quilometragem;
    }

    public BigDecimal getPreco() {
        return preco;
    }

    public void setPreco(BigDecimal preco) {
        this.preco = preco;
    }

    public String getFotosUrl() {
        return fotosUrl;
    }

    public void setFotosUrl(String fotosUrl) {
        this.fotosUrl = fotosUrl;
    }

    public String getHistorico() {
        return historico;
    }

    public void setHistorico(String historico) {
        this.historico = historico;
    }
}