using ARDrawing.Core.Singletons;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.XR.ARFoundation;

[RequireComponent(typeof(ARAnchorManager))]
public class ARDrawManager : Singleton<ARDrawManager>
{
    [SerializeField]
    private LineSettings lineSettings;

    [SerializeField]
    private UnityEvent OnDraw;

    [SerializeField]
    private ARAnchorManager anchorManager;

    [SerializeField]
    private Camera arCamera;

    private List<ARAnchor> arAnchors = new List<ARAnchor>();
    private Dictionary<int, ARLine> Lines = new Dictionary<int, ARLine>();

    private bool CanDraw { get; set; }

    private void Update()
    {
#if !UNITY_EDITOR
        if (Input.touchCount >0)
        {
        DrawOnTouch();
        }
#else
        if (Input.GetMouseButton(0))
            DrawOnMouse();

#endif
    }

    public void AllowDraw(bool isAllow)
    {
        CanDraw = isAllow;
    }

    private void DrawOnTouch()
    {
        DrawOnTouch(anchorManager);
    }

    void DrawOnTouch(ARAnchorManager anchorManager)
    {
        if (!CanDraw) return;

        Touch touch = Input.GetTouch(0);
        Vector3 touchPosition = arCamera.ScreenToWorldPoint(new Vector3(Input.GetTouch(0).position.x, Input.GetTouch(0).position.y, lineSettings.distanceFromCamera));

        if (touch.phase == TouchPhase.Began)
        {
            OnDraw?.Invoke();

            ARAnchor anchor = anchorManager.AddAnchor(new Pose(touchPosition, Quaternion.identity));

            if (anchor == null)
                Debug.LogError("Error creating reference point");
            else
            {
                arAnchors.Add(anchor);
            }
            ARLine line = new ARLine(lineSettings);
            Lines.Add(touch.fingerId, line);
            line.AddNewLineRenderer(transform, anchor, touchPosition);
        }
        else if (touch.phase == TouchPhase.Moved || touch.phase == TouchPhase.Stationary)
        {
            Lines[touch.fingerId].AddPoint(touchPosition);
        }
        else if (touch.phase == TouchPhase.Ended)
        {
            Lines.Remove(touch.fingerId);
        }
    }

    private void DrawOnMouse()
    {
        if (!CanDraw) return;

        Vector3 mousePos = arCamera.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, lineSettings.distanceFromCamera));
        if (Input.GetMouseButtonDown(0))
        {
            OnDraw?.Invoke();
            if (Lines.Keys.Count == 0)
            {
                ARLine line = new ARLine(lineSettings);
                Lines.Add(0, line);
                line.AddNewLineRenderer(transform, null, mousePos);
            }
            else
            {
                Lines[0].AddPoint(mousePos);
            }
        }
        else if (Input.GetMouseButtonUp(0))
        {
            Lines.Remove(0);
        }
    }
}