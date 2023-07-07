using UnityEngine;

public class Rotate : MonoBehaviour
{
    // Start is called before the first frame update
    private void Start()
    {
    }

    // Update is called once per frame
    private void Update()
    {
        transform.Rotate(0f, 1f, 0f, Space.Self);
    }
}