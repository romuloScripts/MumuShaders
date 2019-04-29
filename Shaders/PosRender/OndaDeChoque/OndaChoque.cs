using UnityEngine;
using System.Collections;
/** @brief efeito de camera da onda de choque */
[ExecuteInEditMode]
public class OndaChoque : MonoBehaviour {

	public float fade = 1;
	public Shader shader;
	public float speed =1, amplitude=259.6f;
	public int blur = 8;
	
	public float x =0.5f,y=0.5f;
	public Transform target;
	private Material mat;
	private Vector3 pos = Vector3.zero;
	
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
		if(!SystemInfo.supportsImageEffects){
			enabled = false;
			return;
		}
		
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture){
		if(shader != null){
			material.SetFloat("_Speed",speed);
			material.SetFloat("_Amplitude",amplitude);
			fade = Mathf.Clamp(fade, 0, 1);
			material.SetFloat("_transicao",fade);
			if(target && Application.isPlaying){
				pos = Camera.main.WorldToScreenPoint(target.position);
				x = 1f/(float)Screen.width * pos.x;
				y = 1f/(float)Screen.height * pos.y;
				material.SetFloat("_x",x);
				material.SetFloat("_y",y);
			}else{
				material.SetFloat("_x",x);
				material.SetFloat("_y",y);
			}
			blur = Mathf.Clamp(blur, 1, 30);
			RenderTexture blurbuffer = RenderTexture.GetTemporary(sourceTexture.width/blur, sourceTexture.height/blur, 0);
			Graphics.Blit(sourceTexture, blurbuffer);
			material.SetTexture("_Tx1", blurbuffer);
			
			Graphics.Blit(sourceTexture, destTexture, material);
			RenderTexture.ReleaseTemporary(blurbuffer);
		}else{
			Graphics.Blit(sourceTexture, destTexture);	
		}	
	}
	
	void OnDisable (){
		if(mat){
			DestroyImmediate(mat);	
		}	
	}
}
