using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class ARPlacement : MonoBehaviour
{
    public GameObject[] ObjectsToSpawn;
    public GameObject placementIndicator;
    private GameObject spawnedObject;
    private Pose placementPose;
    private bool placementPoseIsValid = false;
    private ARRaycastManager raycastManager;
    [SerializeField] private ObjectSelection obj;
    [SerializeField] private ToolManagement toolM;
    //[SerializeField] private Button Cube;
    //[SerializeField] private Button Capsule;
      //The buttons for above were for test items, can be swicthed to use the planet layer buttons with the UI
    

    // Start is called before the first frame update
    private void Start()
    {
        raycastManager = FindObjectOfType<ARRaycastManager>();
        
        //Cube.onClick.AddListener(() => obj.CubeSelect());
        //Capsule.onClick.AddListener(() => obj.CapsuleSelect());

        //above uses buttons listeners that then call on the object selector and associates the functions with them.
       
    }

    // Update is called once per frame
    private void Update()
    {
        if (toolM.currentTool == ToolManagement.Tool.Place)
        {
            if (/*spawnedObject == null &&*/ placementPoseIsValid && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began)
            {
                //the line above section of "spawnedObject == null" makes so that only one object can be placed. removing it allows multiple objects to be placed.
                //new function called for placing objects
                PlaceObject();
            }
        }

        //Part above meant to only place objects when place tool is active but does not work as of 7/6/2022

        //if (/*spawnedObject == null &&*/ placementPoseIsValid && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began)
        //{
        //    //the line above section of "spawnedObject == null" makes so that only one object can be placed. removing it allows multiple objects to be placed.
        //    //new function called for placing objects
        //    PlaceObject();
        //}

        UpdatePlacementPose();
        UpdatePlacementIndicator();
        //Debug.Log(obj.currentObj);
    }

    private void UpdatePlacementIndicator()
    {
        if (spawnedObject == null && placementPoseIsValid)
        {
            placementIndicator.SetActive(true);
            placementIndicator.transform.SetPositionAndRotation(placementPose.position, placementPose.rotation);
        }
        else
        {
            placementIndicator.SetActive(false);
        }
    }

    private void UpdatePlacementPose()
    {
        var screenCenter = Camera.current.ViewportToScreenPoint(new Vector3(0.5f, 0.5f));
        var hits = new List<ARRaycastHit>();
        raycastManager.Raycast(screenCenter, hits, TrackableType.Planes);

        placementPoseIsValid = hits.Count > 0;
        if (placementPoseIsValid)
        {
            placementPose = hits[0].pose;

            var cameraForward = Camera.current.transform.forward;
            var cameraBearing = new Vector3(cameraForward.x, 0, cameraForward.z).normalized;
            placementPose.rotation = Quaternion.LookRotation(cameraBearing);
        }
    }

    private void PlaceObject()
    {

        
        //if(obj.currentObj == ObjectSelection.Objects.Cube) { spawnedObject = Instantiate(ObjectsToSpawn[0], placementPose.position, placementPose.rotation); }

        //if(obj.currentObj == ObjectSelection.Objects.Capsule) { spawnedObject = Instantiate(ObjectsToSpawn[1], placementPose.position, placementPose.rotation); }
        
    }

    //void RemoveObject()
    //{
    //    Destroy(spawnedObject);
    //}

    bool DoesObjAlreadyExist()
    {
        GameObject exisitngLayer;
        exisitngLayer = GameObject.Find("Core");
        if(exisitngLayer != null && obj.currentLayer == ObjectSelection.Layers.Core)
        {
            return true;
        }
        exisitngLayer = GameObject.Find("Mantle");
        if (exisitngLayer != null && obj.currentLayer == ObjectSelection.Layers.Mantle)
        {
            return true;
        }
        exisitngLayer = GameObject.Find("Outer Core");
        if (exisitngLayer != null && obj.currentLayer == ObjectSelection.Layers.OuterCore)
        {
            return true;
        }
        return false;
    }
}