package br.edu.ifpr.irati.ads.dao;

import jakarta.persistence.PersistenceException;
import jakarta.persistence.Query;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.io.Serializable;
import java.util.List;

public class GenericDao<T> implements Dao<T> {

    protected final Class classePersistente;
    protected Session session;

    public GenericDao(Class classePersistente, Session session){
        this.classePersistente = classePersistente;
        this.session = session;
    }

    @Override
    public T buscarPorId(Serializable id) throws PersistenceException {
        T t = null;
        try{
            t = (T) session.find(classePersistente, id);
            return t;
        }catch (HibernateException | NullPointerException e){
            throw new PersistenceException(e.getMessage());
        }
    }

    @Override
    public void salvar(T t) throws PersistenceException {
        Transaction transaction = null;
        try{
            transaction = session.beginTransaction(); // INÍCIO DA TRANSAÇÃO
            session.persist(t);
            transaction.commit(); // FIM DA TRANSAÇÃO
        }catch (HibernateException | NullPointerException e){
            if (transaction != null) {
                transaction.rollback(); // Rollback em caso de erro
            }
            throw new PersistenceException(e.getMessage());
        }
    }

    @Override
    public void alterar(T t) throws PersistenceException {
        Transaction transaction = null;
        try{
            transaction = session.beginTransaction(); // INÍCIO DA TRANSAÇÃO
            session.merge(t);
            transaction.commit(); // FIM DA TRANSAÇÃO
        }catch (HibernateException | NullPointerException e){
            if (transaction != null) {
                transaction.rollback(); // Rollback em caso de erro
            }
            throw new PersistenceException(e.getMessage());
        }
    }

    @Override
    public void excluir(T t) throws PersistenceException {

        Transaction transaction = null;
        try{
            transaction = session.beginTransaction(); // INÍCIO DA TRANSAÇÃO
            session.remove(t);
            transaction.commit(); // FIM DA TRANSAÇÃO
        }catch (HibernateException | NullPointerException e){
            if (transaction != null) {
                transaction.rollback(); // Rollback em caso de erro
            }
            throw new PersistenceException(e.getMessage());
        }

    }

    @Override
    public List<T> buscarTodos() throws PersistenceException {

        try{
            String hql = "from " + this.classePersistente.getCanonicalName();
            Query query = session.createQuery(hql, this.classePersistente);
            List results = query.getResultList();
            return results;
        }catch (HibernateException | NullPointerException e){
            throw new PersistenceException(e.getMessage());
        }
    }
}