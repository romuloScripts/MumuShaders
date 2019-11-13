using UnityEngine;
using System.Collections;

public class Personagem : MonoBehaviour {

	public TextMesh textoVida;
	public int vida = 100;
	public static int Vida{
		get{ if(!singleton) return 100;  
			 return singleton.vida;
		}set{if(!singleton) return; 
			singleton.vida = Mathf.Clamp(value,0,100);
			singleton.VerificarStatus();
			singleton.textoVida.text = singleton.vida.ToString();
			}				
	}
	
	private const int vidaBaixa=30;
	public static Personagem singleton;
	
	void Awake(){
		singleton = this;
	}
	
	void VerificarStatus(){
		if(vida <= vidaBaixa){
			GetComponent<Renderer>().material.SetFloat("_Valor",1);
		}else{
			GetComponent<Renderer>().material.SetFloat("_Valor",0);
		}
	}
	
	public static Vector3 GetPosition(){
		if(!singleton) return Vector3.zero;
		return singleton.transform.position;
	}
	
	
	
}
