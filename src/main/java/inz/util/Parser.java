package inz.util;

import inz.model.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.regex.Pattern;

public class Parser {

    public static BCryptPasswordEncoder bCryptPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }

    public static boolean isCorrectPasswd(User user, String passwd ){
        return bCryptPasswordEncoder().matches(passwd, user.getPassword());
    }

    public static String isGoodPasswd(String password){
        if (password.length() < 13){
            return "short";
        }

        Integer strength = 0;

        if(Pattern.compile("/[A-Z]/.").matcher(password).matches()){
            //uppsercase check
            strength++;

        }
        if(Pattern.compile("/[a-z]/.").matcher(password).matches()){
            //uppercase check
            strength++;
        }
        if(Pattern.compile("/[a-z]/.").matcher(password).matches()){
            //uppercase check
            strength++;
        }

        if(Pattern.compile("/\\d/.").matcher(password).matches()){
            //numbers check
            strength++;
        }
        if(Pattern.compile(" /\\W/.").matcher(password).matches()){
            //nonalpha check
            strength++;
        }

        if(strength < 4){
            return "weak";
        }
        return "good";

    }


    public static String parse(String input)
    {
        String pattern="register;" +
                "login;" +
                "landing;" +
                "taskTemplates;" +
                "main;" +
                "admin;" +
                "loginErrors;" +
                "error;" +
                "gradingTests;" +
                "gradingTest;" +
                "taskTemplates;" +
                "addTaskTemplate;" +
                "editTaskTemplate;" +
                "test;" +
                "tests;" +
                "testTemplates;" +
                "addTestTemplate;" +
                "editTestTemplate;" +
                "users;" +
                "addUser;" +
                "editUser;" +
                "groups;"+
                "addGroup;" +
                "editGroup;";

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
