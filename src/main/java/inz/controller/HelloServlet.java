package inz.controller;


import inz.dao.*;
import inz.model.*;
import inz.util.Parser;
import org.springframework.context.annotation.Configuration;
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
import java.io.*;
import java.net.InetSocketAddress;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;

import static org.springframework.web.util.HtmlUtils.htmlUnescape;




@WebServlet("/index")
@MultipartConfig
@Configuration
@EnableWebMvc
public class HelloServlet extends HttpServlet implements WebMvcConfigurer {
    private UserDao userDao;
    public HttpSession session;
    private HashMap<String,Process> codeTests;

/*
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        System.out.println("Resource handlers added!");
        registry
                .addResourceHandler("/resources/**")
                .addResourceLocations("/static/")
                .addResourceLocations("/static/css/")
                .addResourceLocations("/css/bootstrap-4.0.0-dist/startbootstrap-one-page-wonder-gh-pages/css/")
                .addResourceLocations("/static/bootstrap-4.0.0-dist/css/")
                .addResourceLocations("/static/prism/");
    }

*/

    public void init(){
        userDao = new UserDao();

        //creating a test admin user each time for my convenience
        User admin2 = userDao.getUserByUsername("admin2");
        if(admin2 == null){
            admin2 = new User();
            admin2.setUsername("admin2");
            Parser.bCryptPasswordEncoder().encode("admin2");
            admin2.setPassword(Parser.bCryptPasswordEncoder().encode("admin2"));
            admin2.setEmail("admin2@example.com");
            admin2.setType(3);
            userDao.saveUser(admin2);
        }

        codeTests = new HashMap<String,Process>();

        String host = "localhost";
        int port = 5057;


        Thread ServerThread1 = new Thread(new TestServer(new InetSocketAddress(host, port)));
        ServerThread1.start();

        //System.out.print(admin.getId() + " " + admin.getUsername() + " " + admin.getPassword() + " "+ admin.getEmail());


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /*
        session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {


            currentUser = new User();
            session.setAttribute("currentUser", currentUser);
        }
        */
        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");

        String action = request.getParameter("action");
        System.out.println("action:" + action);
        dispatchSelector(request,response,action);

    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");


        String action = request.getParameter("action");
        System.out.println("action:" + action);
        dispatchSelector(request,response,action);

    }

