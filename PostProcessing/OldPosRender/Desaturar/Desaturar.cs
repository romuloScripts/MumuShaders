using UnityEngine;
using System.Collections;
/** @brief descoloriza cenario pela distancia */
[ExecuteInEditMode]
public class Desaturar : MonoBehaviour {

	public Shader shader;
	public Color cor = Color.grey;
	public float multiplicador=1;
	public float inicio,fim;
	public float forca=1;
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
			forca = Mathf.Clamp01(forca);
			material.SetColor("_Cor", cor);
			material.SetFloat("_Multiplicador",multiplicador);
			material.SetFloat("_Inicio",inicio);
			material.SetFloat("_Fim",fim);
			material.SetFloat("_Forca",forca);
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
