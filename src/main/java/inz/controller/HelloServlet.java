package inz.controller;


import inz.dao.UserDao;
import inz.model.User;
import inz.util.Parser;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
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


@WebServlet("/index")
@MultipartConfig

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
            userDao.saveUser(admin2);
        }

        //System.out.print(admin.getId() + " " + admin.getUsername() + " " + admin.getPassword() + " "+ admin.getEmail());


    }

    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry
                .addResourceHandler("/resources/**")
                .addResourceLocations("/static/")
                .addResourceLocations("/static/css/")
                .addResourceLocations("/static/bootstrap-4.0.0-dist/css/");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {


            currentUser = new User();
            session.setAttribute("currentUser", currentUser);
        }


        String getAction = request.getParameter("getaction");
        if (getAction == null) getAction = "";

        response.setContentType("text/html");

        RequestDispatcher dispatcher = null;


        dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);


    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        //System.out.print("Username " + username + "\n" );
        String errors = "";

        RequestDispatcher dispatcher = null;

        User usernameCheck = userDao.getUserByUsername(username);
        System.out.print("username retrieved from db:" +usernameCheck.getUsername() + "\n");
        if(usernameCheck != null) {
            System.out.print("username " + username +"not null \n");

            if(Parser.isCorrectPasswd(usernameCheck, password)){
                session.setAttribute("currentUser", usernameCheck);
                System.out.print("username " + username +"correct \n");
                dispatcher = request.getRequestDispatcher("WEB-INF/templates/main.jsp");
            }
            else{
                errors +="Nieprawidłowe Hasło<br/> ";
                dispatcher = request.getRequestDispatcher("login.jsp");
            }


        }
        else{
            errors +="Nieprawidłowy Login<br/>";
            dispatcher = request.getRequestDispatcher("login.jsp");
        }

        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session =request.getSession();
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

    }
}