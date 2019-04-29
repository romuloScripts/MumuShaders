using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class AbrirCamera : MonoBehaviour {

	public Shader shader;
	[Range(0,1f)]
	public float fade = 0;
	public float Fade{
		get{ return fade;}
		set{ fade = value;}
	}
	public Vector2 center= new Vector2(0.5f,0.5f);
	public Vector2 Center{
		get{ return center;}
		set{ center = value;}
	}
	//public float vel=1,valorParar=1.5f;
	private Material mat;
	
	Material material
	{
		get
		{
			if(mat == null)
			{
				mat = new Material(shader);
				mat.hideFlags = HideFlags.HideAndDontSave;	
			}
			return mat;
		}
	}
	
//	void Start () {
//		if(!SystemInfo.supportsImageEffects){
//			enabled = false;
//			return;
//		}
//		if(Application.isPlaying){
//			fade=0;
//		}
//	}
	
//	void Update(){
//		if(!Application.isPlaying)return;
//		fade+=vel*Time.deltaTime;
//		if(fade > valorParar)
//			enabled = false;
//	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture){
		if(shader != null)
		{
			material.SetFloat("_Fade",fade*1.1f);
			material.SetFloat("_CentroX", center.x);
			material.SetFloat("_CentroY", center.y);
			Graphics.Blit(sourceTexture, destTexture, material);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);	
		}
		
		
	}
	
	void OnDisable (){
		if(mat){
			DestroyImmediate(mat);	
		}	
	}	
}
