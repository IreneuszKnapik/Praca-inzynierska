package inz.dao;

import inz.model.*;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;


public class TaskDao {

    public void saveTask(Task task) {
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


    public void updateTask(Task task) {

        Task newTask = getTaskById(task.getId());
        newTask.setAnswer(task.getAnswer());

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.update(newTask);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public void updateTaskGroup(TaskGroup TaskGroup) {

        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();
            // save the user object
            session.update(TaskGroup);
            // commit transaction
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    private TaskGroup getTaskGroupById(int group_id) {

        Session session = null;
        TaskGroup taskGroup = null;

        try{
            session = HibernateUtil.getSessionFactory().openSession();
            Query<TaskGroup> query= session.createQuery("select t from TaskGroup t WHERE t.id =:group_id");
            query.setParameter("group_id",group_id);
            System.out.print(group_id);
            taskGroup = query.uniqueResult();
            //System.out.println(query.toString());
            Hibernate.initialize(taskGroup);


        }
        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return taskGroup;


    }

    public List<TaskTemplate> getAllTaskTemplates(){
        Session session = null;
        List<TaskTemplate> taskTemplates = null;


        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<TaskTemplate> query= session.createQuery("from TaskTemplate t");

            taskTemplates = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(taskTemplates);

        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return taskTemplates;
    }

    public List<Task> getAllTasks(){
        Session session = null;
        List<Task> tasks = null;


        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<Task> query= session.createQuery("from Task t");

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

    public Task getTaskById(Integer task_id){

        Session session = null;
        Task task = null;

    try{
        session = HibernateUtil.getSessionFactory().openSession();
        Query<Task> query= session.createQuery("select t from Task t WHERE t.id =:task_id");
        query.setParameter("task_id",task_id);
        System.out.print(task_id);
        task = query.uniqueResult();
        //System.out.println(query.toString());
        Hibernate.initialize(task);


    }
    catch (Exception e){
        e.printStackTrace();
    }

    finally {
        if (session != null && session.isOpen()) {
            session.close();
        }
    }


        return task;
    }



    public Task getTaskByTaskGroup(Integer taskgroup_id, Integer user_id, Integer taskPos) {

        Session session = null;
        List<Task> tasks = null;
        Task task = null;

        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<Task> query= session.createQuery("select t from Task t WHERE t.user_id=:user_id AND t.taskgroup_id=:taskgroup_id");
            query.setParameter("taskgroup_id",taskgroup_id);
            query.setParameter("user_id",user_id);

            tasks = query.list();
            task = tasks.get(taskPos);
            //System.out.println(query.toString());
            Hibernate.initialize(task);



        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return task;

    }
    

    public List<Task> getTasksByTaskGroup(Integer taskgroup_id, Integer user_id) {

        Session session = null;
        List<Task> tasks = null;


        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



           //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<Task> query= session.createQuery("select t from Task t WHERE t.user_id=:user_id AND t.taskgroup_id=:taskgroup_id");
            query.setParameter("taskgroup_id",taskgroup_id);
            query.setParameter("user_id",user_id);

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

    public List<Task> getAllTasksByTest(Integer test_id) {

        Session session = null;
        List<Task> tasks = null;

        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<Task> query= session.createQuery("select t from Task t WHERE t.test_id=:test_id");
            query.setParameter("test_id",test_id);

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

    public List<Task> getTasksByTest(Integer test_id, Integer user_id) {

        Session session = null;
        List<Task> tasks = null;

        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<Task> query= session.createQuery("select t from Task t WHERE t.user_id=:user_id AND t.test_id=:test_id");
            query.setParameter("test_id",test_id);
            query.setParameter("user_id",user_id);

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

    public List<TaskTemplate> getTaskTemplatesByTestTemplate(Integer testtemplate_id) {

        Session session = null;
        List<TaskTemplate> taskTemplates = null;

        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");
            //            Query<Group> getGroupsQuery= session.createQuery("select g from Group g join g.users u WHERE u.id=:user_id");

            Query<TaskTemplate> query= session.createQuery("select t from TaskTemplate t join t.testTemplates tpl where tpl.id=:testtemplate_id");
            query.setParameter("testtemplate_id",testtemplate_id);

            taskTemplates = query.list();
            System.out.println(query.toString());
            Hibernate.initialize(taskTemplates);

        }

        catch (Exception e){
            e.printStackTrace();
        }

        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


        return taskTemplates;
    }

    public void createTasksFromTemplate(Integer user_id, Integer testtemplate_id, Integer test_id){
        System.out.println("creating tasks from template:" + testtemplate_id +"for user" + user_id);
        List<TaskTemplate> taskTemplates = getTaskTemplatesByTestTemplate(testtemplate_id);
        System.out.println("taskTemplates.size()" + taskTemplates.size());
        for (int i = 0; i < taskTemplates.size(); i++){
            Task newTask = new Task();
            newTask.setAnswer(taskTemplates.get(i).getAnswer());
            newTask.setDescription(taskTemplates.get(i).getDescription());
            newTask.setScore(taskTemplates.get(i).getScore());
            newTask.setUser_id(user_id);
            newTask.setTest_id(test_id);
            saveTask(newTask);
        }

    }


    public List<TaskGroup> getTaskGroupByUserId(Integer user_id) {

        Session session = null;
        List<TaskGroup> taskGroups = null;


        try {
            //System.out.print("Trying to get tasks for " + taskGroupUsername);
            session = HibernateUtil.getSessionFactory().openSession();
            //System.out.print(session.toString());



            //Query<Users> query = session.createQuery("from inz.model.Users u where u.username= :username");

            Query<TaskGroup> query= session.createQuery("select t from TaskGroup t inner join t.users u WHERE u.id=:user_id");
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
    public void old_startTest(Integer test_template_id, Integer user_id) {

        Transaction transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Test newTest = new Test();
            newTest.setTest_template_id(test_template_id);
            newTest.setUser_id(user_id);
            newTest.setStart_date(new Timestamp(System.currentTimeMillis()));
            session.save(newTest);

            transaction.commit();

        } catch (Exception e) {
            e.printStackTrace();
            if (transaction != null) {
                //--------------
                transaction.rollback();
            }

        }
        
    }

    public void old_submitTest(Task task, Integer user_id) {


        Transaction transaction = null;

        Integer test_id = null;
        Integer taskgroup_id = null;
        Integer newTestId = null;


        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // start a transaction
            transaction = session.beginTransaction();

            Integer task_id =task.getId();

            Query<Task> saveLastTask_query= session.createQuery("select t from Task t WHERE t.id =:task_id");
            saveLastTask_query.setParameter("task_id",task_id);
            System.out.print(task_id);
            test_id = saveLastTask_query.uniqueResult().getTest_id();
            System.out.println( "test_id:" + test_id +'\n');




        } catch (Exception e) {
            if (transaction != null) {
                //--------------
                transaction.rollback();
            }
            e.printStackTrace();
        }
        transaction = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Test newTest = new Test();
            System.out.println( "user_id:" + user_id +'\n');

//--------------
            newTest.setTest_template_id(test_id);
            newTest.setUser_id(user_id);
            newTest.setSubmit_date(new Timestamp(System.currentTimeMillis()));
            session.save(newTest);

            transaction.commit();

        } catch (Exception e) {
            e.printStackTrace();
            if (transaction != null) {
                //--------------
                transaction.rollback();
            }

        }
        transaction = null;



        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Query <Test> getTheNewTestRecord_query = session.createQuery("from Test t WHERE t.taskgroup_id=:taskgroup_id AND t.user_id=:user_id order by start_date desc");
            getTheNewTestRecord_query.setParameter("taskgroup_id",taskgroup_id);
            getTheNewTestRecord_query.setParameter("user_id",user_id);
            getTheNewTestRecord_query.setMaxResults(1);
            Test newTestFromDB = null;

            newTestFromDB = (Test) getTheNewTestRecord_query.uniqueResult();
            Hibernate.initialize(newTestFromDB);

            newTestId = newTestFromDB.getId();
            System.out.print("newTestId:" + newTestId);

            System.out.println("Getting the created new test");

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }

        transaction = null;


        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();
            Query<Task> saveAnswers_query= session.createQuery("update Task t set t.submitted = 1, t.test_id=:test_id WHERE t.taskgroup_id=:taskgroup_id");
            saveAnswers_query.setParameter("taskgroup_id",taskgroup_id);
            saveAnswers_query.setParameter("test_id",newTestId);

            //System.out.println(saveAnswers_query.toString());
            saveAnswers_query.executeUpdate();


            System.out.println("Updated test, saving test!");

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }

    }

    public void submitTest(Integer test_id) {
        Session session = null;
        Transaction transaction = null;
        try {

            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            Date submit_date = new Timestamp(System.currentTimeMillis());
            Query<Task> query = session.createQuery("update Test t set t.submit_date=:submit_date WHERE t.id=:test_id");
            query.setParameter("submit_date",submit_date);
            query.setParameter("test_id",test_id);
            query.executeUpdate();
            transaction.commit();

        }

        catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
        finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }


    }


    public void deleteTaskTemplateById(int taskTemplateID) {
        Session session = null;
        Transaction transaction = null;


        try {

            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            TaskTemplate t = session.get(TaskTemplate.class,taskTemplateID);
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
}