    private void dispatchSelector(HttpServletRequest request, HttpServletResponse response, String action) throws ServletException, IOException {
        session = request.getSession();

        if (action == null) {
            RequestDispatcher dispatcher = null;
            dispatcher = request.getRequestDispatcher("index.jsp");
            dispatcher.forward(request, response);
        }
        else {
            if(session.getAttribute("currentUser") ==null) {
                RequestDispatcher dispatcher = null;

                String errors = "Sesja wygasła - zaloguj się ponownie";
                dispatcher = request.getRequestDispatcher("index.jsp?webpage=loginErrors&targetPage=login&errors="+errors);
                dispatcher.forward(request, response);
            }
            else if (action.equals("login")) {

                login(request, response);

            }else if (action.equals("logout")) {

                logout(request, response);

            } else if (action.equals("register")) {

                register(request, response);

            } else if (action.equals("saveAnswer")) {

                saveAnswer(request, response);

            } else if (action.equals("saveAnswerWithSubmit")) {

                saveAnswerWithSubmit(request, response);

            } else if (action.equals("addTestTemplate")) {

                try {
                    addTestTemplate(request, response);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

            } else if (action.equals("addTaskTemplate")) {
                try {
                    addTaskTemplate(request, response);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

            } else if (action.equals("updateTestTemplate")) {

                try {
                    updateTestTemplate(request, response);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

            } else if (action.equals("updateTaskTemplate")) {

                try {
                    updateTaskTemplate(request, response);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

            } else if (action.equals("deleteTestTemplate")) {

                deleteTestTemplate(request, response);

            } else if (action.equals("deleteTaskTemplate")) {

                deleteTaskTemplate(request, response);
            } else if (action.equals("addUser")) {

                addUser(request, response);

            } else if (action.equals("updateUser")) {

                updateUser(request, response);

            } else if (action.equals("deleteUser")) {

                deleteUser(request, response);

            }else if (action.equals("addGroup")) {

                addGroup(request, response);

            }else if (action.equals("updateGroup")) {

                updateGroup(request, response);

            }else if (action.equals("deleteGroup")) {

                deleteGroup(request, response);

            } else if (action.equals("openTest")) {
                openTest(request, response);

            }
            else if (action.equals("gradeTask")) {
                gradeTask(request, response);

            }
            else if (action.equals("markTest")) {
                markTest(request, response);

            }
            else if(action.equals("testCode")) {
                testCode(request, response);
            }
            else if(action.equals("testCodeCompile")) {
                testCodeCompile(request, response);
            }
            else if(action.equals("testCodeRun")) {
                testCodeRun(request, response);
            }
            else if(action.equals("testCodeInput")) {
                testCodeInput(request, response);
            }
            else if(action.equals("testCodeOutput")) {
                testCodeOutput(request, response);
            }
            else if(action.equals("testCodeIO")) {
                testCodeIO(request, response);
            }
            else if(action.equals("testCodeSocket")) {
                testCodeIO(request, response);
            }
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        session = request.getSession();
        session.invalidate();

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=landing");
        dispatcher.forward(request, response);
    }
    private void testCodeIO(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String execName = request.getParameter("execName");
        String argument = request.getParameter("argument");
        System.out.println("Argument: "+ argument);
        String output = "";
        if(codeTests.containsKey(execName)) {
            System.out.println("Process exists: " + execName);
            Process process = codeTests.get(execName);

            if(!argument.equals("")){
                System.out.println("Argument is not empty");
                OutputStream outputStream = process.getOutputStream();
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream));

                writer.write(argument);
            }

            System.out.println("outputting output");

            InputStream inputStream = process.getInputStream();
            BufferedReader reader = new BufferedReader (new InputStreamReader(inputStream));
            System.out.println("outputting output - loop");

            int c = 0;

            while((c = reader.read()) != -1) {
                System.out.println("Reading process " + execName);
                char character = (char) c;
                System.out.println(character);
                output += character;
            }




        }else{
            output = "close314";
        }
        System.out.println("sending back response");
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(output);


    }

    private void testCodeInput(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String execName = request.getParameter("execName");
        String argument = request.getParameter("argument");
        String output = "";
        if(codeTests.containsKey(execName)){
            System.out.println("Process exists: "+execName);

            Process process = codeTests.get(execName);
            OutputStream outputStream = process.getOutputStream();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream));
            writer.write(argument);

        }
        else{
            output = "Process" +execName +" not found";
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(output);
    }

    private void testCodeOutput(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String execName = request.getParameter("execName");

        String output ="";
        if(codeTests.containsKey(execName)){

            Process process = codeTests.get(execName);
            InputStream inputStream = process.getInputStream();
            BufferedReader reader = new BufferedReader (new InputStreamReader(inputStream));

            String line1=null;
            while ((line1 = reader.readLine()) != null) {
                System.out.println("Reading process " + execName);
                output += line1;
            }
        }
        else{
            output = "Process" +execName +" not found";
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(output);


    }


    private void testCodeRun(HttpServletRequest request, HttpServletResponse response) throws IOException {


        String execName = request.getParameter("execName");

        String processStatus = "";


        if(codeTests.containsKey(execName)){
            System.out.println("Process exists: "+execName);
        }
        else{
            try {
                ProcessBuilder pb=new ProcessBuilder();
                pb = new ProcessBuilder("C:\\inz_code\\"+execName);



                Process process = pb.start();
                codeTests.put(execName,process);
                System.out.println("Creating process: "+execName);
                /*
                OutputStream outputStream = process.getOutputStream();
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream));
                writer.flush();
                */
                processStatus = "created";


            /*
                process.destroy();// tell the process to stop
                process.waitFor(10, TimeUnit.SECONDS); // give it a chance to stop
                process.destroyForcibly();             // tell the OS to kill the process
                process.waitFor();                     // the process is now dead
*/


            }
            catch (Exception ex)

            {
                ex.printStackTrace();
                processStatus = "failed";
            }
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(processStatus);

    }

    private void testCodeCompile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println(request.toString());


        String body = null;
        StringBuilder stringBuilder = new StringBuilder();
        BufferedReader bufferedReader = null;

        try {
            InputStream inputStream = request.getInputStream();
            if (inputStream != null) {
                bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
                char[] charBuffer = new char[128];
                int bytesRead = -1;
                while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
                    stringBuilder.append(charBuffer, 0, bytesRead);
                }
            } else {
                stringBuilder.append("");
            }
        } catch (IOException ex) {
            throw ex;
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException ex) {
                    throw ex;
                }
            }
        }

        String codeInput = htmlUnescape(stringBuilder.toString());

        String codeOutput = "";


        String testId = request.getParameter("testId");
        String taskId = request.getParameter("taskId");


        String fileName = "code" + "_" + testId +  "_" + taskId +  "_" +System.currentTimeMillis();

        BufferedWriter writer = new BufferedWriter(new FileWriter("C:\\inz_code\\"+fileName + ".cpp"));
        writer.write(codeInput);
        writer.close();

        Process compileProcess = null;
        StringBuilder compileErrors = new StringBuilder("");
        /*
        File myObj = new File("C:\\inz_code\\output"+fileName+".exe");
        if (myObj.createNewFile()) {
            System.out.println("File created: " + myObj.getName());
        } else {
            System.out.println("File already exists.");
        }
*/
        try {
            ProcessBuilder pb;
            pb = new ProcessBuilder("C:\\MinGW\\bin\\g++.exe","C:\\inz_code\\"+fileName+".cpp","-o","C:\\inz_code\\output"+fileName+".exe");

            compileProcess = pb.start();
            compileProcess.waitFor(5, TimeUnit.SECONDS);  // let the process run for 5 seconds


            InputStream inputStream = compileProcess.getErrorStream();
            BufferedReader reader = new BufferedReader (new InputStreamReader(inputStream));

            String line1=null;
            while ((line1 = reader.readLine()) != null) {
                compileErrors.append(line1.substring(line1.indexOf(".cpp:") + 5));
                compileErrors.append("\n");
            }

            System.out.print("Compile Errors: "+ compileErrors);

            System.out.println( compileProcess.info().command());

            compileProcess.destroy();// tell the process to stop
            compileProcess.waitFor(10, TimeUnit.SECONDS); // give it a chance to stop
            compileProcess.destroyForcibly();             // tell the OS to kill the process
            compileProcess.waitFor();                     // the process is now dead

        }
        catch (Exception ex)

        {

            ex.printStackTrace();


        }

        if (!compileErrors.toString().equals("")){
            codeOutput = compileErrors.toString();
        }
        else{
            codeOutput = "output"+fileName+".exe";
        }

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(codeOutput);

    }

