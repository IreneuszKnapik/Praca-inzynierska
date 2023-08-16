package inz.dao;

import inz.model.Task;
import inz.model.TaskGroup;
import inz.util.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

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



}
