using UnityEngine;
using System.Collections;

public class item : MonoBehaviour {

	public int distanciaAtivar;
	public float delay;
	//public Color corComum;
	//public Color corAtiva;
	public int ptsVida;
	private float tempo;
	
	void Start () {
	
	}
	
	void Update () {
	
		if(Vector3.Distance(Personagem.GetPosition(),transform.position) < distanciaAtivar){
			tempo+=Time.deltaTime;
			GetComponent<Renderer>().material.SetFloat("_EscalaCinzaBase",0.5f);
			if(tempo> delay){
				Personagem.Vida+=ptsVida;
				tempo=0;
			}
		}else{
			tempo =delay;
			GetComponent<Renderer>().material.SetFloat("_EscalaCinzaBase",1f);
		}
	}
}
