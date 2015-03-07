using UnityEngine;
using System.Collections;

public class WebcamTexture : MonoBehaviour {

	WebCamDevice[] devices;
	WebCamTexture myCam;


	Texture curTexture;
	Renderer myRenderer;

	// Use this for initialization
	void Start () {
		// Get webcam devices
		devices = WebCamTexture.devices;
		myCam = new WebCamTexture();
		for (var i = 0; i < devices.Length; i++) {
			Debug.Log (devices [i].name);
		}
				
		myCam.deviceName = devices [0].name;
		myCam.Play();


	
	}
	
	// Update is called once per frame
	void Update () {

		myRenderer = GetComponent<Renderer> ();

		myRenderer.material.SetTexture(0, myCam);


	}
}
