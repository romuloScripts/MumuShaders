using UnityEngine;
using System.Collections;

public class Poeira : MonoBehaviour {

	public Shader shader;
	public float vel;
	public float OffSet;
	public Texture textura;
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
	}
	
	void Update(){
		OffSet+=vel*Time.deltaTime;
		OffSet = OffSet%100000;
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture){
		if(shader != null)
		{
			material.SetFloat("_OffSet",OffSet);
			material.SetTexture("_Textura",textura);
			
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
