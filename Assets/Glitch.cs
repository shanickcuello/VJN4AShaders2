using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[ExecuteInEditMode]
public class Glitch : MonoBehaviour
{

    public float distR;
    public float distB;
    public float timeR;
    public float timeB;
    public float timeG;
    public float currTime;
    public Material myMaterial;
    public PostProcessVolume myVolume;

    // Start is called before the first frame update
    void Start()
    {
        myMaterial = GetComponent<MeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        currTime += Time.deltaTime;


        myMaterial.SetFloat("_TimeBlue", timeB);
        myMaterial.SetFloat("_TimeRed", timeR);
        myMaterial.SetFloat("_TimeGreen", timeG);

        if (currTime >= 5f && timeR != 0 && timeB != 0 && timeG != 0)
        {
            timeR = 0;
            timeB = 0;
            timeG = 0;
            currTime = 0;
        }

        if (currTime >= 5f && timeR == 0)
        {
            timeR = 10;
            timeB = 10;
            timeG = 10;
            currTime = 0;

        }
        
        
    }
}
