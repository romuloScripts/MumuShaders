Shader "Custom/ImageEffect" {
	Properties {
		_MainTex ("Base Texture (RGB)", 2D) = "white" {}
		_VignetteTex ("Vignette Texture (RGB)", 2D) = "white" {}
		_ScratchesTex ("Scratches Texture (RGB)", 2D) = "white" {}
		_DustTex ("Dust Texture (RGB)", 2D) = "white" {}
		_SepiaColor ("Sepia Color", Color) = (1,1,1,1)
		_EffectAmount ("Olf Film Effect Amount", Range(0,1)) = 1.0
		_VignetteAmount("Vignette Amount", Range(0,1)) = 1
		_scratchesXS("Scratches X", Float) = 10
		_scratchesYS("Scratches Y", Float) = 10
		_DustYSpeed("Dust Y Speed", Float) = 10
		_DustXSpeed("Dust X Speed", Float) = 10	
		_RandomValue("Random Value", Float) = 1.0
	}
	
	SubShader {	
		Pass {		
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			// Reduz a precisao e acelera o fragment shader
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _VignetteTex;
			uniform sampler2D _ScratchesTex;
			uniform sampler2D _DustTex;
			fixed4 _SepiaColor;
			fixed _EffectAmount;
			fixed _VignetteAmount;
			half _ScratchesYSpeed;
			half _ScratchesXSpeed;
			half _DustYSpeed;
			half _DustXSpeed;	
			half _RandomValue;
			
			fixed4 frag(v2f_img IN) : COLOR {
			
				half2 renderTexUV = half2(IN.uv.x, IN.uv.y + (_RandomValue * _SinTime.z * 0.005));
				fixed4 renderTex = tex2D(_MainTex, IN.uv);
				
				fixed4 vignetteTex = tex2D(_VignetteTex, IN.uv);
				
				half2 scratchesUV = half2(IN.uv.x + (_RandomValue * _SinTime.z * _ScratchesXSpeed),
										  IN.uv.y + (_Time.x * _ScratchesYSpeed));
				fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);
										  
				half2 dustUV = half2(IN.uv.x + (_RandomValue * _SinTime.z * _DustXSpeed),
									 IN.uv.y + (_RandomValue * _SinTime.z * _DustYSpeed));
				fixed4 dustTex = tex2D(_DustTex, dustUV);				
				
				fixed luminosity = saturate(dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb));
				
				fixed4 finalColor = luminosity + lerp(_SepiaColor, _SepiaColor + fixed4(0.1f, 0.1f, 0.1f, 1.0f), _RandomValue);
				
				fixed3 constantWhite = fixed3(1,1,1);
				finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
				finalColor.rgb *= lerp(scratchesTex.rgb, constantWhite, _RandomValue);
				finalColor.rgb *= lerp(dustTex.rgb, constantWhite, _RandomValue*_SinTime.z);
				finalColor = lerp(renderTex, finalColor, _EffectAmount);
				
				return finalColor;
			}
			ENDCG
		} 
	}
}
