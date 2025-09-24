package br.edu.ifpr.irati.ads.dao;

import jakarta.persistence.PersistenceException;

import java.io.Serializable;
import java.util.List;

public interface Dao<T> {

    public T buscarPorId(Serializable id) throws PersistenceException;

    public void salvar(T t) throws PersistenceException;

    public void alterar(T t) throws PersistenceException;

    public void excluir(T t) throws PersistenceException;

    public List<T> buscarTodos() throws PersistenceException;
}
