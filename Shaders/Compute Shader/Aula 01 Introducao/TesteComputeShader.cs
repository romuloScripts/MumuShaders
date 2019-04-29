using UnityEngine;
using System.Collections;

struct VecMatPair
{
	public Vector3 point;
	public Matrix4x4 matrix;
}

public class TesteComputeShader : MonoBehaviour {

	public ComputeShader shader;
	
	void Start (){
//		ComputeBuffer buffer = new ComputeBuffer(4 * 2, sizeof(int));
//		
//		shader.SetBuffer(0, "buffer1", buffer);
//		
//		shader.Dispatch(0, 2, 1, 1);
//		
//		int[] data = new int[4 * 2];
//		
//		buffer.GetData(data);
//		
//		for(int i = 0; i < 4 * 2; i++)
//			Debug.Log(data[i]);
//		
//		buffer.Release();
		ComputeBuffer buffer = new ComputeBuffer (4 * 4 * 2 * 2, sizeof(int));
		
		int kernel = shader.FindKernel ("CSMain2");
		
		shader.SetBuffer (kernel, "buffer2", buffer);

		shader.Dispatch (kernel, 2, 2, 1);
		
		int[] data = new int[4 * 4 * 2 * 2];
		
		buffer.GetData (data);
		
//		foreach (var item in data) {
//			Debug.Log(item);
//		}
		
		for(int i = 0; i < 8; i++)
		{
			string line = "";
			for(int j = 0; j < 8; j++)
			{
				line += " " + data[j+i*8];
			}
			Debug.Log (line);
		}
		
		buffer.Release ();
	}
}
