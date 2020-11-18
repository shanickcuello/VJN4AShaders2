using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ChangeScene : MonoBehaviour
{
    private int currentScene = 0;

    private void Awake()
    {
        DontDestroyOnLoad(this);
    }

    private void Update()
    {
        if(Input.GetKeyUp(KeyCode.RightArrow))
        {
            if(currentScene + 1 < SceneManager.sceneCountInBuildSettings)
            {
                SceneManager.LoadScene(currentScene + 1);
                currentScene += 1;
            }
                
        }

        if (Input.GetKeyUp(KeyCode.LeftArrow))
        {
            if (currentScene - 1 >= 0)
            {
                SceneManager.LoadScene(currentScene - 1);
                currentScene -= 1;
            }

        }
    }
}
