using System;
using UnityEngine;

namespace UnityStandardAssets.ImageEffects
{
    [ExecuteInEditMode]
    [AddComponentMenu("Image Effects/Color Adjustments/Sepia Tone")]
    public class SepiaTone : ImageEffectBase
	{
        // Called by camera to apply image effect
		[Range(0,1)]
		public float nivel=0;
		public float Nivel{get{return nivel;} set{ nivel = value;}}
        void OnRenderImage (RenderTexture source, RenderTexture destination)
		{
           
             material.SetFloat("_Nivel",nivel);
             Graphics.Blit (source, destination, material);
        }
    }
}
