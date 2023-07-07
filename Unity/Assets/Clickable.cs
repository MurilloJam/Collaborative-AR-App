using System.Collections;
using System.Linq;
using UnityEngine;

public class Clickable : MonoBehaviour
{
    public string NameAndType;
    [SerializeField] private WhackAMole mainGame;
    public Transform spawnLoc; 

    // Start is called before the first frame update
    private void Start()
    {
        mainGame = FindObjectOfType<WhackAMole>();
        StartCoroutine(GoAway());
    }

    // Update is called once per frame
    private void Update()
    {
        this.transform.position = spawnLoc.position;
        this.transform.rotation = spawnLoc.rotation;
    }

    private void OnMouseDown()
    {
        Debug.Log("Clicked ON");
        if (NameAndType == mainGame.questions_answers.ElementAt(mainGame.question_index).Value)
        {
            int index = Random.Range(0, mainGame.questions_answers.Count);
            mainGame.question.text = mainGame.questions_answers.ElementAt(index).Key;
            //add to score
            mainGame.scoreNum += 20;
            Destroy(transform.parent.gameObject);
            Debug.Log("CORRECT");
        }
        else
        {
            //remove from score
            mainGame.scoreNum -= 15;
            Destroy(transform.parent.gameObject);
            Debug.Log("WRONG!");
        }
    }

    //make the clickables last for a few seconds
    private IEnumerator GoAway()
    {
        yield return new WaitForSeconds(3);
        Destroy(transform.parent.gameObject);
    }
}