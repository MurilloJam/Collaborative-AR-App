using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class WhackAMole : MonoBehaviour
{
    /// <summary>
    /// This class will work that it will get the access to the children
    /// to get their postions
    /// the answers will then continuosly be randomized in 2.5 intervals?
    /// only 1 will be correct
    /// The timer per question should be 10 or 15 seconds? depends on the intervals
    /// </summary>
    // Start is called before the first frame update
    private Transform[] answer_postions;

    public float gameTime;
    private float timeRemaining;

    public GameObject[] moles;
    [SerializeField] private bool gameRunning;

    public Dictionary<string, string> questions_answers;

    public Slider timeSlide;
    public Text question;
    public Text scoreText;
    public int scoreNum;
    public int question_index;

    private void Start()
    {
        answer_postions = GetComponentsInChildren<Transform>();
        questions_answers = new Dictionary<string, string>()
        {
            {"What layer is 1.400 miles thick?", "Outer Core" },
            {"What layer is 9,000° F?" , "Outer Core"},
            {"What layer is 9,800° F?" ,"Inner Core"},
            {"Which layer is sandwhiched between the crust and outer core?", "Mantle"},
            {"Which layer is the thickest?","Mantle"},
            {"What layer goes about 19 miles deep on average?","Crust"},
            {"What layer has the consistency of caramel?","Mantle"}
        };
        timeRemaining = gameTime;
        timeSlide.maxValue = gameTime;
        gameRunning = true;
        SliderUpdate();
        StartCoroutine(Spawn());
        //Have one of the questions as the text question
        question_index = Random.Range(0, questions_answers.Count);
        question.text = questions_answers.ElementAt(question_index).Key;

        //keeping track of the score
        scoreNum = 0;
        scoreText.text = "Score: " + scoreNum;
    }

    // Update is called once per frame
    private void Update()
    {
        timeRemaining -= Time.deltaTime;

        if (timeRemaining <= 0)
        {
            StopAllCoroutines();
            gameRunning = false;
        }

        SliderUpdate();
        scoreText.text = "Score: " + scoreNum;
    }

    private void SliderUpdate()
    {
        timeSlide.value = timeRemaining;
    }

    private IEnumerator Spawn()
    {
        while (gameRunning)
        {
            yield return new WaitForSeconds(Random.Range(0.5f, 2.5f));
            int index = Random.Range(1, answer_postions.Length);
            int mole_index = Random.Range(0, moles.Length);
            if (!CheckSpot(answer_postions[index]))
            {
                GameObject correct = Instantiate(moles[mole_index], answer_postions[index].position, Quaternion.identity);
                correct.GetComponentInChildren<Clickable>().spawnLoc = answer_postions[index];
            }

            //if (correct.CompareTag("Correct"))
            //{
            //    Debug.Log("This is the correct answer");
            //}
            //else
            //{
            //    Debug.Log("Wrong");
            //}
        }
    }

    private bool CheckSpot(Transform location)
    {
        if (Physics.CheckSphere(location.position, .005f))
        {
            return true;
        }
        return false;
    }
}