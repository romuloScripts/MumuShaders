using UnityEngine;
using System.Collections;
/** @brief efeito de camera que coloca faixas de corte na tela */
[ExecuteInEditMode]
public class CutSceneFaixas : MonoBehaviour {

	public Shader shader;
	public float fade = 0;
//	public bool ativaFade;
//	public float alvoFade;
//	public float vel=1;
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
	
//	void Update(){
//		if(ativaFade){
//			fade = Mathf.MoveTowards(fade,alvoFade,vel*Time.deltaTime);
//			if(fade == alvoFade){
//				ativaFade = false;
//			}	
//		}
//	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture){
		if(shader != null)
		{
			fade = Mathf.Clamp01(fade);
			material.SetFloat("_Cima", 1 - fade);
			material.SetFloat("_Baixo", fade);
			//material.SetColor("_Color", cor);
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