        private void testCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, NumberFormatException {

        TaskDao taskDao = new TaskDao();

        String codeOutput = "";

        String testId = request.getParameter("testId");
        String taskId = request.getParameter("taskId");


        String fileName = "code" + "_" + testId +  "_" + taskId +  "_" +System.currentTimeMillis();
        String codeInput  = "";
        if(request.getParameter("answer") != null){
            codeInput = request.getParameter("answer");
            Task task = taskDao.getTaskById(Integer.valueOf(taskId));
            task.setAnswer(codeInput);
            taskDao.updateTask(task);


        }
        else{
            codeInput = taskDao.getTaskById(Integer.valueOf(taskId)).getAnswer();
        }





        BufferedWriter writer = new BufferedWriter(new FileWriter("C:\\inz_code\\"+fileName + ".cpp"));
        writer.write(codeInput);
        writer.close();

        Process compileProcess = null;
        StringBuilder compileErrors = new StringBuilder("");
        /*
        File myObj = new File("C:\\inz_code\\output"+fileName+".exe");
        if (myObj.createNewFile()) {
            System.out.println("File created: " + myObj.getName());
        } else {
            System.out.println("File already exists.");
        }
*/
        try {
            ProcessBuilder pb;
            pb = new ProcessBuilder("C:\\MinGW\\bin\\g++.exe","C:\\inz_code\\"+fileName+".cpp","-o","C:\\inz_code\\output"+fileName+".exe");

            compileProcess = pb.start();
            compileProcess.waitFor(5, TimeUnit.SECONDS);  // let the process run for 5 seconds


            InputStream inputStream = compileProcess.getErrorStream();
            BufferedReader reader = new BufferedReader (new InputStreamReader(inputStream));

            String line1=null;
            while ((line1 = reader.readLine()) != null) {
                compileErrors.append(line1.substring(line1.indexOf(".cpp:") + 5));
                compileErrors.append("\n");
            }

            System.out.print("Compile Errors: "+ compileErrors);

            compileProcess.destroy();// tell the process to stop
            compileProcess.waitFor(10, TimeUnit.SECONDS); // give it a chance to stop
            compileProcess.destroyForcibly();             // tell the OS to kill the process
            compileProcess.waitFor();                     // the process is now dead

        }
        catch (Exception ex)

            {

                ex.printStackTrace();


            }

        if (!compileErrors.toString().equals("")){
            codeOutput = compileErrors.toString();
        }
        else{
            try {
                ProcessBuilder pb=new ProcessBuilder();
                pb = new ProcessBuilder("C:\\inz_code\\output"+fileName+".exe");

                Process process = pb.start();
                process.waitFor(5, TimeUnit.SECONDS);  // let the process run for 5 seconds

                InputStream inputStream = process.getInputStream();
                BufferedReader reader = new BufferedReader (new InputStreamReader(inputStream));

                String line1=null;
                while ((line1 = reader.readLine()) != null) {
                    codeOutput += line1;
                }

                process.destroy();// tell the process to stop
                process.waitFor(10, TimeUnit.SECONDS); // give it a chance to stop
                process.destroyForcibly();             // tell the OS to kill the process
                process.waitFor();                     // the process is now dead

                System.out.println("Code output: " + codeOutput);

                int x = process.exitValue();
                System.out.println("Exit value: " + x);
            }
            catch (Exception ex)

            {
                ex.printStackTrace();
            }
        }

        RequestDispatcher dispatcher = null;

        if(request.getParameter("target").equals("grading")){

            int taskPos = Integer.parseInt(request.getParameter("taskPos"));
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=gradingTest&testId="+testId+"&taskPos="+taskPos+"&codeOutput="+codeOutput);
        }
        else{
            int taskPos = Integer.parseInt(request.getParameter("taskPos"));
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=test&testId="+testId+"&taskPos="+taskPos+"&codeOutput="+codeOutput);
        }


        dispatcher.forward(request, response);




    }

