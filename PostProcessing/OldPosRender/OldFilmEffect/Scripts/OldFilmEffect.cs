using UnityEngine;
using System.Collections;

[ExecuteInEditMode] // Para editar o efeito em tempo real
public class OldFilmEffect : MonoBehaviour {
	
	public Shader OldFilmShader;

	public float OldFilmEffectAmount = 1.0f;
	public Color sepiaColor = Color.white;

	public Texture2D vignetteTexture;
	public float vignetteAmount;

	public Texture2D scratchesTexture;
	public float scratchesYSpeed = 10.0f;
	public float scratchesXSpeed = 10.0f;

	public Texture2D dustTexture;
	public float dustYSpeed = 10.0f;
	public float dustXSpeed = 10.0f;

	private Material currentMaterial;
	private float randomValue;
	
	Material material
	{
		get{
			if(currentMaterial == null) {
				currentMaterial = new Material(OldFilmShader);
			}
			return currentMaterial;
		}
	}
	
	// Use this for initialization
	void Start () {
		if(!SystemInfo.supportsImageEffects) {
			enabled = false; // Desabilita o Behavior
			return;
		}
		if(!OldFilmShader && !OldFilmShader.isSupported) {
			enabled = false; // Desabilita o Behavior
		}
	}
	
	// Update is called once per frame
	void Update () {
		vignetteAmount = Mathf.Clamp01(vignetteAmount); // Mantem vignetteAmount entre 0 e 1
		OldFilmEffectAmount = Mathf.Clamp(OldFilmEffectAmount, 0.0f, 1.5f);
		randomValue = Random.Range(-1.0f, 1.0f);
	}
	
	void OnRenderImage(RenderTexture texturaInicial, RenderTexture texturaFinal) {
		if(OldFilmShader != null) {
			material.SetColor("_SepiaColor", sepiaColor);
			material.SetFloat("_VignetteAmount", vignetteAmount);
			material.SetFloat("_EffectAmount", OldFilmEffectAmount);

			if(vignetteTexture) {
				material.SetTexture("_VignetteTex", vignetteTexture);
			}

			if(scratchesTexture) {
				material.SetTexture("_ScratchesTex", scratchesTexture);
				material.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
				material.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
			}

			if(dustTexture) {
				material.SetTexture("_DustTex", dustTexture);
				material.SetFloat("_DustYSpeed", dustYSpeed);
				material.SetFloat("_DustXSpeed", dustXSpeed);
				material.SetFloat("_RandomValue", randomValue);
			}

			Graphics.Blit(texturaInicial, texturaFinal, material);
		}
		else
			Graphics.Blit(texturaInicial, texturaFinal);
	}
	
	void OnDisable() {
		if(currentMaterial)
			DestroyImmediate(currentMaterial);
	}
}
