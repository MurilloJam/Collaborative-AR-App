using System.IO;
using UnityEngine;
using UnityEngine.UI;

public class ToTextFile : MonoBehaviour
{
    // Start is called before the first frame update
    public InputField inputFieldChat;

    private void Start()
    {
        Directory.CreateDirectory(Application.streamingAssetsPath + "/Chat_Logs/");
    }

    // Update is called once per frame
    public void CreateTextFile()
    {
        if (inputFieldChat.text == "")
        {
            return;
        }
        string txtDocumentName = Application.streamingAssetsPath + "/Chat_Logs/" + "Chat" + ".txt";
        if (!File.Exists(txtDocumentName))
        {
            File.WriteAllText(txtDocumentName, "Chat Logs: \n\n");
        }

        File.AppendAllText(txtDocumentName, inputFieldChat.text + "\n");
        inputFieldChat.text = "";
    }
}