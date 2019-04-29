using UnityEngine;
using System.Collections;

public class SpriteControl : MonoBehaviour {

	public float velMin;
	public float velMax;
	public float aceleracao;
	public int[] numSprite;
	public int numLinhas=3;
	private int indiceLinha;
	private int indiceColuna;
	private float vel;
	
	
	void Start () {
		indiceLinha = numLinhas-1; 
	}

	void Update () {
		Debug.Log(vel);
		if(Input.GetKey(KeyCode.LeftArrow)){
			vel = Mathf.Lerp(vel,velMax,aceleracao*Time.deltaTime);
			transform.position += Vector3.right*vel*Time.deltaTime;
			GetComponent<Renderer>().material.SetFloat("_Lado",-1);
			
		}else if(Input.GetKey(KeyCode.RightArrow)){
			vel = Mathf.Lerp(vel,velMax,aceleracao*Time.deltaTime);
			transform.position += Vector3.left*vel*Time.deltaTime;
			GetComponent<Renderer>().material.SetFloat("_Lado",1);
		}else{
			vel = Mathf.Lerp(vel,velMin,aceleracao*2*Time.deltaTime);
		}
		if(vel < (velMax/3f)){
			GetComponent<Renderer>().material.SetFloat("_Linha",indiceLinha);
			indiceColuna = (int)Mathf.Lerp(0,numSprite[indiceLinha]-1,
			                               Mathf.InverseLerp(velMin,(velMax/3f),vel));
			GetComponent<Renderer>().material.SetFloat("_Coluna",indiceColuna);
		}else if(vel < ((velMax/3f)*2)) {
			GetComponent<Renderer>().material.SetFloat("_Linha",indiceLinha-1);
			indiceColuna = (int)Mathf.Lerp(0,numSprite[indiceLinha-1]-1,
			                               Mathf.InverseLerp((velMax/3f),((velMax/3f)*2),vel));
			GetComponent<Renderer>().material.SetFloat("_Coluna",indiceColuna);
		}else if(vel < velMax) {
			GetComponent<Renderer>().material.SetFloat("_Linha",indiceLinha-2);
			indiceColuna = (int)Mathf.Lerp(0,numSprite[indiceLinha-2]-1,
			                               Mathf.InverseLerp(((velMax/3f)*2),velMax,vel));
			GetComponent<Renderer>().material.SetFloat("_Coluna",indiceColuna);
		}
	}
}
