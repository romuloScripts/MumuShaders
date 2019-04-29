﻿using UnityEngine;
using System.Collections;

public class ConsumeBufferExample : MonoBehaviour {

	public Material material;
	public ComputeShader appendBufferShader;
	public ComputeShader consumeBufferShader;
	
	const int width = 32;
	const float size = 5.0f;
	
	ComputeBuffer buffer;
	ComputeBuffer argBuffer;
	
	void Start(){
		
		buffer = new ComputeBuffer(width * width, sizeof(float) * 3, ComputeBufferType.Append);
		
		appendBufferShader.SetBuffer(0, "appendBuffer", buffer);
		appendBufferShader.SetFloat("size", size);
		appendBufferShader.SetFloat("width", width);
		appendBufferShader.Dispatch(0, width/8, width/8, 1);
		
		consumeBufferShader.SetBuffer(0, "consumeBuffer", buffer);
		consumeBufferShader.Dispatch(0, 1, 2, 1);
		
		argBuffer = new ComputeBuffer(4, sizeof(int), ComputeBufferType.IndirectArguments);
		
		int[] args = new int[]{ 0, 1, 0, 0 };
		argBuffer.SetData(args);
		
		ComputeBuffer.CopyCount(buffer, argBuffer, 0);
		argBuffer.GetData(args);
		
		Debug.Log("vertex count " + args[0]);
		Debug.Log("instance count " + args[1]);
		Debug.Log("start vertex " + args[2]);
		Debug.Log("start instance " + args[3]);
		
	}
	
	void OnPostRender (){
		material.SetPass(0);
		material.SetBuffer ("buffer", buffer);
		material.SetColor("col", Color.red);
		Graphics.DrawProceduralIndirectNow(MeshTopology.Points, argBuffer, 0);
	}
	
	void OnDestroy (){
		if(buffer != null)
		buffer.Release();
		if(argBuffer != null)
		argBuffer.Release();
	}
}