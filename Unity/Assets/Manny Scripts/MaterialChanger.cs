using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialChanger : MonoBehaviour
{
    //Layers ad their element in the object
    /*
     * Element 0 -> Clear Material
     * Element 1 -> Core
     * Element 2 -> Crust 
     * Element 3 -> Crust Out
     * Element 4 -> Inner Core
     * Element 5 -> Mantle
     */

    [SerializeField] Material[] layersMaterials; //materials to use
    [SerializeField] GameObject[] layerObj; // actual layer objects in the full sized Prefab
    [SerializeField] GameObject[] placedLayers; // actual individual layer objects
    public GameObject[] spawnedObj;
    //need ti change placed layers to auto add newly placed items that are spawnned in.
    //or find other alternative
    //POSSIBLE ALTERNATIVES
    //use bools for each layer to see if spawned and trigger events based on bools
    
    
    // Start is called before the first frame update
    void Start()
    {

       

        for (int i = 0; i < this.transform.childCount; i++)
        {
            layerObj[i] = this.transform.GetChild(i).gameObject;

        }

        for (int i = 0; i < layerObj.Length; i++)
        {
            layerObj[i].gameObject.GetComponent<Renderer>().material = layersMaterials[0];
            //in complete, crust layer has 2 materials so will need to check to see 
            //if this works with that or if needs adjustment

        }
    }

    // Update is called once per frame
    void Update()
    {


        


    }

    //New idea for checking/showing the layers

    /*
     First see if the sphere layer has SetAvtive to false
    If it is false, then show the layer proper
     */
    //void ChangeMaterial()
    //{
        
    //    for(int i = 0; i < placedLayers.Length; i++)
    //    {
    //        //Check for all these orbs to see that they are active
    //        //
    //        if (!placedLayers[i].gameObject.activeSelf) //condition is for a layer has gone inactive
    //        {
    //            //the layer is not active meaning we show it 
    //            // check the object with the layer name in the array above
    //            //match the names then change materials

    //            Debug.Log(placedLayers[i].gameObject.name);
    //            Debug.Log("IT IS GONE");

    //            //eventually change to switch cases
    //            if (placedLayers[i].gameObject.name == "CoreSphere")
    //            {
    //                layerObj[0].gameObject.GetComponent<Renderer>().material = layersMaterials[1];
    //            }
    //            else if (placedLayers[i].gameObject.name == "CrustSphere")
    //            {
    //                layerObj[1].gameObject.GetComponent<Renderer>().material = layersMaterials[2];
    //            }
    //            else if (placedLayers[i].gameObject.name == "InnerCoreSphere")
    //            {
    //                layerObj[2].gameObject.GetComponent<Renderer>().material = layersMaterials[4];
    //            }
    //            else if (placedLayers[i].gameObject.name == "MantleSphere")
    //            {
    //                layerObj[3].gameObject.GetComponent<Renderer>().material = layersMaterials[5];
    //            }
    //            else if (placedLayers[i].gameObject.name == "OuterCrustSphere")
    //            {
    //                //lol don't need to do anything
    //            }

    //        }
    //    }

    //}

    void ChangeMaterial()
    {
        for (int i = 0; i < placedLayers.Length; i++)
        {
            //use the layers in the list as reference, check for spawned in objects.
        }
    }

    void FindSpawned()
    {

    }


}
