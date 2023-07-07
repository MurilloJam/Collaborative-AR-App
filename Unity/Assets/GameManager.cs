using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public int maxMessages = 25;
    public GameObject chatPanel, textObject;
    public InputField chatBox;
    public Button chatButton;
    private bool Click;

    [SerializeField]
    private List<Message> messageList = new List<Message>();

    // Start is called before the first frame update
    private void Start()
    {
        Click = false;
    }

    // Update is called once per frame
    private void Update()
    {
        if (chatBox.text != "")
        {
            if (Input.GetKeyDown(KeyCode.Return) || Click)
            {
                SendMessageToChat(chatBox.text);
                chatBox.text = "";
                Click = false;
            }
        }
        if (!chatBox.isFocused)
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                SendMessageToChat("Space was Pressed");
            }
        }
    }

    public void SendMessageToChat(string text)
    {
        if (messageList.Count >= maxMessages)
        {
            Destroy(messageList[0].textObject.gameObject);
            messageList.Remove(messageList[0]);
        }

        Message newMessage = new Message();
        newMessage.text = text;
        GameObject newText = Instantiate(textObject, chatPanel.transform);
        newMessage.textObject = newText.GetComponent<Text>();
        newMessage.textObject.text = newMessage.text;
        messageList.Add(newMessage);
    }

    public void OnClick()
    {
        Click = true;
    }
}

[System.Serializable]
public class Message
{
    public string text;
    public Text textObject;
}