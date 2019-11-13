using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class RenderImage : MonoBehaviour {

	public Shader meuShader;
	private Material meuMaterial;
	public float blur;
	private Texture[] texturas;
	private int inicio;
	private int final;
	private bool primeiro;
	private int contTex;

	Material material
	{
		get{
			if(meuMaterial == null) {
				meuMaterial = new Material(meuShader);
			}
			return meuMaterial;
		}
	}

	void Awake() {
		inicio = 0;
		final = 3;
		primeiro = true;
		texturas = new Texture[4];
		Debug.Log ("Awake");
	}

	// Use this for initialization
	void Start () {
		if(!SystemInfo.supportsImageEffects) {
			enabled = false; // Desabilita o Behavior
			return;
		}
		if(!meuShader && !meuShader.isSupported) {
			enabled = false; // Desabilita o Behavior
		}

		Time.timeScale = 0.2f;

		Debug.Log ("Start");
	}
	
	// Update is called once per frame
	void Update () {
		blur = Mathf.Clamp(blur, 0.0f, 1.0f); // mantem blur entre 0 e 1
	}

	void OnRenderImage(RenderTexture texturaInicial, RenderTexture texturaFinal) {
		if(meuShader != null) {

			if(primeiro) {
				Texture P = texturaInicial as Texture;
				texturas[0] = P;
				primeiro = false;
				contTex = 1;
			}
			else {
				if(Time.frameCount % 10 == 0) {
					Texture O = texturaInicial as Texture;
					inicio = (inicio+1)%4;
					final = (final+1)%4;
					texturas[final] = O;
					contTex++;
				}
			}

			if(contTex > 4) {
				material.SetTexture("_Tx1", texturas[inicio]);
				material.SetTexture("_Tx2", texturas[(inicio+1)%4]);
				material.SetTexture("_Tx3", texturas[(inicio+2)%4]);
				material.SetFloat("_Blur", blur);				
				Graphics.Blit(texturaInicial, texturaFinal, material);
			}
			else
				Graphics.Blit(texturaInicial, texturaFinal);
		}
		else
			Graphics.Blit(texturaInicial, texturaFinal);
	}

	void OnDisable() {
		if(meuMaterial)
			DestroyImmediate(meuMaterial);
	}
}
