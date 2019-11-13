using UnityEngine;
using System.Collections;
/** @brief efeito de camera de distorcao do calor no deserto */
[ExecuteInEditMode]
public class Deserto : MonoBehaviour {

	public Shader shader;
	public float multiplicador=1;
	public float inicio,fim;
	public float speed =1, lenght =1,amplitude=1,offsetY=0;     
	public float fimY=1;
	private Material mat;
	private Camera cam;
	
	Material material{
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
		cam = GetComponent<Camera>();
		cam.depthTextureMode = DepthTextureMode.Depth;
		if(!SystemInfo.supportsImageEffects){
			enabled = false;
			return;
		}
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture){
		if(shader != null){
			offsetY = Mathf.Clamp01(offsetY);
			fimY = Mathf.Clamp01(fimY);
			material.SetFloat("_Multiplicador",multiplicador);
			material.SetFloat("_Inicio",inicio);
			material.SetFloat("_Fim",fim);
//			material.SetFloat("_Forca",forca);
			material.SetFloat("_Speed",speed);
			material.SetFloat("_Length",lenght);
			material.SetFloat("_Amplitude",amplitude);
			material.SetFloat("_OffsetY",offsetY);
			material.SetFloat("_FimY",fimY);
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
