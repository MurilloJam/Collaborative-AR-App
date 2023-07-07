using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class ARCursor : MonoBehaviour
{
    public GameObject cursorChild;
    public ARRaycastManager raycastManager;

    public bool useCursor = true;

    // Start is called before the first frame update
    private void Start()
    {
        cursorChild.SetActive(useCursor);
    }

    // Update is called once per frame
    private void Update()
    {
        if (useCursor)
        {
            UpdateCursor();
        }
    }

    private void UpdateCursor()
    {
        Vector2 screenPosition = Camera.main.ViewportToScreenPoint(new Vector2(0.5f, 0.5f));
        List<ARRaycastHit> hits = new List<ARRaycastHit>();
        raycastManager.Raycast(screenPosition, hits, UnityEngine.XR.ARSubsystems.TrackableType.Planes);

        if (hits.Count > 0)
        {
            transform.position = hits[0].pose.position;
            transform.rotation = hits[0].pose.rotation;
        }
    }
}