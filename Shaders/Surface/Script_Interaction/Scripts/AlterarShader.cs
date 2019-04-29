using UnityEngine;
using System.Collections;

public class AlterarShader : MonoBehaviour {

	private Color cor;
	
	void Update () {
		if(Input.GetKeyDown(KeyCode.Space)){
			cor = GetComponent<Renderer>().material.GetColor("_Cor");
			cor.b += 0.1f;
			GetComponent<Renderer>().material.SetColor("_Cor",cor);
		}
	}
}
