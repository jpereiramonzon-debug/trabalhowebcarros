package br.edu.ifpr.irati.ads.model;

import jakarta.persistence.*;

@Entity(name = "tb_usuario")
public class Usuario {

    @Id
    @GeneratedValue(
            generator = "sequence_pessoa",
            strategy = GenerationType.SEQUENCE
    )
    @SequenceGenerator(
            name = "sequence_pessoa",
            allocationSize = 1
    )
    private Long id;

    @Column(name = "nome", length = 100, nullable = false)
    private String nome;

    @Column(name = "email", length = 100, nullable = false)
    private String email;

    @Column(name = "senha", length = 100, nullable = false)
    private String senha;

    // NOVO: Campos para dados de cliente
    @Column(name = "cpf", length = 14) // Ex: 123.456.789-00
    private String cpf;

    @Column(name = "telefone", length = 20)
    private String telefone;

    @Column(name = "tipo", length = 20, nullable = false) // Ex: ADMIN, VENDEDOR, COMPRADOR, INTERESSADO
    private String tipo;

    public Usuario() {
        id = 0L;
        nome = "";
        email = "";
        senha = "";
        cpf = ""; // Inicialização dos novos campos
        telefone = "";
        tipo = "COMPRADOR"; // Define um tipo padrão
    }

    public Usuario(Long id, String nome, String email, String senha) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.cpf = "";
        this.telefone = "";
        this.tipo = "COMPRADOR";
    }

    public Usuario(Long id, String nome, String email, String senha, String cpf, String telefone, String tipo) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.cpf = cpf;
        this.telefone = telefone;
        this.tipo = tipo;
    }

    public Long getId() {return id;}

    public void setId(Long id) {this.id = id;}

    public String getNome() {return nome;}

    public void setNome(String nome) {this.nome = nome;}

    public String getEmail() {return email;}

    public void setEmail(String email) {this.email = email;}

    public String getSenha() {return senha;}

    public void setSenha(String senha) {this.senha = senha;}


    public String getCpf() {return cpf;}

    public void setCpf(String cpf) {this.cpf = cpf;}

    public String getTelefone() {return telefone;}

    public void setTelefone(String telefone) {this.telefone = telefone;}

    public String getTipo() {return tipo;}

    public void setTipo(String tipo) {this.tipo = tipo;}
}