using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class SetarCurvatura : MonoBehaviour {

	[Range(0,0.035f)]
	public float valor = 0.035f;
	public string nome= "_Curvature";
	
	[ContextMenu("SetarCurvatura")]
	void Awake(){
		Atualizar();
	}

//	void Update(){
//		Atualizar();
//	}

	void OnDestroy(){
		valor = 0;
		Atualizar();
	}

	public void Atualizar(){
		Shader.SetGlobalFloat(nome,valor);
	}
}
