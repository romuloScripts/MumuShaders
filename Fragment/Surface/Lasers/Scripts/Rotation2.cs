using UnityEngine;
using System.Collections;

public class Rotation2 : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		this.transform.Rotate (new Vector3 (0,2,0));
	}
}
