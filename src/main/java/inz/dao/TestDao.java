package inz.dao;

import inz.model.Test;
import inz.model.TestTemplate;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class TestDao {



    public void saveTestTemplate(TestTemplate testTemplate) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.save(testTemplate);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void saveTest(Test test) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.save(test);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }


    public List<Test> getTestsByUserId(Integer user_id) {

        Session session = null;
        List<Test> tests = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();

            Query<Test> query= session.createQuery("select t from Test WHERE t.user_id=:user_id");
            query.setParameter("user_id",user_id);

            tests = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(tests);
        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return tests;

    }

    //record testDescription(String name, String description) {}

    public List<TestTemplate> getTestTemplatesByUserId(Integer user_id) {
        Session session = null;
        List<TestTemplate> testTemplates = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();

            Query<TestTemplate> query= session.createQuery("select t from TestTemplate t join t.users u WHERE u.id=:user_id");

            //"from TestTemplate t WHERE t.id IN ( select testtemplate_id from user where g.user_id=:user_id ) AND allowed_attempts != 0");
            query.setParameter("user_id",user_id);

            testTemplates = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(testTemplates);
        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return testTemplates;

    }

    public Object getTestByUserAndTemplate(Integer user_id, Integer test_template_id) {

        Session session = null;
        Test newestTestFromDB = null;

        try {

            session = HibernateUtil.getSessionFactory().openSession();

            Query <Test> getTheNewTestRecord_query = session.createQuery("from Test t WHERE t.test_template_id=:test_template_id AND t.user_id=:user_id order by start_date desc");
            getTheNewTestRecord_query.setParameter("test_template_id",test_template_id);
            getTheNewTestRecord_query.setParameter("user_id",user_id);
            getTheNewTestRecord_query.setMaxResults(1);


            newestTestFromDB = (Test) getTheNewTestRecord_query.uniqueResult();
            Hibernate.initialize(newestTestFromDB);
        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return newestTestFromDB;
    }

    public List<TestTemplate> getTestTemplates() {
        Session session = null;
        List<TestTemplate> testTemplates = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();

            Query<TestTemplate> query= session.createQuery("from TestTemplate t");

            testTemplates = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(testTemplates);
        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return testTemplates;

    }
}
