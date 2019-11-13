Shader "Custom/NightVision" {
		Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_OtherTex ("Base (RGB)", 2D) = "white" {}
		_Noise ("Base (RGB)", 2D) = "Black" {}
		_RateLerp ("Rate Lerp", Range(0.0, 1.0)) = 1.0
		_RateMask ("Rate Mask", Range(0.0, 1.0)) = 0.5
		_Cor("Cor", Color) = (1,1,1,1)
		_Multiplicador("Multiplicador", Float) = 1
		_RandomValue("Random", Float) = 1
		_noiseSpeedX("Velocidade X", Float) = 1
		_noiseSpeedY("elocidade Y", Float) = 1
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
			uniform fixed4 _Cor;
			uniform float _Multiplicador;
			uniform float _RandomValue;
			uniform float _noiseSpeedX;
			uniform float _noiseSpeedY;
			uniform sampler2D _Noise;
			
			fixed4 frag(v2f_img IN) : COLOR {
				fixed4 fragTex = tex2D(_MainTex, IN.uv).rgba;
				fixed other = tex2D(_OtherTex, IN.uv);				
				fixed4 finalColor = fragTex;
				half2 dustUV = half2(IN.uv.x + (_RandomValue * _Time.z * _noiseSpeedX),
									 IN.uv.y + (_RandomValue * _Time.z * _noiseSpeedY));
				fixed4 noiseTex = tex2D(_Noise, dustUV);	
				//float fragTexGray = 0.334 * fragTex.r + 0.333 * fragTex.g + 0.333 * fragTex.b;
				//fixed4 finalColor = lerp(fragTex, fragTexGray, _RateLerp);
				if(other < _RateMask) {
					finalColor = fragTex;
				}
				return lerp(finalColor * other * (_Cor* _Multiplicador), noiseTex, 0.2);				
				//return finalColor * other* noiseTex * (_Cor* _Multiplicador);
			}
			ENDCG
		} 
	}
}