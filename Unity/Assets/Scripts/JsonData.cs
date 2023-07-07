using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using System;

[System.Serializable]
public class JsonData
{
    public string command;
    public string _id;
    public Vector3 position;
    public Quaternion rotation;
    public Vector3 scale;
    public string date;
    public long unixTimestamp;

    public string objectMesh;
    public bool IsSelected;

    private string data;
    private long unixTimestampResponse;
    private DateTimeOffset offsetTime;
    
    public JsonData() { }
    public string getCommand() { return command; }
    public string getID() { return _id; }
    public Vector3 getPosition() { return position; }
    public Quaternion getRotation() { return rotation; }
    public Vector3 getScale() { return scale; }
    public string getObjectMesh() { return objectMesh; }
    public bool isObjectSelected() { return IsSelected; }

    public string getDate() { return date; }
    public long getUnixTimestamp() { return unixTimestamp; }
    
    public string getData()
    {
        offsetTime = DateTimeOffset.UtcNow;
        unixTimestampResponse = offsetTime.ToUnixTimeMilliseconds();
        //string received = DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss:fff tt");
        data = command + ", " + unixTimestamp.ToString() + ", " + unixTimestampResponse.ToString() + ", " + (unixTimestampResponse - unixTimestamp).ToString();
        return data;
    }
}