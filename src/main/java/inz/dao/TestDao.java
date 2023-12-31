package inz.dao;

import inz.model.Group;
import inz.model.TaskTemplate;
import inz.model.Test;
import inz.model.TestTemplate;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class TestDao {



    public void saveTestTemplate(TestTemplate testTemplate) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            System.out.println(testTemplate.toString());
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

    public void updateTestTemplate(TestTemplate testTemplate) {


        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.update(testTemplate);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    public void updateTest(Test test) {


        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.update(test);
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


    public List<TestTemplate> getTestTemplatesByUserId(Integer user_id) {

        Session session = null;
        List<Group> groups = null;
        List<TestTemplate> testTemplates = null;
        List<Integer> groups_ids = new ArrayList<>();
        List<Integer> nonEmptyTestTemplates_ids = new ArrayList<>();

        try {

            session = HibernateUtil.getSessionFactory().openSession();

            Query<Group> getGroupsQuery= session.createQuery("select g from Group g join g.users u WHERE u.id=:user_id");
            getGroupsQuery.setParameter("user_id",user_id);
            groups = getGroupsQuery.list();
            Hibernate.initialize(groups);

            for ( int i =0;i < groups.size();i++){
                groups_ids.add(groups.get(i).getId());
            }


            Query<Integer> nonEmptyTestTemplates = session.createSQLQuery("SELECT testtemplate_id FROM testtemplates_tasktemplates");

            nonEmptyTestTemplates_ids = nonEmptyTestTemplates.list();

            Query<TestTemplate> testTemplateQuery= session.createQuery("select distinct t from TestTemplate t JOIN t.groups g WHERE g.id in (:groups_ids) and t.id in (:nonEmptyTestTemplates_ids)");
            testTemplateQuery.setParameterList("groups_ids",groups_ids);
            testTemplateQuery.setParameterList("nonEmptyTestTemplates_ids",nonEmptyTestTemplates_ids);

            testTemplates = testTemplateQuery.list();
            System.out.println(testTemplateQuery.toString());
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



    public Integer openTest(Integer  user_id, Integer test_template_id) {
        Session session = null;
        Transaction transaction = null;

        Test previousTest = null;
        Test newTest = null;

        Integer testID = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            Query <java.util.Date> testTemplateDueDate  = session.createQuery("SELECT t.due_date from TestTemplate t WHERE t.id=:test_template_id");
            testTemplateDueDate.setParameter("test_template_id",test_template_id);
            testTemplateDueDate.setMaxResults(1);
            Date due_date = testTemplateDueDate.uniqueResult();
            System.out.println("due date from template:" + due_date );

            Query <Integer> testTemplateAttemptCount  = session.createQuery("SELECT t.allowed_attempts from TestTemplate t WHERE t.id=:test_template_id");
            testTemplateAttemptCount.setParameter("test_template_id",test_template_id);
            testTemplateAttemptCount.setMaxResults(1);
            Integer allowedAttempts = testTemplateAttemptCount.uniqueResult();
            System.out.println("limit from template:" + allowedAttempts);



            Query <Long> testCount  = session.createQuery("select count(t) from Test t WHERE t.test_template_id=:test_template_id AND t.user_id=:user_id AND submit_date is NOT NULL");
            testCount.setParameter("test_template_id",test_template_id);
            testCount.setParameter("user_id",user_id);
            testCount.setMaxResults(1);
            Long attemptCount = testCount.uniqueResult();
            System.out.println("attempts count:" + attemptCount );

            if(attemptCount < allowedAttempts){
                Query <Test> getTheNewTestRecord_query = session.createQuery("from Test t WHERE t.test_template_id=:test_template_id AND t.user_id=:user_id AND submit_date is NULL order by start_date desc");
                getTheNewTestRecord_query.setParameter("test_template_id",test_template_id);
                getTheNewTestRecord_query.setParameter("user_id",user_id);
                getTheNewTestRecord_query.setMaxResults(1);

                previousTest = getTheNewTestRecord_query.uniqueResult();
                if(previousTest == null){
                    newTest = new Test();

                    newTest.setTest_template_id(test_template_id);
                    newTest.setUser_id(user_id);
                    newTest.setStart_date((new Timestamp(System.currentTimeMillis())));
                    Integer newTestID = (Integer) session.save(newTest);

                    TaskDao taskDao = new TaskDao();
                    taskDao.createTasksFromTemplate(user_id,test_template_id,newTestID);
                    transaction.commit();
                    testID = newTestID;

                }else{
                    Hibernate.initialize(previousTest);
                    transaction.commit();
                    testID = previousTest.getId();
                }
            }
            else{
                return 0;
            }










        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }

        return testID;

    }


    public Test getTestByUserAndTemplate(Integer user_id, Integer test_template_id) {

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


    public List<TestTemplate> getAllTestTemplates() {
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

    public TestTemplate getTestTemplateById(Integer testtemplate_id) {
        TestTemplate testTemplate = null;
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()){

            transaction = session.beginTransaction();

            Query<TestTemplate> query= session.createQuery("FROM TestTemplate t WHERE t.id=:testtemplate_id ");

            //"from TestTemplate t WHERE t.id IN ( select testtemplate_id from user where g.user_id=:user_id ) AND allowed_attempts != 0");
            query.setParameter("testtemplate_id",testtemplate_id);

            testTemplate = query.uniqueResult();
            Hibernate.initialize(testTemplate.getTasks());
            Hibernate.initialize(testTemplate.toString());

            transaction.commit();
        }

        catch (Exception e){
            e.printStackTrace();
        }

        return testTemplate;

    }

    public List<String> getTaskIDfromTestTemplate(Integer testtemplate_id) {
        TestTemplate testTemplate = null;

        List<String> taskIDs = new ArrayList<>();

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

            Map<Integer,TaskTemplate> taskTemplates = testTemplate.getTasks();

            for (Integer i : taskTemplates.keySet()) {
                taskIDs.add(String.valueOf(i));
            }

            System.out.println(taskIDs);

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }

        return taskIDs;
    }

    public void deleteTestTemplateById(int testTemplateID) {
        Session session = null;
        Transaction transaction = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            TestTemplate t = session.get(TestTemplate.class,testTemplateID);
            if(t != null){
                session.delete(t);
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


    public List<Test> getAllTests() {
        Session session = null;
        List<Test> tests = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();

            Query<Test> query= session.createQuery("from Test t");

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

    public List<Test> getGradedTestsByUser(Integer user_id) {
        List<Test> tests = null;
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()){

            transaction = session.beginTransaction();

            Query<Test> query= session.createQuery("FROM Test t WHERE t.user_id=:user_id AND t.grade != NULL");

            //"from TestTemplate t WHERE t.id IN ( select testtemplate_id from user where g.user_id=:user_id ) AND allowed_attempts != 0");
            query.setParameter("user_id",user_id);

            tests = query.list();
            Hibernate.initialize(tests);

            transaction.commit();
        }

        catch (Exception e){
            e.printStackTrace();
        }

        return tests;
    }

    public Test getTestById(Integer test_id) {
        Test test = null;
        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()){

            transaction = session.beginTransaction();

            Query<Test> query= session.createQuery("FROM Test t WHERE t.id=:test_id ");

            //"from TestTemplate t WHERE t.id IN ( select testtemplate_id from user where g.user_id=:user_id ) AND allowed_attempts != 0");
            query.setParameter("test_id",test_id);

            test = query.uniqueResult();
            Hibernate.initialize(test);

            transaction.commit();
        }

        catch (Exception e){
            e.printStackTrace();
        }

        return test;
    }
}
