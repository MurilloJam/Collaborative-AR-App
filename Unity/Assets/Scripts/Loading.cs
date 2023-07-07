using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Loading : MonoBehaviour
{
    public RectTransform loadingArrow;
    public float oneStepAngle;

    void Update()
    {
        Vector3 rotAngle = loadingArrow.localEulerAngles;
        rotAngle.z += oneStepAngle;
        loadingArrow.localEulerAngles = rotAngle;         
    }
}
