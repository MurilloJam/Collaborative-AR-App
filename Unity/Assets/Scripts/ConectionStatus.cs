using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ConectionStatus : MonoBehaviour
{
    public bool playerIsAlone;
    public bool playerIsWaiting;
    public GameObject panel;

    public void enablePanelStatus(bool show)
    {
        panel.SetActive(show);
    }

    void Update()
    {
        if(playerIsWaiting)
        {
            enablePanelStatus(true);
        }
        else
        {
            enablePanelStatus(false);
        }
    }
}
