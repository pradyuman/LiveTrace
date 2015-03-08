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

		// Print out found cameras to log
		for (var i = 0; i < devices.Length; i++) {
		Debug.Log (devices [i].name);
		}

		// Search for camera that has "face"

		for (var i = 0; i < devices.Length; i++) {
			if (devices [i].name.IndexOf ("USB") >= 0) {
				myCam.deviceName = devices [i].name;
				Debug.Log (devices [i].name);
				myCam.Play();
				break;
			}
		}

		myCam.Play ();


	
	}
	
	// Update is called once per frame
	void Update () {

		myRenderer = GetComponent<Renderer> ();

		myRenderer.material.SetTexture(0, myCam);


	}
}
