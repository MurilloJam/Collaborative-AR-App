using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

public class CoreButton : MonoBehaviour
{
    public UnityEvent unityEvent = new UnityEvent();
    public GameObject button;
    public GameObject corepanel;
    public GameObject innerpanel;
    public GameObject mantlepanel;
    public GameObject crustpanel;
    // Start is called before the first frame update
    void Start()
    {
        button = GameObject.Find("Core Exit");
        corepanel = GameObject.Find("Core Panel");
        corepanel.SetActive(false);
        innerpanel = GameObject.Find("Inner Core Panel");
        innerpanel.SetActive(false);
        mantlepanel = GameObject.Find("Mantle Panel");
        mantlepanel.SetActive(false);
        crustpanel = GameObject.Find("Crust Panel");
        crustpanel.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if((Input.touchCount > 0) && (Input.GetTouch(0).phase == TouchPhase.Began))
        {
            Debug.Log("Core hit 1");
            Ray ray = Camera.main.ScreenPointToRay(Input.GetTouch(0).position);
            RaycastHit hit;

            if(Physics.Raycast(ray, out hit))
            {
                if (!EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
                {
                    Debug.Log("Core hit 2");
                    if (hit.collider.name == "Core")
                    {
                        corepanel.SetActive(true);
                        Debug.Log("Core Panel Activated");
                    }
                    else if (hit.collider.name == "Inner Core")
                    {
                        innerpanel.SetActive(true);
                        Debug.Log("Inner Core Panel Activated");
                    }
                    else if (hit.collider.name == "Mantle")
                    {
                        mantlepanel.SetActive(true);
                        Debug.Log("Mantle Panel Activated");
                    }
                    else if (hit.collider.name == "Crust")
                    {
                        crustpanel.SetActive(true);
                        Debug.Log("Crust Panel Activated");
                    }
                }

                if (hit.collider.name == "Inner Core Exit")
                {
                    corepanel.SetActive(false);
                    innerpanel.SetActive(false);
                }
            }
        }

    }
}
