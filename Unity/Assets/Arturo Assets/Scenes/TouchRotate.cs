using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TouchRotate : MonoBehaviour
{
    public float rotatespeed = 45;


    // Update is called once per frame
    void Update()
    {
        if (Input.touchCount == 1)
        {
            Touch touch = Input.GetTouch(0);
            if(touch.phase == TouchPhase.Moved)
            {
                var deltaX = touch.position.x - touch.rawPosition.x;
                var deltaY = touch.position.y - touch.rawPosition.y;

                if(deltaX != 0)
                {
                    transform.Rotate(0f, deltaX * Time.deltaTime, 0f);
                }
                else if(deltaY != 0)
                {
                    transform.Rotate(deltaY * Time.deltaTime, 0f, 0f);
                }


            }
            else if(touch.phase == TouchPhase.Ended)
            {
                Debug.Log("Touch has ended");
            }
        }

    }
}
