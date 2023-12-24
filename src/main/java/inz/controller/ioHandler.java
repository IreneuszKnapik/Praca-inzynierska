package inz.controller;

import org.java_websocket.WebSocket;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

public class ioHandler extends Thread{
    InputStream is;
    WebSocket conn;
    String output;
    Process process;
    Boolean processClosed;

    ioHandler(InputStream is, WebSocket conn, Process process) {
        this.is = is;
        this.conn = conn;
        this.process = process;
        this.processClosed = false;
    }

    public String getOutput() {
        return output;
    }

    public void run() {

        while(true){
        try {
            if(is.available() > 0){
                byte[] buffer;
                buffer = new byte[is.available()];
                is.read(buffer);
                System.out.print(new String(buffer));
                conn.send(new String(buffer));
                // Your code here to deal with buffer.

            }
            else{
                if(processClosed){
                    conn.send("\n Proces został ukończony \n");
                    conn.close();
                }

            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        try{
            if(!process.isAlive()){
                if(!processClosed){

                }
                processClosed = true;

               // break;
            }

            //System.out.println("process.isAlive():"+process.isAlive());
        } catch (IllegalThreadStateException e) {
            // expected, here the logic will jump to if the program is still running
        }
    }



    }



}
