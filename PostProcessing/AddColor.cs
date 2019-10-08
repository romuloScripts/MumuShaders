#if POSTPROCESS



using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.PostProcessing;
using ColorParameter = UnityEngine.Rendering.PostProcessing.ColorParameter;
using FloatParameter = UnityEngine.Rendering.PostProcessing.FloatParameter;

[Serializable]
[PostProcess(typeof(AddColorScreenRenderer), PostProcessEvent.AfterStack, "Custom/AddColor")]
public sealed class AddColor : PostProcessEffectSettings
{
	[Range(0f, 1f), Tooltip("Fade Screen")]
	public FloatParameter blend = new FloatParameter { value = 0.5f };
	[ColorUsage(true,true)]
	public ColorParameter color = new ColorParameter { value = Color.black };
}
 
public sealed class AddColorScreenRenderer : PostProcessEffectRenderer<AddColor>
{
	public override void Render(PostProcessRenderContext context)
	{
		var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/AddColorScreen"));
		sheet.properties.SetFloat("_Blend", settings.blend);
		sheet.properties.SetColor("_newColor", settings.color);
		context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
	}
}

#endif