using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PosDivisao : MonoBehaviour {

	public string nome = "_posDiv";
	public Transform p1,p2;

	private Vector3 delay = Vector3.zero;

	void Update () {
		if(p1 && p2) delay = p1.position - p2.position;
		Shader.SetGlobalVector(nome, transform.position+delay);
	}

}
