using UnityEngine;
using UnityEngine.UI;

public class ViewChanger : MonoBehaviour
{
    public GameObject OuterView;
    public GameObject InnerView;

    [SerializeField] private Button viewButton;

    // Start is called before the first frame update
    private void Start()
    {
        viewButton = FindObjectOfType<ButtonManager>().viewButton;
        viewButton.onClick.AddListener(ChangeView);
    }

    // Update is called once per frame
    private void Update()
    {
    }

    public void ChangeView()
    {
        Debug.Log("Swap");
        Debug.Log("Outer view is " + OuterView.activeSelf);
        Debug.Log("Inner view is " + InnerView.activeSelf);
        // when pressed, the 2 views switch options

        OuterView.SetActive(!OuterView.activeSelf);
        InnerView.SetActive(!InnerView.activeSelf);
    }
}