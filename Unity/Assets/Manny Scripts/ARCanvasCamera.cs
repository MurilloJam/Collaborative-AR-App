using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ARCanvasCamera : MonoBehaviour
{
    [SerializeField] Canvas cam;
    // Start is called before the first frame update
    void Start()
    {
        cam = GetComponent<Canvas>();
        cam.worldCamera = FindObjectOfType<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
