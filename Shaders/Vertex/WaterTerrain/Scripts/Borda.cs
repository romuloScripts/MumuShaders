using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Borda : MonoBehaviour {

	public Transform terreno;
	public Transform agua;
	public Material matTerreno,matAgua;

	void Update () {
		if(!terreno || !agua || !matTerreno || !matAgua) return;
		float distancia = agua.position.y - terreno.position.y;
		float offset = Mathf.InverseLerp(0,10,distancia);
		float displace = matTerreno.GetFloat("_Displacement");
		float offsetDisplace =  Mathf.InverseLerp(3,0,displace);
		matAgua.SetFloat("_EscalaBorda",offset+offsetDisplace/1.5f);
	}
}
