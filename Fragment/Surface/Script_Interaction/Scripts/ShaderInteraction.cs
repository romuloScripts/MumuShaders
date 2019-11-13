using UnityEngine;
using System.Collections;

public class ShaderInteraction : MonoBehaviour {

	public Shader MyShader; // Armazena o shader atual
	public float MinDistance; // Distancia minima para trocar a textura

	private Texture StandardTex; // Textura padrao
	private bool Changed; // Flag de troca de textura

	// Use this for initialization
	void Start () 
	{
		// Armazena o shader, textura padrao e inicializa a flag
		MyShader = Shader.Find("Custom/Interaction");
		StandardTex = this.GetComponent<Renderer>().material.GetTexture(0);
		Changed = false;
	}
	
	// Update is called once per frame
	void Update () 
	{
		// Gera valores para as propriedades
		float multiValue = Mathf.PingPong(Time.time, 1.0f); // 0.0 a 1.0
		float scrollX = Mathf.Sin(Time.time)*10.0f; // -10.0 a 10.0
		float scrollY = Mathf.Cos(Time.time)*10.0f; // -10.0 a 10.0
		Color colorTint = new Color(0.0f, // r: 0.0 a 1.0
		                            0.0f, // g: 0.0 a 1.0
		                            Mathf.PingPong(Time.time, 1.0f), // b: 0.0 a 1.0
		                            0.0f); // a: 0.0 a 1.0

		// Busca o objeto mais proximo num raio de MinDistance
		GameObject[] SceneObjects = GameObject.FindGameObjectsWithTag ("TexObj");
		GameObject NearObject = null;

		for(int i=0; i<SceneObjects.Length; i++)	
		{
			if( (SceneObjects[i].transform.position - this.transform.position ).sqrMagnitude < MinDistance)
			{
				if(NearObject)
				{
					if( (SceneObjects[i].transform.position - this.transform.position ).sqrMagnitude < 
					    (NearObject.transform.position - this.transform.position ).sqrMagnitude ) 
					{
						NearObject = SceneObjects[i];
					}
				}
				else
				{
					NearObject = SceneObjects[i];
				}
			}
		}

		// Verifica se o shader esta aplicado
		if( GetComponent<Renderer>().material.shader == MyShader )
		{
			// Altera as propriedades do shader
			GetComponent<Renderer>().material.SetFloat( "_Multi", multiValue );
			GetComponent<Renderer>().material.SetFloat( "_ScrollXSpeed", scrollX );
			GetComponent<Renderer>().material.SetFloat( "_ScrollYSpeed", scrollY );
			GetComponent<Renderer>().material.SetColor( "_MainTint", colorTint);

			// Se tiver um objeto a menos de MinDistance, troca a textura com ele
			if(NearObject)
			{
				GetComponent<Renderer>().material.SetTexture( "_MainTex", NearObject.GetComponent<Renderer>().material.GetTexture(0) );
				Changed = true;
			}
			else
			{
				if(Changed)
				{
					GetComponent<Renderer>().material.SetTexture( "_MainTex", StandardTex );
					Changed = false;
				}
			}
		}
			
	}
}
