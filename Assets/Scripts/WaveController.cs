using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveController : MonoBehaviour {

    Renderer rend;

    [SerializeField] float speed = 0f;

    private void Awake()
    {
        rend = GetComponent<Renderer>();
    }

    // Change the property of the shader per code
    private void Update()
    {
        rend.material.SetFloat("_Speed", speed);
    }
}
