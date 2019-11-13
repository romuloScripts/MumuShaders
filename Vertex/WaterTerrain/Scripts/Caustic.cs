using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Caustic : MonoBehaviour {

	public Transform agua;
	
	public Material matTerreno;
	
	void Update () {
		if(matTerreno && agua)
			matTerreno.SetFloat("_PosYAgua",agua.transform.position.y);
	}
}
