using UnityEngine;
using System.Collections;
/** @brief ativa o efeito CutSceneFaixas */
public class CutSceneFaixasTrigger : MonoBehaviour {

	public CutSceneFaixas faixas;
	public Camera camHud;
	//public int camHudDepth=-2;
	public LayerMask mascara;
	public float alvoFade;
	public float vel=1;
	private bool ativo;
	
	void OnTriggerEnter(Collider col) {
		Ativar();
	}
	
	public void Ativar(){
		if(ativo) return;
		enabled = ativo = faixas.enabled = true;
		if(camHud){
			//camHud.enabled = false;
			camHud.cullingMask = mascara;
			//camHud.depth = camHudDepth;
		}
	}
	
	void Update () {
		faixas.fade = Mathf.MoveTowards(faixas.fade,alvoFade,vel*Time.deltaTime);
		if(faixas.fade == alvoFade){
			enabled = false;
		}
	}
}