    private void markTest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();

        TestDao testDao = new TestDao();

        Integer testId = Integer.valueOf(request.getParameter("testId"));
        Integer testGrade = Integer.valueOf(request.getParameter("gradeTest"));

        Test test = testDao.getTestById(testId);
        test.setGrade(testGrade);
        testDao.updateTest(test);

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=gradingTests");
        dispatcher.forward(request, response);

    }

    private void deleteGroup(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        session = request.getSession();

        GroupDao groupDao = new GroupDao();

        groupDao.deleteGroupById(Integer.parseInt(request.getParameter("groupId")));

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=groups");
        dispatcher.forward(request, response);
    }

    private void updateGroup(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        session = request.getSession();

        GroupDao groupDao = new GroupDao();

        int groupId = Integer.parseInt(request.getParameter("groupId"));

        Group group = groupDao.getGroupById(groupId);
        group.setDescription(request.getParameter("groupDescription"));
        group.setName(request.getParameter("groupName"));

        String[] users = request.getParameter( "userChanges").split(",");
        if(users[0].equals("0") ){

        }
        else{
            UserDao userDao = new UserDao();

            for (int i = 0; i < users.length; i++) {
                System.out.println("userID being flipped: " + Integer.parseInt(users[i]));
                User user = userDao.getUserById(Integer.parseInt(users[i]));

                if( group.getUsers().containsKey(user.getId())){
                    group.removeUser(user);
                }
                else{
                    group.addUser(user);
                }
            }
        }

        groupDao.updateGroup(group);

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=groups");
        dispatcher.forward(request, response);
    }

    private void addGroup(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        session = request.getSession();

        GroupDao groupDao = new GroupDao();
        Group newGroup = new Group();

        newGroup.setDescription(request.getParameter("groupDescription"));
        newGroup.setName(request.getParameter("groupName"));
        groupDao.saveGroup(newGroup);

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=groups");
        dispatcher.forward(request, response);
    }

    private void gradeTask(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

        System.out.println("Grading task!");
        session = request.getSession();
        Integer taskId = (Integer.parseInt(request.getParameter("taskId")));

        TaskDao taskDao = new TaskDao();
        Task task = taskDao.getTaskById(taskId);
        task.setGraded(Integer.parseInt(request.getParameter("score")));
        task.setCorrected_answer(request.getParameter("correctedAnswer"));
        taskDao.updateTask(task);
        System.out.println("Saved grading task to db");

        String testId = request.getParameter("testId");
        int taskPos = Integer.parseInt(request.getParameter("taskPos"));

        System.out.println("Sending back to grading");

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=gradingTest&testId="+testId+"&taskPos="+taskPos);
        dispatcher.forward(request, response);

    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();

        UserDao userDao = new UserDao();
        userDao.deleteUserById(Integer.parseInt(request.getParameter("userId")));

        RequestDispatcher dispatcher = null;
        dispatcher = request.getRequestDispatcher("index.jsp?webpage=users");
        dispatcher.forward(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();

        UserDao userDao = new UserDao();
        String errors = "";

        User user = userDao.getUserById(Integer.parseInt(request.getParameter("userId")));
        String username = request.getParameter("username");
        if(!username.equals(user.getUsername())){ //check if username is taken only if it changes
            User userCheck = userDao.getUserByUsername(username);

            if(userCheck == null ){
                user.setUsername(username);
            }
            else{
                errors = "Użytkownik o podanej nazwie "+ username +" już istnieje";

            }
        }







        user.setPassword(Parser.bCryptPasswordEncoder().encode(request.getParameter("password1")));
        user.setEmail(request.getParameter("email"));
        user.setType(Integer.parseInt(request.getParameter("type")));
        userDao.updateUser(user);


        RequestDispatcher dispatcher = null;

        if(errors.equals("")){

            userDao.updateUser(user);
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=users");
                 }
        else{
            request.setCharacterEncoding("UTF-8");
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=error&targetPage=users&errors="+errors);
        }
        dispatcher.forward(request, response);

    }




    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        //System.out.print("Username " + username + "\n" );
        String errors = "";

        RequestDispatcher dispatcher = null;

        User userCheck = userDao.getUserByUsername(username);
        session = request.getSession();

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


            dispatcher = request.getRequestDispatcher("index.jsp?webpage=loginErrors&errors="+errors);
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
    private void register(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        session = request.getSession();
        String errors = "";

        String username = request.getParameter("username");
        User userCheck = userDao.getUserByUsername(username);
        User newUser = new User();

        if(userCheck == null ){
            newUser.setUsername(username);
        }
        else{
            errors = "Użytkownik o podanej nazwie "+ username +" już istnieje";

        }

        String password1 = request.getParameter("password1");
        String password2 = request.getParameter("password2");

        if(password1.equals(password2)){
            newUser.setPassword(Parser.bCryptPasswordEncoder().encode(password1));
            String complexityCheck = Parser.isGoodPasswd(password1);

            if(complexityCheck.equals("good")){
                newUser.setPassword(Parser.bCryptPasswordEncoder().encode(password1));
            }
            else if(complexityCheck.equals("short")){
                errors = "Hasło jest zbyt krótkie";
            }
            else if(complexityCheck.equals("weak")){
                errors = "Hasło jest zbył słabe, wymagana jest co najmniej 1 mała litera, 1 wielka litera, 1 cyfra i 1 znak alfanumeryczny";
            }
            else{
                errors = "Bład sprawdzania poprawności hasła";
            }
        }
        else{
            errors = "Podane hasła nie zgadzają się ze sobą";
        }


        String email = request.getParameter("email");
        boolean isEmail = Pattern.compile("^\\S+@\\S+$").matcher(email).matches();
        if(isEmail){
            newUser.setEmail(email);
        }
        else{
            errors = "podany adres e-mail nie wygląda na prawidłowy";
        }

        newUser.setType(1);

        RequestDispatcher dispatcher = null;
        if(errors.equals("")){
            UserDao userDao = new UserDao();
            userDao.saveUser(newUser);
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=login");
        }
        else{
            request.setCharacterEncoding("UTF-8");
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=error&targetPage=register&errors="+errors);
        }

        dispatcher.forward(request, response);


    }

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

        Task task = taskDao.getTaskById(Integer.parseInt(request.getParameter("taskId")));
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

        Task task = taskDao.getTaskById(Integer.parseInt(request.getParameter("taskId")));
        task.setAnswer(request.getParameter("answer"));
        taskDao.updateTask(task);

        Integer test_id =  Integer.parseInt(request.getParameter("test"));
        taskDao.submitTest(test_id);


        RequestDispatcher dispatcher = null;

        dispatcher = request.getRequestDispatcher("index.jsp?webpage=tests");

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
            dispatcher = request.getRequestDispatcher("index.jsp?webpage=test&taskPos=0&testId="+testID);

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






}