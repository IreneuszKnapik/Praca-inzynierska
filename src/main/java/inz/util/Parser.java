package inz.util;

import inz.model.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class Parser {

    public static BCryptPasswordEncoder bCryptPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }

    public static boolean isCorrectPasswd(User user, String passwd ){
        return bCryptPasswordEncoder().matches(passwd, user.getPassword());
    }

    public static boolean isCorrectPasswd2(User user, String passwd){
       if(user.getUsername().equals("admin") && passwd.equals("admin1")){
           return true;
       }
       else{
           return false;
       }
    }

    public static String parse(String input)
    {
        String pattern="register;login;landing;taskTemplates;main;admin;loginErrors;test;tests;testTemplates;testTemplate;addTestTemplate;editTestTemplate;";

        String output = "landing";
        String[] pages = pattern.split(";");
        if (input==null) input="landing";


        for (String matching: pages)
        {
            if (input.equals(matching)) output = input;
        }
        return output;
    }

}
