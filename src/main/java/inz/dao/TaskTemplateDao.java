package inz.dao;

import inz.model.TaskGroupTemplate;
import inz.model.TaskTemplate;
import inz.model.TestCase;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;


public class TaskTemplateDao {

    public TaskTemplate getTaskTemplateById(Integer taskTemplateID) {


        TaskTemplate taskTemplate = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession();){

            // start a transaction
            Transaction transaction = session.beginTransaction();

            Query<TaskTemplate> query= session.createQuery("FROM TaskTemplate t WHERE t.id=:taskTemplateID");
            query.setParameter("taskTemplateID",taskTemplateID);


            taskTemplate = query.uniqueResult();
            Hibernate.initialize(taskTemplate.getTestTemplates());
            Hibernate.initialize(taskTemplate.toString());


            transaction.commit();
        }

        catch (Exception e){
            e.printStackTrace();

        }

        return taskTemplate;

    }

    public void saveTaskTemplate(TaskTemplate task) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.save(task);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }




    public List<TaskTemplate> getTaskByTaskGroup(String taskGroupName) {

        Session session = null;
        List<TaskTemplate> tasks = null;


        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



           //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<TaskTemplate> query= session.createQuery("select t from TaskTemplate t inner join t.taskGroups g WHERE g.id=:taskGroupName");
            query.setParameter("taskGroupName",taskGroupName);

            tasks = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(tasks);

        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return tasks;

    }

    public List<TaskGroupTemplate> getTaskGroupByUserId(Integer user_id) {

        Session session = null;
        List<TaskGroupTemplate> taskGroups = null;


        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<TaskGroupTemplate> query= session.createQuery("select t from TaskGroupTemplate t inner join t.users u WHERE u.id=:user_id");
            query.setParameter("user_id",user_id);

            taskGroups = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(taskGroups);

        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return taskGroups;

    }

    public void updateTaskTemplate(TaskTemplate taskTemplate) {


        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.update(taskTemplate);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void saveTestCase(TestCase testCase) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.save(testCase);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                e.printStackTrace();
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updateTestCase(TestCase testCase) {


        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.update(testCase);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void deleteTestCaseById(int testCaseID) {
        Session session = null;
        Transaction transaction = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            TestCase t = session.get(TestCase.class,testCaseID);
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


    public List <TestCase> getTestCasesByTaskTemplateId(Integer taskTemplateID) {

        Session session = null;
        List<TestCase> testCases = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            // start a transaction
            Transaction transaction = session.beginTransaction();

            Query<TestCase> query= session.createQuery("FROM TestCase t WHERE t.tasktemplate_id=:taskTemplateID");
            query.setParameter("taskTemplateID",taskTemplateID);


            testCases = query.list();


            transaction.commit();
        }

        catch (Exception e){
            e.printStackTrace();

        }

        return testCases;

    }



    public TestCase getTestCaseById(Integer testCaseId) {


        TestCase testCase = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession();){

            // start a transaction
            Transaction transaction = session.beginTransaction();

            Query<TestCase> query= session.createQuery("FROM TestCase t WHERE t.id=:testCaseId");
            query.setParameter("testCaseId",testCaseId);


            testCase = query.uniqueResult();

            transaction.commit();
        }

        catch (Exception e){
            e.printStackTrace();

        }

        return testCase;

    }
}
