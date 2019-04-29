Shader "Custom/ImageEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_OtherTex ("Base (RGB)", 2D) = "white" {}
		_RateLerp ("Rate Lerp", Range(0.0, 1.0)) = 1.0
		_RateMask ("Rate Mask", Range(0.0, 1.0)) = 0.5
	}
	
	SubShader {	
		Pass {		
			CGPROGRAM
			// Vertex padrao para processamento de imagens
			#pragma vertex vert_img 
			// Fragment shader pois nao usa modelo de iluminacao
			#pragma fragment frag
			// Reduz a precisao e acelera o fragment shader
			#pragma fragmentoption ARB_precision_hint_fastest
			//#pragma fragmentoption ARB_precision_hint_nicest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _OtherTex;
			uniform fixed _RateLerp;
			uniform fixed _RateMask;
			
			fixed4 frag(v2f_img IN) : COLOR {
				fixed4 fragTex = tex2D(_MainTex, IN.uv).rgba;
				fixed other = tex2D(_OtherTex, IN.uv);				
				
				float fragTexGray = 0.334 * fragTex.r + 0.333 * fragTex.g + 0.333 * fragTex.b;
				fixed4 finalColor = lerp(fragTex, fragTexGray, _RateLerp);
				
				if(other < _RateMask) {
					finalColor = fragTex;
				}				
				return finalColor * other;
			}
			ENDCG
		} 
	}
}
