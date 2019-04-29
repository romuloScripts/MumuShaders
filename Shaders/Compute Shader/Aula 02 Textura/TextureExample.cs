﻿using UnityEngine;
using System.Collections;

public class TextureExample : MonoBehaviour {

	public ComputeShader shader , shaderCopy;
	RenderTexture tex, texCopy;
	
	void Start (){	
		// parte 1
//		tex = new RenderTexture(64, 64, 0);
//		tex.enableRandomWrite = true;
//		tex.Create();
//		shader.SetFloat("w", tex.width);
//		shader.SetFloat("h", tex.height);
//		shader.SetTexture(0, "tex", tex);
//		shader.Dispatch(0, tex.width/8, tex.height/8, 1);
		
		// parte 2
//		tex = new RenderTexture(64, 64, 0);
//		tex.enableRandomWrite = true;
//		tex.Create();
//		shader.SetTexture(0, "tex", tex);
//		shader.Dispatch(0, tex.width/8, tex.height/8, 1);
		
		// parte 3
		tex = new RenderTexture(64, 64, 0);
		tex.enableRandomWrite = true;
		tex.Create();
		
		texCopy = new RenderTexture(64, 64, 0);
		texCopy.enableRandomWrite = true;
		texCopy.Create();
		
		shader.SetTexture(0, "tex", tex);
		shader.Dispatch(0, tex.width/8, tex.height/8, 1);
		
		shaderCopy.SetTexture(0, "tex", tex);
		shaderCopy.SetTexture(0, "texCopy", texCopy);
		shaderCopy.Dispatch(0, texCopy.width/8, texCopy.height/8, 1);
		
		// textura 3D
//		tex = new RenderTexture(64, 64, 0);
//		tex.volumeDepth = 64;
//		tex.isVolume = true;
//		tex.enableRandomWrite = true;
//		tex.Create();
//		shader.Dispatch(0, tex.width/8, tex.height/8, tex.depth/8);
	}
	
	void OnGUI(){
		int w = Screen.width/2;
		int h = Screen.height/2;
		int s = 512;	
		//GUI.DrawTexture(new Rect(w-s/2,h-s/2,s,s), tex);
		GUI.DrawTexture(new Rect(w-s/2,h-s/2,s,s), texCopy);
	}
	
	void OnDestroy(){
		if(tex)
		tex.Release();
		if(texCopy)
		texCopy.Release();
	}
}
