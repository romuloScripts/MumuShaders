using UnityEngine;
using System.Collections;

public class BufferExemplo : MonoBehaviour {

	public Material material;
	ComputeBuffer buffer;
	
	const int count = 1024;
	const float size = 5.0f;
	
	struct Vert
	{
		public Vector3 position;
		public Vector3 color;
	}
	
	void Start (){
		buffer = new ComputeBuffer(count, sizeof(float)*6, ComputeBufferType.Default);
		//buffer = new ComputeBuffer(count, sizeof(float)*3, ComputeBufferType.Default);
		//float[] points = new float[count*3];
		//Vector3[] points = new Vector3[count];
		Vert[] points = new Vert[count];
		Random.seed = 0;
		for(int i = 0; i < count; i++)
		{
//			points[i*3+0] = Random.Range(-size,size);
//			points[i*3+1] = Random.Range(-size,size);
//			points[i*3+2] = 0.0f;
			
//			points[i] = new Vector3();
//			points[i].x = Random.Range (-size, size);
//			points[i].y = Random.Range (-size, size);
//			points[i].z = 0;

			points[i] = new Vert();
			
			points[i].position = new Vector3();
			points[i].position.x = Random.Range (-size, size);
			points[i].position.y = Random.Range (-size, size);
			points[i].position.z = 0;
			
			points[i].color = new Vector3();
			points[i].color.x = Random.value > 0.5f ? 0.0f : 1.0f;
			points[i].color.y = Random.value > 0.5f ? 0.0f : 1.0f;
			points[i].color.z = Random.value > 0.5f ? 0.0f : 1.0f;
		}
		
		buffer.SetData(points);
	}
	
	void OnPostRender(){
		material.SetPass(0);
		material.SetBuffer("buffer", buffer);
		Graphics.DrawProceduralNow(MeshTopology.Points, count, 1);
	}
	
	void OnDestroy(){
		if(buffer != null)
		buffer.Release();
	}
}
