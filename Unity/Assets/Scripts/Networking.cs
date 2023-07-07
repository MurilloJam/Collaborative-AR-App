/* 
    *********************************************************
    To install Json from NuGet use this command:
        Install-Package System.Json -Version 4.0.20126.16343
    *********************************************************
*/ 

using UnityEngine;
using System.Net.Sockets;
using System;
using System.Text;

public class Networking : MonoBehaviour
{
    public TcpClient client = new TcpClient();
    public NetworkStream stream;
    
    public string IP;
    public int PORT;
    const double BUFFER = 5e+6;
    const int TIMEOUT = 5000;

    public byte[] data = new byte[(int)BUFFER];
    
    public bool isRunning;

    private void Start()
    {
        connect((bool proccess) =>
        {
            if (proccess)
            {
                isRunning = true;
                stream = client.GetStream();
                //Debug.Log("The app is connected to server");
            }
            else
            {
                isRunning = false;
                //Debug.Log("The app is not connected to server");
            }
        });
    }

    private void connect(Action<bool> callback)
    {
        try
        {
            bool proccess = client.ConnectAsync(IP, PORT).Wait(TIMEOUT);
            callback(proccess);
        }
        catch(Exception ex)
        {
            Debug.Log("Exception Message: " + ex.Message);
        }
    }
}