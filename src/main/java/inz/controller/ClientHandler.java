package inz.controller;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.IOException;
import java.net.Socket;

// ClientHandler class
class ClientHandler extends Thread
{

    final DataInputStream dis;
    final DataOutputStream dos;
    final Socket s;


    // Constructor
    public ClientHandler(Socket s, DataInputStream dis, DataOutputStream dos)
    {
        this.s = s;
        this.dis = dis;
        this.dos = dos;
    }

    @Override
    public void run()
    {
        String received;
        String toreturn;
        while (true)
        {

            //System.out.println("Client handler running");

            try {

                // receive the answer from client
                dos.writeUTF("test");
                received = dis.readUTF();
                System.out.println("received:" + received);

                if(received.equals("Hello")){
                    System.out.println("received Hello:" + received);
                    this.s.close();
                    break;
                }
                /*
                else{
                    if(received.matches("^action=testCodeCompile."))
                    {
                        String[] request = received.split("&");
                        System.out.println("request:" + request);
                        String testId = request[1];
                        String taskId = request[2];
                        System.out.println("testId:" + request);
                        System.out.println("taskId:" + request);
                        //this.s.close();
                        //break;

                    }
                }
                */






            }
            catch(EOFException e) {
                //This isn't a problem
            }
            catch (IOException e) {
                e.printStackTrace();
            }

        }

        try
        {
            // closing resources
            this.dis.close();
            this.dos.close();

        }catch(IOException e){
            e.printStackTrace();
        }
    }
}