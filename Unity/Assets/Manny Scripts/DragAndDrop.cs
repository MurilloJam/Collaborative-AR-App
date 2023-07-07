using UnityEngine;

public class DragAndDrop : MonoBehaviour
{
    private bool moveAllowed;
    private Collider col;

    // Start is called before the first frame update
    private void Start()
    {
        col = GetComponent<Collider>();
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            Vector2 touchPos = Camera.main.ScreenToWorldPoint(touch.position);

            if (touch.phase == TouchPhase.Began)
            {
                Collider[] touchedCollider = Physics.OverlapSphere(touchPos, 0.1f);
                foreach (Collider collider in touchedCollider)
                {
                    if (col == collider)
                    {
                        moveAllowed = true;
                    }
                }
            }

            if (touch.phase == TouchPhase.Moved)
            {
                //if move allowed is true, and game is not paused, move the object
                if (moveAllowed)
                {
                    transform.position = new Vector2(touchPos.x, touchPos.y);
                    //if object is touching a wall, it cannot fo through it
                }
            }
            if (touch.phase == TouchPhase.Ended)
            {
                moveAllowed = false;
            }
        }
    }
}