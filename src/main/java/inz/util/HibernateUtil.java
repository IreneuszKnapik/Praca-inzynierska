package inz.util;

import inz.model.*;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.service.ServiceRegistry;

import java.util.Properties;

public class HibernateUtil {
    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                Configuration configuration = new Configuration();

                // Hibernate settings equivalent to hibernate.cfg.xml's properties
                Properties settings = new Properties();
                settings.put(Environment.DRIVER, "com.mysql.cj.jdbc.Driver");
                settings.put(Environment.URL, "jdbc:mysql://localhost:3306/inzynier_db?useSSL=false&characterEncoding=utf-8");
                settings.put(Environment.USER, "admin");
                settings.put(Environment.PASS, "inzynier_db");
                settings.put(Environment.DIALECT, "org.hibernate.dialect.MySQL8Dialect");
                settings.put(Environment.STORAGE_ENGINE, "InnoDB");
                settings.put(Environment.SHOW_SQL, "true");
                settings.put(Environment.CURRENT_SESSION_CONTEXT_CLASS, "thread");
                settings.put(Environment.HBM2DDL_AUTO, "validate");
                //settings.put(Environment.HBM2DDL_AUTO, "validate");

                configuration.setProperties(settings);

                //configuration.addPackage("inz.model.User");
                //configuration.addPackage("inz.model.Group");
                configuration.addAnnotatedClass(Test.class);
                configuration.addAnnotatedClass(TestTemplate.class);
                configuration.addAnnotatedClass(User.class);
                configuration.addAnnotatedClass(Group.class);
                configuration.addAnnotatedClass(TaskGroupTemplate.class);
                configuration.addAnnotatedClass(TaskTemplate.class);
                configuration.addAnnotatedClass(TaskGroup.class);
                configuration.addAnnotatedClass(Task.class);
                configuration.addAnnotatedClass(TestCase.class);
                ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                        .applySettings(configuration.getProperties()).build();




                sessionFactory = configuration.buildSessionFactory(serviceRegistry);

                return sessionFactory;


            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return sessionFactory;
    }
}
