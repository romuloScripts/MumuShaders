using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class NightVision : MonoBehaviour {

	public Shader meuShader;
	public float lerp = 1.0f;
	public float mask = 0.5f;
	public Color cor;
	public float multiplicador;
	private Material meuMaterial;
	public Texture textura2;
	public Texture noise;
	public Vector2 noiseSpeed;
	private float randomValue;
	
	Material material
	{
		get{
			if(meuMaterial == null) {
				meuMaterial = new Material(meuShader);
			}
			return meuMaterial;
		}
	}
	
	// Use this for initialization
	void Start () {
		// Se a placa nao suportar efeitos de pos render
		if(!SystemInfo.supportsImageEffects) {
			enabled = false; // Desabilita o Behavior
			return;
		}
		// Se a placa de video nao suportar o shader codificado
		if(!meuShader && !meuShader.isSupported) {
			enabled = false; // Desabilita o Behavior
		}
		
		material.SetTexture("_OtherTex", textura2);
		material.SetTexture("_Noise", noise);
	}
	
	// Update is called once per frame
	void Update () {
		lerp = Mathf.Clamp(lerp, 0.0f, 1.0f); // mantem ratio entre 0 e 1
		mask = Mathf.Clamp(mask, 0.0f, 1.0f); // mantem ratio entre 0 e 1
		randomValue = Random.Range(-1.0f, 1.0f);
	}
	
	void OnRenderImage(RenderTexture texturaInicial, RenderTexture texturaFinal) {
		if(meuShader != null) {
			material.SetFloat("_RateLerp", lerp);
			material.SetFloat("_RateMask", mask);
			material.SetColor("_Cor", cor);
			material.SetFloat("_Multiplicador", multiplicador);
			if(noise) {
				material.SetTexture("_Noite", noise);
				material.SetFloat("_noiseSpeedY", noiseSpeed.y);
				material.SetFloat("_noiseSpeedX", noiseSpeed.x);
				material.SetFloat("_RandomValue", randomValue);
			}
			
			//Blit(Texture source, RenderTexture dest, Material mat, int pass = -1)
			//Copia uma textura na outra usando um material e rodando o passo X do shader (quando existe)
			Graphics.Blit(texturaInicial, texturaFinal, material);
		}
		else
			Graphics.Blit(texturaInicial, texturaFinal);
	}
	
	void OnDisable() {
		if(meuMaterial)
			DestroyImmediate(meuMaterial);
	}
}
