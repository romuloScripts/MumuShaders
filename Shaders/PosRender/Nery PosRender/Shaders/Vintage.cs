using UnityEngine;
using System.Collections;


// Força o shader ser executado no modo de ediçao (nao e valido para post-processing imaging de camera)
[ExecuteInEditMode]

// Adiciona o shader na lista de menus
[AddComponentMenu("Nery Shaders/Camera/ChromaticAberration")]

// Força ter uma camera
[RequireComponent (typeof(Camera))]

public class Vintage : MonoBehaviour {
	#region Variables
	private Shader curShader;
	public Color Yellow = Color.yellow;
	public Color Cyan = Color.cyan;
	public Color Magenta = Color.magenta;
	public float YellowLevel = 0.01f;
	public float CyanLevel = 0.03f;
	public float MagentaLevel = 0.04f;
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
		
		curShader = Shader.Find("Nery Shaders/Camera/Vintage");
		
	}
	
	void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if(curShader != null)
		{
			material.SetFloat("_YellowLevel", YellowLevel);
			material.SetFloat("_CyanLevel", CyanLevel);
			material.SetFloat("_MagentaLevel", MagentaLevel);
			material.SetColor("_Yellow", Yellow);
			material.SetColor("_Cyan", Cyan);
			material.SetColor("_Magenta", Magenta);
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
	}
	
	void OnDisable ()
	{
		if(curMaterial)
		{
			DestroyImmediate(curMaterial);	
		}
		
	}
	
	
}