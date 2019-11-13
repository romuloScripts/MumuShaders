using UnityEngine;
using System.Collections;

public class Movimentar : MonoBehaviour {

	public float velDeslocar;
	private Vector3 velocidade;
	
	void Update () {
		velocidade.y = GetComponent<Rigidbody>().velocity.y;
		velocidade.x = Input.GetAxis("Horizontal")*velDeslocar;
		velocidade.z = Input.GetAxis("Vertical")*velDeslocar;
		GetComponent<Rigidbody>().velocity = velocidade;
	}
}
