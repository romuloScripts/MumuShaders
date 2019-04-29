using UnityEngine;
using System.Collections;

// Força o shader ser executado no modo de ediçao (nao e valido para post-processing imaging de camera)
[ExecuteInEditMode]

// Adiciona o shader na lista de menus
[AddComponentMenu("Nery Shaders/Camera/Letterbox")]

// Força ter uma camera
[RequireComponent (typeof(Camera))]

public class LetterBox : MonoBehaviour {

	#region Variables
	public Shader curShader;
	public float amount = 0.15f;
	public Color myColor;

	private Material curMaterial;
	#endregion
	
	#region Properties
	Material material
	{
		get
		{
			if(curMaterial == null)
			{
				curMaterial = new Material(curShader);
				curMaterial.hideFlags = HideFlags.HideAndDontSave;	
			}
			return curMaterial;
		}
	}
	#endregion
	// Use this for initialization
	void Start () 
	{
		if(!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if(curShader != null)
		{
                        amount = Mathf.Clamp01(amount);
			material.SetFloat("_Top", 1 - amount);
			material.SetFloat("_Bottom", amount);
			material.SetColor("_Color", myColor);
			Graphics.Blit(sourceTexture, destTexture, material);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);	
		}
		
		
	}
	
	void OnDisable ()
	{
		if(curMaterial)
		{
			DestroyImmediate(curMaterial);	
		}
		
	}
	
	
}