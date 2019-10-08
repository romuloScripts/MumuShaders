#if POSTPROCESS

using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine;

public class PostProcessVolumeBlend : ObjectValue {

	public PostProcessVolume profile;
	public float timeIn = 0.3f;
	public AnimationCurve curve = AnimationCurve.Linear(0,0,1,1);
	
	public void FadeIn()
	{
		DOTween.To(() => profile.weight, x => profile.weight = x, 1, timeIn).SetUpdate(true);
	}

	public override void setValue(float value)
	{
		profile.weight = curve.Evaluate(value);
	}
}
#endif
