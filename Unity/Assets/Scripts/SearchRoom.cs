using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using System;

public class SearchRoom
{
    [SerializeField] private string command;
    [SerializeField] private string _id;
    [SerializeField] private string date;
    [SerializeField] private long unixTimestamp;
    
    private DateTimeOffset offsetTime;
    private long responseTime;
    private string data;

    public SearchRoom() { command = ""; _id = ""; }
    public void setCommand(string _command) { command = _command; }
    public void setPlayerID(string _playerID) { _id = _playerID; }
    public void setDate() { date = DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss:fff tt"); }
    public void setUnixTimestamp() { offsetTime = DateTimeOffset.UtcNow; unixTimestamp = offsetTime.ToUnixTimeMilliseconds(); }
    public string getData() { getDeltaTimestamp(); return data; }
    public void getDeltaTimestamp()
    {
        offsetTime = DateTimeOffset.UtcNow;
        responseTime = offsetTime.ToUnixTimeMilliseconds();
        string received = DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss:fff tt");
        Debug.Log("Received Date Time: " + offsetTime + " Response Time: " + responseTime);
        data = command + ", " + _id + ", " + date + ", " + unixTimestamp.ToString() + ", " + received + ", " + responseTime.ToString() + ", " + (responseTime - unixTimestamp).ToString();
    }
    
}