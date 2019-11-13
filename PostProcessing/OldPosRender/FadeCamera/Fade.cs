using UnityEngine;
using System.Collections;
/** @brief sfade como efeito de camera */
[ExecuteInEditMode]
public class Fade : MonoBehaviour {

	
	public Shader shader;
	public float fade = 0;
	public bool iniciarFase;
	public float vel = 1;
	public static bool iniciar;
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
	
	void Awake(){
		if(!Application.isPlaying) return;
		if(iniciar){
			iniciar = false;
			iniciarFase = true;	
		}
		if(iniciarFase){
			fade=1;
		}
	}
	
	void Start () {
		if(!SystemInfo.supportsImageEffects){
			enabled = false;
			return;
		}
		
	}
	
	void Update(){
		if(!Application.isPlaying) return;
		if(iniciarFase){
			fade = Mathf.MoveTowards(fade,0,vel*Time.deltaTime);
			if(fade == 0){
				iniciarFase = false;
				enabled = false;
			}
		}else{
			enabled = false;
		}
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture){
		if(shader != null)
		{
			fade = Mathf.Clamp01(fade);
			material.SetFloat("_Fade",fade);
			//material.SetFloat("_Bottom", fade);
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
