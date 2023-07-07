using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//Description of how code should work
/*
 * Each layer prefab will have a collider
 * The colliders will check to see if they are touching with another prefab that follows along in correct order
 * Have a prefab of all layers, with the all but one layer disabled, ass users add on
 *     the layers fill on properly 
 * If not then indicate that the user has done it wrong. 
 * Order of layers will be Outer Crust -> Inner crust -> Mantle -> Core -> Inner Core
 */
public class PlanetLayerDetection : MonoBehaviour
{
    // Start is called before the first frame update
    //get what THIS game object name is/ what layer it is
    //What comes before/after

    [SerializeField] GameObject priorLayer;
    [SerializeField] GameObject nextLayer;
    [SerializeField] GameObject fullPlanet; //Gonna  have to manual put reference in the editor
    [SerializeField] int layernum;
    //[SerializeField] Material currentMat;


    

    //Create a list of all the layers

    void Start()
    {
        //currentMat = GetComponent<Renderer>().material;

        if (this.gameObject.name == "Crust")
        {
            priorLayer = null;
        }

        if (this.gameObject.name == "InnerCore")
        { 
            nextLayer = null;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject == priorLayer)
        {
            Debug.Log("Connected to the previous layer");
            WorldChecker();
            this.gameObject.SetActive(false);
            


        }
        else if(collision.gameObject == nextLayer)
        {
            Debug.Log("Connected to Next Layer");
            WorldChecker();
        }
    }

    private void WorldChecker()
    {
        if (!fullPlanet.activeSelf)  /*check to see if the Full display is active, if not make it active.*/
        {
            fullPlanet.SetActive(true);
        }
    }
}
