using UnityEngine;
using System.Collections;

// Força o shader ser executado no modo de ediçao (nao e valido para post-processing imaging de camera)
[ExecuteInEditMode]

// Adiciona o shader na lista de menus
[AddComponentMenu("Nery Shaders/Camera/OldFilm")]

// Força ter uma camera
[RequireComponent (typeof(Camera))]

public class OldFilm : MonoBehaviour 
{
	#region parameters.
	public bool isEnable = false;
	public Shader oldFilmShader;

	public float OldFilmEffectAmount = 1.0f;

	public Color sepiaColor = Color.gray;
	public Texture2D vignetteTexture;
	public float vignetteAmount = 1.0f;

	public Texture2D scratchesTexture;
	public float scratchesYSpeed = 10.0f;
	public float scratchesXSpeed = 10.0f;

	public Texture2D dustTexture;
	public float dustXSpeed = 10.0f;
	public float dustYSpeed = 10.0f;

	private Material curMaterial;
	private float randomValue;
	#endregion

	void Start()
	{
		oldFilmShader = Shader.Find("Nery Shaders/Camera/OldFilm");
		curMaterial = new Material(oldFilmShader);
	}

	void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		if(oldFilmShader != null && isEnable)
		{
			curMaterial.SetColor("_SepiaColor", sepiaColor);
			curMaterial.SetFloat("_VignetteAmount", vignetteAmount);
			curMaterial.SetFloat("_EffectAmount", OldFilmEffectAmount);

			if(vignetteTexture)
			{
				curMaterial.SetTexture("_VignetteTex", vignetteTexture);
			}
			if(scratchesTexture)
			{
				curMaterial.SetTexture("_ScratchesTex", scratchesTexture);
				curMaterial.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
				curMaterial.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
			}
			if(dustTexture)
			{
				curMaterial.SetTexture("_DustTex", dustTexture);
				curMaterial.SetFloat("_DustYSpeed", dustYSpeed);
				curMaterial.SetFloat("_DustXSpeed", dustXSpeed);
			}

			Graphics.Blit(src, dst, curMaterial);
		}
		else
		{
			Graphics.Blit(src, dst);
		}
	}

	void Update()
	{
		vignetteAmount = Mathf.Clamp01(vignetteAmount);
		OldFilmEffectAmount = Mathf.Clamp(OldFilmEffectAmount, 0.0f, 1.5f);
		randomValue = Random.Range(-1.0f, 1.0f);
	}

	public void ToggleEnable()
	{
		if(isEnable)
			isEnable = false;
		else
			isEnable = true;
	}
}