using UnityEngine;
using System.Collections;
//[ExecuteInEditMode]
public class ReplaceShaderScript : MonoBehaviour {

	public Shader shader;
	
	private Camera cam;
	private Camera camShader;
	
//	void Awake(){
//		if(!cam)
//			cam = GetComponent<Camera>();
//		cam.SetReplacementShader(shader, "MyTag");
//		//cam.ResetReplacementShader();
//	}
	
	void OnPostRender()
	{
		if(!cam)
			cam = GetComponent<Camera>();
		if (!enabled || !gameObject.activeSelf || !shader || !cam){
			return;
		}
		if (!camShader) {
			Debug.Log("passei2");
			GameObject obj = new GameObject("ShaderCamera",typeof(Camera));
			camShader = obj.GetComponent<Camera>();
			camShader.enabled = false;
			camShader.transform.parent = transform;
			//camShader.hideFlags = HideFlags.HideAndDontSave;
		}
		
		camShader.CopyFrom(cam);
		camShader.backgroundColor = new Color(0,0,0,0);
		camShader.clearFlags = CameraClearFlags.SolidColor;
		camShader.RenderWithShader (shader, "MyTag");
	}
	
	void OnDisable() {
		if(!camShader) return;
		if(!Application.isPlaying)
		DestroyImmediate(camShader.gameObject);
		else
		Destroy(camShader.gameObject);
	}
}
