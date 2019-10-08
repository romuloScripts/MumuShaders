#if POSTPROCESS
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
 
[Serializable]
[PostProcess(typeof(BlendRenderTextureRenderer), PostProcessEvent.AfterStack, "Custom/BlendTexture")]
public sealed class BlendRenderTexture : PostProcessEffectSettings
{
	[Range(0f, 1f), Tooltip("Blend Texture")]
	public FloatParameter blend = new FloatParameter { value = 0f };
	public TextureParameter leftTexture =new TextureParameter();
	public TextureParameter rightTexture =new TextureParameter();
	
}
 
public sealed class BlendRenderTextureRenderer : PostProcessEffectRenderer<BlendRenderTexture>
{
	public override void Render(PostProcessRenderContext context)
	{
		var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/BlendTextures"));
		if(settings.leftTexture.value != null && settings.rightTexture.value != null){
			sheet.properties.SetFloat("_Blend", settings.blend);
			sheet.properties.SetTexture("_Left", settings.leftTexture.value);
			sheet.properties.SetTexture("_Right", settings.rightTexture.value);
		}
		context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
	}
}
#endif