using UnityEngine;

public class ObjectSelection : MonoBehaviour
{
    public enum Objects
    { Cube, Capsule, None  }

    public Objects currentObj;
    //Change objects to be planets vs the original tester objects
    public enum Layers {Crust, Core, Mantle, OuterCore, None }
    public Layers currentLayer;

    private void Start()
    {
        currentLayer = Layers.None;
    }

    public void CubeSelect()
    {
        currentObj = Objects.Cube;
    }

    public void CapsuleSelect()
    {
        currentObj = Objects.Capsule;
    }


    public void CoreSelect()
    {
        currentLayer = Layers.Core;
    }

    public void MantleSelect()
    {
        currentLayer = Layers.Mantle;
    }
    public void OuterCoreSelect()
    {
        currentLayer = Layers.OuterCore;
    }

    public void CrustSelect()
    {
        currentLayer = Layers.Crust;
    }


}