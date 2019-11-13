using UnityEngine;
using System.Collections;

public class move : MonoBehaviour {

	public float velocity;

	// Use this for initialization
	void Start () {
	


	}
	
	// Update is called once per frame
	void Update () {
		this.transform.position = new Vector3(Mathf.PingPong(Time.time*velocity, 10)-5, this.transform.position.y, this.transform.position.z);  
	}
}
