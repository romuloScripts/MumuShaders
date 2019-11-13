using UnityEngine;
using System.Collections;

public class PingPong : MonoBehaviour {

	public float speed;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
		this.transform.position = new Vector3 (Mathf.PingPong(Time.time*speed, 1.2f), 0, 0);
	}
}
