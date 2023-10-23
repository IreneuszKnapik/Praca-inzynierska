package inz.dao;

import inz.model.Group;
import inz.model.TestTemplate;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

    public List<Group> getAllGroups() {
        Session session = null;
        List<Group> groups = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();


            Query<Group> query= session.createQuery("from Group g");
            //Query<Group> query = session.createQuery("select u from User u join u.groups where u.id = :user_id");
            //System.out.print(query.toString());


            //System.out.print(query.list());



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


    public List<Group> getGroupsByUserId(Integer user_id) {

        Session session = null;
        List<Group> groups = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();


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

    public Group getGroupById(Integer group_id) {

        Session session = null;
        Group group = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();


            Query<Group> query= session.createQuery("from Group g WHERE g.id=:group_id");
            query.setParameter("group_id",group_id);

            group = query.uniqueResult();
            System.out.println(query.toString());
            Hibernate.initialize(group);
        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return group;

    }


    public List<String> getGroupIDfromTestTemplate(Integer testtemplate_id) {
        TestTemplate testTemplate = null;

        List<String> groupIDs = new ArrayList<>();

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Query<TestTemplate> query= session.createQuery("from TestTemplate t WHERE t.id=:testtemplate_id");

            //"from TestTemplate t WHERE t.id IN ( select testtemplate_id from user where g.user_id=:user_id ) AND allowed_attempts != 0");
            query.setParameter("testtemplate_id",testtemplate_id);

            testTemplate = query.uniqueResult();
            System.out.println(query.toString());
            Hibernate.initialize(testTemplate);
            System.out.println(testTemplate.toString());

            Map<Integer, Group> groups = testTemplate.getGroups();

            for (Integer i : groups.keySet()) {
                groupIDs.add(String.valueOf(i));
            }

            System.out.println(groupIDs);

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }

        return groupIDs;
    }
}
