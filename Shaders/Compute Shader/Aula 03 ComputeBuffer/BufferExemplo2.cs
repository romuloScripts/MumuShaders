using UnityEngine;
using System.Collections;

public class BufferExemplo2 : MonoBehaviour {

	public ComputeShader shader;
	
	struct VecMatPair{
		public Vector3 point;
		public Matrix4x4 matrix;
	}
	
	void Start(){
		VecMatPair[] data = new VecMatPair[5];
		VecMatPair[] output = new VecMatPair[5];
		//inicializar data aqui

		ComputeBuffer buffer = new ComputeBuffer(data.Length, sizeof(float)*3 + sizeof(float)*16);
		//buffer.SetData(data);
		int kernel = shader.FindKernel("Multiply");
		shader.SetBuffer(kernel, "dataBuffer", buffer);
		shader.Dispatch(kernel, data.Length, 1,1);
		buffer.GetData(output);
		
//		for (int i = 0; i < data.Length; i++) {
//			Debug.Log(data[i].point+" "+ output[i].point);
//		}
		buffer.Release();
	}
}
