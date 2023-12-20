package inz.controller;

import org.java_websocket.WebSocket;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;
import org.unbescape.html.HtmlEscape;

import java.io.*;
import java.net.InetSocketAddress;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;


public class TestServer extends WebSocketServer implements Runnable  {


    private boolean testProcessStarted;
    private HashMap<WebSocket,Boolean> codeCompiles;
    private HashMap<WebSocket,Process> codeTests;

    public TestServer(InetSocketAddress address) {
        super(address);
        testProcessStarted = false;
        codeCompiles = new HashMap<>();
        codeTests = new HashMap<>();

    }

    @Override
    public void onOpen(WebSocket conn, ClientHandshake handshake) {
        System.out.println("new connection to " + conn.getRemoteSocketAddress());
    }

    @Override
    public void onClose(WebSocket conn, int code, String reason, boolean remote) {
        System.out.println("closed " + conn.getRemoteSocketAddress() + " with exit code " + code + " additional info: " + reason);
    }

    @Override
    public void onMessage(WebSocket conn, String message) {
        System.out.println(conn.toString());

        if(!codeCompiles.containsKey(conn)){
            //first message is always in format action=testCodeCompile&testId=$testId&taskId=$taskId&$code

            String[] request = message.split("&",4);
            System.out.println("request:" + request);
            System.out.println("request[0]: " + request);
            if(request[0].equals("action=testCodeCompile")){
                codeCompiles.put(conn,true);
                Boolean compilationFailed = false;
                String testId = request[1].substring(7);
                String taskId = request[2].substring(7);;
                System.out.println("testId:" + testId);
                System.out.println("taskId:" + taskId);

                String code = request[3];

                code = HtmlEscape.unescapeHtml(code);

                System.out.println("code:\n" + code);

                String fileName = "code" + "_" + testId +  "_" + taskId +  "_" +System.currentTimeMillis();

                //conn.send("C:\\inz_code\\"+fileName + ".cpp");


                try {
                    BufferedWriter writer = new BufferedWriter(new FileWriter("C:\\inz_code\\"+fileName + ".cpp"));
                    writer.write(code);
                    writer.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }

                Process compileProcess = null;
                StringBuilder compileErrors = new StringBuilder("");

                String compOutput = "";

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

                    //compileProcess.destroy();// tell the process to stop
                    //compileProcess.waitFor(10, TimeUnit.SECONDS); // give it a chance to stop
                    //compileProcess.destroyForcibly();             // tell the OS to kill the process
                    //compileProcess.waitFor();                     // the process is now dead

                }
                catch (Exception ex)

                {

                    ex.printStackTrace();


                }

                if (!compileErrors.toString().equals("")){
                    compOutput = compileErrors.toString();
                    conn.send(compOutput);
                    compilationFailed = true;
                }
                else{
                    conn.send("Kompilacja powiodła się\n");
                    compOutput = "output"+fileName+".exe";
                }
                //conn.send("compilation result:" + compOutput);

                if(!compilationFailed){
                    String execName = "C:\\inz_code\\output"+fileName+".exe";




                    if(codeTests.containsKey(conn)){
                        System.out.println("Process exists: "+conn +"\n Exec name: "+execName);
                    }
                    else{
                        try {


                            ProcessBuilder pb = new ProcessBuilder(execName);

                            Process process = pb.start();
                            codeTests.put(conn,process);
                            ioHandler outputHandler = new ioHandler(process.getInputStream(),conn);
                            outputHandler.start();

                            System.out.println("Creating process: "+execName);
                            conn.send("Twój program się uruchamia\n");





                        }
                        catch (Exception ex)

                        {
                            ex.printStackTrace();
                        }
                    }
                }



            }

        }
        else{ //if code is already compiled and running, just perform input to process, output is sent by the handler


            if(codeTests.containsKey(conn)) {
                System.out.println("received message from "	+ conn.getRemoteSocketAddress() + ": " + message);
                System.out.println(conn.toString());
                Process process =codeTests.get(conn);
                OutputStream outputStream = process.getOutputStream();
                PrintWriter writer = new PrintWriter(outputStream);

                System.out.println("writer writes 2");
                writer.printf("%s\n",message);
                writer.flush();
                System.out.println("writer wrote 2");
                /*
                int exitValue;
                try {
                    exitValue = process.exitValue();
                    System.out.println("Exit value: " + exitValue);
                    codeCompiles.remove(conn);
                    codeTests.remove(conn);
                    conn.close();

                } catch (IllegalStateException e) {
                    e.printStackTrace();
                }
                */






            }
            else{
                conn.send("Nie znaleziono procesu dla twojego rpogramu - spróbuj ponownie lub popraw kod\n");


            }




        }


    }

    @Override
    public void onError(WebSocket conn, Exception ex) {
        System.err.println("an error occurred on connection " + conn.getRemoteSocketAddress()  + ":" + ex);
    }

    @Override
    public void onStart() {
        System.out.println("server started successfully");
    }
}
