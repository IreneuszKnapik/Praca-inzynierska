package inz.dao;

import inz.model.Group;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class GroupDao {

    public void saveGroup(Group group) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.save(group);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }


    public List<Group> getGroupsByUserId(Integer user_id) {

        Session session = null;
        List<Group> groups = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();



            //Query<Group> query = session.createQuery("select u from User u join u.groups where u.id = :user_id");
            //System.out.print(query.toString());


            //System.out.print(query.list());

            Query<Group> query= session.createQuery("select g from Group g inner join g.users u WHERE u.id=:user_id");
            query.setParameter("user_id",user_id);

            groups = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(groups);
        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return groups;

    }


}
