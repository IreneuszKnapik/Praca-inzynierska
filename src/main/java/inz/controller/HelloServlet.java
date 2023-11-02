package inz.controller;


import inz.dao.*;
import inz.model.*;
import inz.util.Parser;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;


@WebServlet("/index")
@MultipartConfig
@EnableWebMvc
public class HelloServlet extends HttpServlet implements WebMvcConfigurer {
    private UserDao userDao;
    public HttpSession session;


    public void init(){
        userDao = new UserDao();
        User admin2 = userDao.getUserByUsername("admin2");
        if(admin2 == null){
            admin2 = new User();
            admin2.setUsername("admin2");
            Parser.bCryptPasswordEncoder().encode("admin2");
            admin2.setPassword(Parser.bCryptPasswordEncoder().encode("admin2"));
            admin2.setEmail("admin2.example.com");
            admin2.setType(3);
            userDao.saveUser(admin2);
        }

        //System.out.print(admin.getId() + " " + admin.getUsername() + " " + admin.getPassword() + " "+ admin.getEmail());


    }
/*
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        System.out.println("Resource handlers added!");
        registry
                .addResourceHandler("/resources/**")
                //.addResourceLocations("/static/")
               // .addResourceLocations("/static/css/")
                //.addResourceLocations("/static/bootstrap-4.0.0-dist/css/")
                .addResourceLocations("/static/prism/");
    }
*/


    private void addTestTemplate(HttpServletRequest request, HttpServletResponse response) throws ParseException, ServletException, IOException {

        System.out.print("addTestTemplate" + request +" /n");
        session = request.getSession();
        TestDao testDao= new TestDao();
        TestTemplate testTemplate = new TestTemplate();

        testTemplate.setName((request.getParameter("name")));
        testTemplate.setDescription((request.getParameter("description")));
        testTemplate.setDue_date(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(request.getParameter("due_date")));
        testTemplate.setAllowed_attempts(Integer.parseInt(request.getParameter("allowed_attempts")));

        String[] tasks = request.getParameter( "taskChanges").split(",");

        System.out.print("--------\n");
        System.out.println("tasks: " + tasks.toString());
        System.out.print("--------\n");






        System.out.print("testTemplateId: " + testTemplate.getId());

        TaskTemplateDao taskTemplateDao= new TaskTemplateDao();
        for (int i = 0; i < tasks.length; i++) {
            System.out.println("adding testTemplateId: " + tasks[i]);
            System.out.print("TaskTemplateDao.getTaskTemplateById: " + taskTemplateDao.getTaskTemplateById(Integer.parseInt(tasks[i])).toString());
            testTemplate.addTaskTemplate( taskTemplateDao.getTaskTemplateById(Integer.parseInt(tasks[i])));
        }

        testDao.saveTestTemplate(testTemplate);




        RequestDispatcher dispatcher = null;

        dispatcher = request.getRequestDispatcher("index.jsp?webpage=testTemplates");

        dispatcher.forward(request, response);


    }

    private void updateTestTemplate(HttpServletRequest request, HttpServletResponse response) throws ParseException, ServletException, IOException {

        System.out.print("updateTestTemplate" + request +" /n");
        session = request.getSession();
        TestDao testDao= new TestDao();
        TaskTemplateDao taskTemplateDao= new TaskTemplateDao();
        GroupDao groupDao = new GroupDao();

        TestTemplate testTemplate = testDao.getTestTemplateById(Integer.parseInt(request.getParameter("testTemplateID")));

        testTemplate.setName((request.getParameter("name")));
        testTemplate.setDescription((request.getParameter("description")));
        String due_date = request.getParameter("due_date");
        System.out.print("due_date: " + due_date);
        testTemplate.setDue_date(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(due_date));
        testTemplate.setAllowed_attempts(Integer.parseInt(request.getParameter("allowed_attempts")));

        String[] tasks = request.getParameter( "taskChanges").split(",");
        if(tasks[0].equals("0") ){

        }
        else{
            System.out.print("--------\n");
            System.out.println("tasks: " + Arrays.toString(tasks));
            System.out.print("--------\n");

            System.out.println("testTemplateId: " + testTemplate.getId());



            for (int i = 0; i < tasks.length; i++) {
                System.out.println("taskID being flipped: " + Integer.parseInt(tasks[i]));
                TaskTemplate taskTemplate = taskTemplateDao.getTaskTemplateById(Integer.parseInt(tasks[i]));

                if( testTemplate.getTasks().containsKey(taskTemplate.getId())){
                    testTemplate.removeTaskTemplate(taskTemplate);
                }
                else{
                    testTemplate.addTaskTemplate(taskTemplate);
                }


        /*
                for ( TaskTemplate t : testTemplate.getTasks()) {

                    System.out.println("taskID being checked: " + taskTemplate.getId());
                    System.out.println("taskID from the test template being compared" + t.getId());

                    if ( t.getId() == taskTemplate.getId() ){

                        isTaskInSet = true;
                    }
                }
                System.out.println("check result: " + isTaskInSet);
                if( isTaskInSet == false){
                    testTemplate.addTaskTemplate(taskTemplate);
                }
                else{
                    System.out.println("taskID being removed: " + taskTemplate.getId());
                    testTemplate.removeTaskTemplate(taskTemplate);
                }

                //System.out.println("adding testTemplateId: " + tasks[i]);
                //System.out.print("TaskTemplateDao.getTaskTemplateById: " + TaskTemplateDao.getTaskTemplateById(Integer.parseInt(tasks[i])).toString());

         */

            }
        }
        String[] groups = request.getParameter( "groupChanges").split(",");
        if(groups[0].equals("0") ){

        }
        else {
            System.out.print("--------\n");
            System.out.println("groups: " + Arrays.toString(groups));
            System.out.print("--------\n");

            System.out.println("testTemplateId: " + testTemplate.getId());

            for (int i = 0; i < groups.length; i++) {
                System.out.println("groupID being flipped: " + Integer.parseInt(groups[i]));
                Group group = groupDao.getGroupById(Integer.parseInt(groups[i]));

                if (testTemplate.getGroups().containsKey(group.getId())) {
                    testTemplate.removeGroup(group);
                } else {
                    testTemplate.addGroup(group);
                }
            }
        }

        //testDao= new TestDao();
        //session = request.getSession();
        testDao.updateTestTemplate(testTemplate);




        RequestDispatcher dispatcher = null;

        dispatcher = request.getRequestDispatcher("index.jsp?webpage=testTemplates");

        dispatcher.forward(request, response);


    }

