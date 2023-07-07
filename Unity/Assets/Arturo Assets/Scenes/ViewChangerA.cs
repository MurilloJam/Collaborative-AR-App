using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class ViewChangerA : MonoBehaviour
{
    private GameObject fullearth;
    private GameObject layers;
    private int counter = 0; 

    // Start is called before the first frame update
    void Start()
    {
        layers = GameObject.Find("Earth sections");
        fullearth = GameObject.Find("Earth OuterCrust");

        layers.SetActive(false);
    }

    
    public void Click()
    {
        if (counter == 0)
        {
            Debug.Log("OuterCrust is true");
            layers.SetActive(true);
            fullearth.SetActive(false);
            counter++;
        }
        else if (counter == 1)
        {
            Debug.Log("OuterCrust is false");
            layers.SetActive(false);
            fullearth.SetActive(true);
            counter--;
        }
    }
}
