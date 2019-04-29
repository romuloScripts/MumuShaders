using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class DissolverCamera : MonoBehaviour {

	public Shader shader;
	public float fade = 0;
	public Texture texturaVelha;
	public Texture mascara;
	public float vel=1;
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
	
	void Start () {
		if(!SystemInfo.supportsImageEffects){
			enabled = false;
			return;
		}
		if(Application.isPlaying){
			fade=0;
		}
	}
	
	void Update(){
		if(!Application.isPlaying)return;
		fade+=vel*Time.deltaTime;
		if(fade >= 1)
			enabled = false;
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture){
		if(shader != null)
		{
			fade = Mathf.Clamp01(fade);
			material.SetFloat("_Fade",fade);
			material.SetTexture("_TexturaVelha",texturaVelha);
			material.SetTexture("_Mascara",mascara);
			
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