    private void deleteTestTemplate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        TestDao testDao = new TestDao();

        System.out.print("deleteTestTemplate" + request +" /n");
        session = request.getSession();

        testDao.deleteTestTemplateById(Integer.parseInt(request.getParameter("testTemplateID")));


        RequestDispatcher dispatcher = null;

        dispatcher = request.getRequestDispatcher("index.jsp?webpage=testTemplates");

        dispatcher.forward(request, response);
    }


    private void saveAnswer(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{

        System.out.print("saveAnswer " + request +" /n");

        session = request.getSession();
        TaskDao taskDao = new TaskDao();
        Task task = new Task();

        task.setId(Integer.parseInt(request.getParameter("taskId")));
        task.setAnswer(request.getParameter("answer"));


        String targetTask = request.getParameter("targetTask");
        String targetTest = request.getParameter("targetTest");


        taskDao.updateTask(task);

        RequestDispatcher dispatcher = null;

        dispatcher = request.getRequestDispatcher("index.jsp?webpage=test&testId="+targetTest+"&taskId="+targetTask);

        dispatcher.forward(request, response);

    }

    private void saveAnswerWithSubmit(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        //System.out.print("saveAnswerWithSubmit " + request +" /n");

        session = request.getSession();
        TaskDao taskDao = new TaskDao();
        Task task = new Task();

        task.setId(Integer.parseInt(request.getParameter("taskId")));
        task.setAnswer(request.getParameter("answer"));

        Integer user_id =  Integer.parseInt(request.getParameter("user"));
        taskDao.saveTask(task);

        Integer test_id =  Integer.parseInt(request.getParameter("test"));
        taskDao.submitTest(test_id);


        RequestDispatcher dispatcher = null;

        dispatcher = request.getRequestDispatcher("index.jsp?webpage=tests");

        dispatcher.forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        //System.out.print("Username " + username + "\n" );
        String errors = "";

        RequestDispatcher dispatcher = null;

        User userCheck = userDao.getUserByUsername(username);

        if(userCheck != null && Parser.isCorrectPasswd(userCheck, password) && userCheck.getType() != 0){
            session.setAttribute("currentUser", userCheck);
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=main");
        }
        else{

            if(userCheck == null){
                errors +="Nieprawidłowy Login<br/>";
            }
            if(!Parser.isCorrectPasswd(userCheck, password)){
                errors +="Nieprawidłowe hasło<br/> ";
            }

            if(userCheck.getType() == 0){
                errors +="Konto jest zablokowane przez administratora<br/> ";
            }


            dispatcher = request.getRequestDispatcher("WEB-INF/templates/loginErrors.jsp?errors="+errors);
        }

        dispatcher.forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.print("addUser " + request +" /n");

        session = request.getSession();

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String type = request.getParameter("type");
        User newUser = null;

        User userCheck = userDao.getUserByUsername(username);
        if(userCheck == null ){
            newUser = new User();
            newUser.setUsername(username);

            newUser.setPassword(Parser.bCryptPasswordEncoder().encode(password));
            newUser.setEmail(email);
            newUser.setType(Integer.parseInt(type));
            userDao.saveUser(newUser);
        }

        RequestDispatcher dispatcher = null;

        dispatcher = request.getRequestDispatcher("index.jsp?webpage=users");

        dispatcher.forward(request, response);

    }

    private void openTest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        session = request.getSession();
        Integer testTemplateId = Integer.valueOf(request.getParameter("testTemplateId"));
        User currentUser = (User) session.getAttribute("currentUser");
        TestDao testDao = new TestDao();
        Integer testID = null;

        System.out.println("before opening test");
        testID = testDao.openTest(currentUser.getId(),testTemplateId);
        System.out.println("new created testID:" + testID);
        RequestDispatcher dispatcher = null;

        if( testID == null || testID == 0){
            String errorText = "Brak dostępnych podejść do testu";
            request.setCharacterEncoding("UTF-8");
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=error&targetPage=tests&errors="+errorText);

        }
        else{
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=test&taskId=0&testId="+testID);

        }
        dispatcher.forward(request, response);


    }

    private void addTaskTemplate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ParseException {
        session = request.getSession();

        TaskTemplateDao taskTemplateDao = new TaskTemplateDao();
        TaskTemplate taskTemplate = new TaskTemplate();

        taskTemplate.setAnswer((request.getParameter("answer")));
        taskTemplate.setDescription((request.getParameter("description")));
        taskTemplate.setScore(Integer.parseInt(request.getParameter("score")));

        taskTemplateDao.saveTaskTemplate(taskTemplate);

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=taskTemplates");
        dispatcher.forward(request, response);

    }

    private void updateTaskTemplate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException , ParseException{
        session = request.getSession();

        TaskTemplateDao taskTemplateDao = new TaskTemplateDao();
        TaskTemplate taskTemplate = taskTemplateDao.getTaskTemplateById(Integer.parseInt(request.getParameter("taskTemplateID")));

        taskTemplate.setAnswer(request.getParameter("answer"));
        taskTemplate.setDescription(request.getParameter("description"));
        taskTemplate.setScore(Integer.parseInt(request.getParameter("score")));

        taskTemplateDao.updateTaskTemplate(taskTemplate);

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=taskTemplates");
        dispatcher.forward(request, response);

    }


    private void deleteTaskTemplate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        session = request.getSession();
        TaskDao taskDao = new TaskDao();

        taskDao.deleteTaskTemplateById(Integer.parseInt(request.getParameter("taskTemplateID")));

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=taskTemplates");
        dispatcher.forward(request, response);
    }



    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {


            currentUser = new User();
            session.setAttribute("currentUser", currentUser);
        }

        response.setContentType("text/html");

        String action = request.getParameter("action");
        System.out.println("action:" + action);

        if(action==null){
            RequestDispatcher dispatcher = null;
            dispatcher = request.getRequestDispatcher("index.jsp");
            dispatcher.forward(request, response);
        }
        else if(action.equals("login")){

            login(request,response);

        }
        else if(action.equals("saveAnswer")){

            saveAnswer(request,response);

        }
        else if(action.equals("saveAnswerWithSubmit")){

            saveAnswerWithSubmit(request,response);

        }
        else if(action.equals("addTestTemplate")){

            try {
                addTestTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("addTaskTemplate")){
            try {
                addTaskTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("updateTestTemplate")){

            try {
                updateTestTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("updateTaskTemplate")){

            try {
                updateTaskTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("deleteTestTemplate")){

            deleteTestTemplate(request,response);

        }

        else if(action.equals("deleteTaskTemplate")){

            deleteTaskTemplate(request,response);
        }

        else if(action.equals("addUser")){

            addUser(request,response);

        }
        else if(action.equals("openTest")){
            //System.out.println("GET request before opening test");
            openTest(request,response);

        }





    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User currentUser =(User) session.getAttribute("currentUser");

        response.setContentType("text/html");

        if(currentUser==null) {

            currentUser= new User();
            session.setAttribute("currentUser",currentUser);
        }

        String action = request.getParameter("action");

        if(action==null) action="";
        else if(action.equals("login")){

            login(request,response);

        }
        else if(action.equals("saveAnswer")){

            saveAnswer(request,response);

        }
        else if(action.equals("saveAnswerWithSubmit")){

            saveAnswerWithSubmit(request,response);

        }
        else if(action.equals("addTestTemplate")){

            try {
                addTestTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("addTaskTemplate")){

            try {
                addTaskTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("updateTestTemplate")){

            try {
                updateTestTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("updateTaskTemplate")){

            try {
                updateTaskTemplate(request,response);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        else if(action.equals("deleteTestTemplate")){

            deleteTestTemplate(request,response);

        }
        else if(action.equals("deleteTaskTemplate")){

            deleteTaskTemplate(request,response);
        }
        else if(action.equals("addUser")){

            addUser(request,response);

        }
        else if(action.equals("openTest")){

            openTest(request,response);

        }

    }
}