using UnityEngine;
using System.Collections;

// Força o shader ser executado no modo de ediçao (nao e valido para post-processing imaging de camera)
[ExecuteInEditMode]

// Adiciona o shader na lista de menus
[AddComponentMenu("Nery Shaders/Camera/ChromaticAberration")]

// Força ter uma camera
[RequireComponent (typeof(Camera))]

public class ChromaticAberration : MonoBehaviour {
	#region Variables
	private Shader curShader;
	public float DispersionAmount = 1.0f;
	public enum ColorSet { RedBlue = 0 , RedGreen = 1 };
	public ColorSet Colors;
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
		
		//Find
		curShader = Shader.Find("Nery Shaders/Camera/ChromaticAberration");
		
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if(curShader != null)
		{
			material.SetFloat("_Amount", DispersionAmount);
			Graphics.Blit(sourceTexture, destTexture, material);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);	
		}
		
		
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(ColorSet.RedBlue == Colors)
		{
			Shader.EnableKeyword("REDBLUE");
			Shader.DisableKeyword("REDGREEN");
		}
		else if(ColorSet.RedGreen == Colors)
		{
			Shader.EnableKeyword("REDGREEN");
			Shader.DisableKeyword("REDBLUE");
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