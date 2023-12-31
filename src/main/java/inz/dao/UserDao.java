package inz.dao;

import inz.model.User;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;


public class UserDao{

    public void saveUser(User user) {
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


    public User getUserByUsername(String user_username) {
        System.out.print("Trying to do getUserByUsername for username " + user_username);
        Session session = null;
        User user = null;

        try {
            System.out.print("Trying to get user " + user_username);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



           //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<User> query = session.createQuery("from User u where u.username = :username");
            //System.out.print(query.toString());
            query.setParameter("username", user_username);

            //System.out.print(query.list());

            //System.out.println(user.toString());
            Hibernate.initialize(user);
            user = query.uniqueResult();
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


    public List<User> getAllUsers() {

        Session session = null;
        List<User> users = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            Query<User> query = session.createQuery("from User u");
            users = query.list();
            Hibernate.initialize(users);
        }

        catch (Exception e){

            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return users;
    }

    public User getUserById(Integer user_id) {
        Session session = null;
        User user = null;

        try {
            System.out.print("Trying to get user " + user_id);
            session = HibernateUtil.getSessionFactory().openSession();

            Query<User> query = session.createQuery("from User u where u.id = :user_id");
            query.setParameter("user_id", user_id);
            user = query.uniqueResult();
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

    public void deleteUserById(int userId) {
        Session session = null;
        Transaction transaction = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            User u = session.get(User.class,userId);
            if(u != null){
                session.delete(u);
            }

            transaction.commit();

        }

        catch (Exception e){
            e.printStackTrace();
            if (transaction != null) {
                transaction.rollback();
            }
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


    }

    public void updateUser(User user) {

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.update(user);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
}
