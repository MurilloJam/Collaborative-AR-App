using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class ImageRecogntionExample : MonoBehaviour
{
    private ARTrackedImageManager imageManager;

    private void Awake()
    {
        imageManager = FindObjectOfType<ARTrackedImageManager>();
    }

    private void OnEnable()
    {
        imageManager.trackedImagesChanged += OnImageChange;
    }

    private void OnDisable()
    {
    }

    // Start is called before the first frame update
    private void Start()
    {
        imageManager.trackedImagesChanged -= OnImageChange;
    }

    public void OnImageChange(ARTrackedImagesChangedEventArgs args)
    {
        foreach (var trackedImage in args.added)
        {
            Debug.Log(trackedImage.name);
        }
    }

    // Update is called once per frame
    private void Update()
    {
    }
}