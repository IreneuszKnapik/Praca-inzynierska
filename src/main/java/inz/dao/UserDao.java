package inz.dao;

import inz.model.Users;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;


public class UserDao{

    public void saveUser(Users user) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.save(user);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }


    public Users getUserByUsername(String user_username) {
        System.out.print("Trying to do getUserByUsername for username " + user_username);
        Session session = null;
        Users user = null;

        try {
            System.out.print("Trying to get user " + user_username);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



           //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<Users> query = session.createQuery("from Users u where u.username = :username");
            //System.out.print(query.toString());
            query.setParameter("username", user_username);

            //System.out.print(query.list());

            user = query.uniqueResult();
            //System.out.println(user.toString());
            Hibernate.initialize(user);
        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return user;

    }

}
