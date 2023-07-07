using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class ARLine
{
    private int positionCount = 0;
    private Vector3 prevPointDistance = Vector3.zero;
    private LineRenderer lineRenderer { get; set; }
    private LineSettings settings;

    public ARLine(LineSettings settings)
    {
        this.settings = settings;
    }

    public void AddPoint(Vector3 position)
    {
        if (prevPointDistance == null)
        {
            prevPointDistance = position;
        }
        if (prevPointDistance != null && Mathf.Abs(Vector3.Distance(prevPointDistance, position)) >= settings.minDistanceBeforeNewPoint)
        {
            prevPointDistance = position;
            positionCount++;

            lineRenderer.positionCount = positionCount;

            //index 0 position count must be -1
            lineRenderer.SetPosition(positionCount - 1, position);

            //applies simplification if reminder is 0
            if (lineRenderer.positionCount % settings.applySimplifyAfterPoints == 0 && settings.allowSimplification)
            {
                lineRenderer.Simplify(settings.tolerance);
            }
        }
    }

    public void AddNewLineRenderer(Transform parent, ARAnchor anchor, Vector3 position)
    {
        positionCount = 2;
        GameObject go = new GameObject($"LineRenderer");

        go.transform.parent = anchor?.transform ?? parent;
        go.transform.position = position;
        go.tag = "AR Object";
        LineRenderer goLineRenderer = go.AddComponent<LineRenderer>();
        goLineRenderer.startWidth = settings.startWidth;
        goLineRenderer.endWidth = settings.endWidth;
        goLineRenderer.material = settings.defaultColorMaterial;
        goLineRenderer.useWorldSpace = true;
        goLineRenderer.positionCount = positionCount;
        goLineRenderer.numCornerVertices = settings.cornerVertices;
        goLineRenderer.numCapVertices = settings.endCapVertices;
        goLineRenderer.SetPosition(0, position);
        goLineRenderer.SetPosition(1, position);

        lineRenderer = goLineRenderer;
    }
}