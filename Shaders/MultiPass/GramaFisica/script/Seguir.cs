using UnityEngine;
using System.Collections;

public class Seguir : MonoBehaviour {

    public GameObject Sphere;
    public float Velocidade;
    public Vector3 posicao;

 

	void Update () {
         this.transform.position = Vector3.MoveTowards(this.transform.position, Sphere.transform.position, Velocidade);
         posicao = this.transform.position - Sphere.transform.position;

       
            Sphere.GetComponent<Renderer>().material.SetVector("_Gravidade", new Vector4(posicao.x, posicao.y, posicao.z, 1));
        
	}
}
