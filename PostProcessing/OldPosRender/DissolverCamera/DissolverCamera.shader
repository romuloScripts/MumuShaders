Shader "Custom/DissolverCamera" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_TexturaVelha ("TexturaVelha (RGB)", 2D) = "white" {}
		_Mascara ("Mascara (RGB)", 2D) = "white" {}
      	_Fade ("Fade", Range(0.0, 1.0)) = 0
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
			uniform sampler2D _Mascara;
			uniform sampler2D _TexturaVelha;
			uniform fixed _Fade;
			
			
			float4 frag(v2f_img IN) : COLOR{
				fixed4 fragTex = tex2D(_MainTex, IN.uv);
				if((fixed)tex2D(_Mascara, IN.uv).rgb > _Fade)	
					return 	tex2D(_TexturaVelha,IN.uv);
				else{
					return fragTex;
				}
				//_Fade = (tex2D(_Mascara, IN.uv).rgb - _Fade);
				//return lerp(fragTex,tex2D(_TexturaVelha,IN.uv),_Fade);
			}
		
			ENDCG
		} 
	}
}
