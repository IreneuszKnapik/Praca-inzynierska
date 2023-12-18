package inz.controller;

import org.java_websocket.WebSocket;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

public class ioHandler extends Thread{
    InputStream is;
    WebSocket conn;
    String output;

    ioHandler(InputStream is, WebSocket conn) {
        this.is = is;
        this.conn = conn;
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
        } catch (IOException e) {
            e.printStackTrace();
        }
    }



    }



}
