Shader "Nery Shaders/Camera/Bleach" {
		Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BleachPower ("Bleach Power", Range(0.0,2.0)) = 1.0
		_Opacity ("Opacity", Range(0.0,1.0)) = 1.0
	}
	SubShader 
	{
		Pass
		{
		
		CGPROGRAM
		#pragma vertex vert_img
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform float _BleachPower;
		uniform float _Opacity;
		
		float4 frag(v2f_img i) : COLOR
		{
			float4 renderTex = tex2D(_MainTex, i.uv);
		    float3 lumCoeff = float3(0.25, 0.65, 0.1);
		    float lum = dot(lumCoeff, renderTex.rgb);
		    float3 blend = lum.rrr;
		    float L = min( 1, max( 0, 10 * (lum - 0.45)));
		    float3 result1 = 2.0f * renderTex.rgb * blend;
		    float3 result2 = 1.0f - 2.0f * (1.0f - blend) * (1.0f - renderTex.rgb);
		    float3 newColor = lerp(result1, result2, L);
		    float A2 = _Opacity * renderTex.a;
		    float3 mixRGB = A2 * newColor.rgb;
		    mixRGB += ((1.0f - A2) * renderTex.rgb);
		    
		    return float4(mixRGB, renderTex.a);
		
		}

		ENDCG
		} 
	}
}