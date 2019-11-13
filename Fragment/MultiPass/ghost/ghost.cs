using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class ghost : MonoBehaviour {

    public float maxdelay = 0.1f,dist=0.5f;
    public Renderer rend;
    public Vector4[] vetores;
    public Vector3[] pos;

   private float timedelay;
   private int id;
   private Vector3 v;
	
	void Update () {
      //  if(rend)
       
       if (Time.time - timedelay > maxdelay) {
           timedelay = Time.time;
           pos[2] = pos[1];
           pos[1] = pos[0];
           pos[0] = transform.position;
       }
       else {
           v = pos[2] - transform.position;
           vetores[2] = new Vector4(v.x, -v.y, 0, 0);
           v = pos[1] - transform.position;
           vetores[1] = new Vector4(v.x, -v.y, 0, 0);
           v = pos[0] - transform.position;
           vetores[0] = new Vector4(v.x, -v.y, 0, 0);
           rend.sharedMaterial.SetVectorArray("_Array", vetores);
       }
        
	}
}
