using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;


[RequireComponent(typeof(ARRaycastManager))]
public class ARButtonObjectPlace : MonoBehaviour
{

    private ARRaycastManager _arRaycastManager;
    private GameObject spawnedObject;
    private List<GameObject> placedPrefabList = new List<GameObject>();

    [SerializeField]
    private int maxPrefabSpawnCount = 1;
    private int placedPrefabCount;
    private int crustcounter;
    private int incorecounter;
    private int outcorecounter;
    private int mantlecounter;
    private string prefabname;

    [SerializeField]
    private GameObject PlaceablePrefab;

    static List<ARRaycastHit> hits = new List<ARRaycastHit>();

    private void Awake()
    {
        _arRaycastManager = GetComponent<ARRaycastManager>();
    }

    bool TryGetTouchPosition(out Vector2 touchPosition)
    {
        if(Input.GetTouch(0).phase == TouchPhase.Began)
        {
            touchPosition = Input.GetTouch(0).position;
            return true;
        }
        touchPosition = default;
        return false;
    }

    void Update()
    {
        if(!TryGetTouchPosition(out Vector2 touchPosition))
        {
            return;
        }
        
        if(_arRaycastManager.Raycast(touchPosition, hits, TrackableType.Planes))
        {
            var hitPose = hits[0].pose;

            if (placedPrefabCount < maxPrefabSpawnCount)
            {   
                if(crustcounter < 1 && prefabname == "Earth Crust Variant")
                {
                    SpawnPrefab(hitPose);
                    crustcounter++;
                }
                else if(incorecounter < 1 && prefabname == "Earth InnerCore Variant")
                {
                    SpawnPrefab(hitPose);
                    incorecounter++;
                }
                else if(outcorecounter < 1 && prefabname == "Earth Core Variant")
                {
                    SpawnPrefab(hitPose);
                    outcorecounter++;
                }
                else if(mantlecounter < 1 && prefabname == "EarthMantle Variant")
                {
                    SpawnPrefab(hitPose);
                    mantlecounter++;
                }
            }

        }
    }

    public void SetPrefabType(GameObject prefabType)
    {
        PlaceablePrefab = prefabType;
        prefabname = PlaceablePrefab.name;
    }

    private void SpawnPrefab(Pose hitPose)
    {
        spawnedObject = Instantiate(PlaceablePrefab, hitPose.position, hitPose.rotation);
        placedPrefabList.Add(spawnedObject);
        placedPrefabCount++;
    }

    public void ResetButton()
    {
        foreach(GameObject spot in placedPrefabList)
        {
            Destroy(spot);
        }
        placedPrefabList.Clear();
        crustcounter = 0;
        incorecounter = 0;
        outcorecounter = 0;
        mantlecounter = 0;
        placedPrefabCount = 0;


    }
}
