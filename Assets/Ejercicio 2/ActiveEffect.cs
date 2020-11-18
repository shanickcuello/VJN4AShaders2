using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActiveEffect : MonoBehaviour
{
    public Material cloak;
    public float speedMove;
    public float speedTransition;

    private Animator _anim;

    public float waitTimeToFade = 2f;
    private float _wait;

    private bool _effectActivated;
    private bool _activeEffect;
    private bool _activeFade;
    private float _time;

    private bool _forward;
    private bool _back;

    private void Start()
    {
        _anim = GetComponentInParent<Animator>();
        cloak.SetFloat("_ActiveInvisibility", 0f);
        cloak.SetFloat("_Opacity", 1f);
        _wait = waitTimeToFade;
    }

    private void Update()
    {
        Movement();

        if(Input.GetKeyUp(KeyCode.R))
        {
            cloak.SetFloat("_ActiveInvisibility", 0f);
            cloak.SetFloat("_Opacity", 1f);
            _effectActivated = false;
        }

        if(!_effectActivated && Input.GetKeyUp(KeyCode.Space))
        {
            _activeEffect = true;
            
                
        }

        if(_activeEffect)
        {
            _time += speedTransition * Time.deltaTime;

            cloak.SetFloat("_ActiveInvisibility", Mathf.Lerp(0f, 1f, _time));

            if(_time >= 1f)
            {
                _time = 1f;
                _activeFade = true;
                _effectActivated = true;
                _activeEffect = false;
            }
        }

        if(_activeFade)
        {
            _time -= speedTransition * Time.deltaTime;
            cloak.SetFloat("_Opacity", Mathf.Lerp(0f, 1f, _time));

            if (_time <= 0f)
            {
                _time = 0f;
                _activeFade = false;
            }
        }
    }

    private void Movement()
    {
        _anim.SetBool("Move", false);

        if (Input.GetKey(KeyCode.W))
        {
            if (!_forward)
                transform.parent.Rotate(new Vector3(0, 180, 0));

            _forward = true;
            _back = false;

            transform.parent.position += transform.parent.forward * speedMove * Time.deltaTime;
            _anim.SetBool("Move", true);
            cloak.SetFloat("_Opacity", 1f);
        }
        else if (Input.GetKey(KeyCode.S))
        {
            if (!_back)
                transform.parent.Rotate(new Vector3(0, 180, 0));

            _forward = false;
            _back = true;
            transform.parent.position += transform.parent.forward * speedMove * Time.deltaTime;
            _anim.SetBool("Move", true);
            cloak.SetFloat("_Opacity", 1f);
        }
        else if(cloak.GetFloat("_Opacity") == 1f && _effectActivated)
        {
            _wait -= Time.deltaTime;

            if(_wait <= 0f)
            {
                _time = 1f;
                _activeFade = true;
                _wait = waitTimeToFade;
            }
        }
    }
}
