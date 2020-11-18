using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;
using UnityEditor;


public class CameraBehaviour : MonoBehaviour
{

    public float sliderValue;
    public float testfloat;
    public Camera camera1;
    public Camera camera2;
    public RenderTexture cameraTex;
    public Slider mySlider;
    public Material myMaterial;
    //public Postprocessin myProfile;
    public CameraPostPPSSettings mySettings;
    public PostProcessProfile myProfile;
    public float myFloat;



    // Start is called before the first frame update
    void Start()
    {
        mySettings = myProfile.GetSetting<CameraPostPPSSettings>();
        mySettings.enabled.value = true;
        mySettings._Amount.value = testfloat;
        sliderValue = mySlider.value;

    }

    // Update is called once per frame
    void Update()
    {
        ManageCameras();
        
    }

    void ManageCameras()
    {
        sliderValue = mySlider.value;
        mySettings._Amount.value = sliderValue;

       
           if (sliderValue == 0)
           {
               camera2.targetTexture = cameraTex;
               camera2.gameObject.SetActive(false);
           }

           if (sliderValue > 0)
           {
               camera2.gameObject.SetActive(true);              
           }

           if (sliderValue == 1)

           {              
               camera1.gameObject.SetActive(false);
               camera2.targetTexture = null;
           }

           if (sliderValue < 1)
           {
               camera2.targetTexture = cameraTex;       
               camera1.gameObject.SetActive(true);
           }
           
    }
}
