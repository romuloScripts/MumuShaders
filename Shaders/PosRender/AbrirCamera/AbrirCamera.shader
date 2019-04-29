Shader "Custom/AbrirCamera" {
		Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Fade ("Fade", Float) = 1.0
		_CentroX("X", Float) = 0.5
		_CentroY("Y", Float) = 0.5
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
			uniform fixed _Fade;
			uniform float _CentroX;
			uniform float _CentroY;
			uniform float _EscalaX;
			uniform float _EscalaY;
			
			float4 frag(v2f_img IN) : COLOR{

               	// Define a origem do espaço no meio da tela e corrige a razão de aspecto.
            	float2 uv = IN.uv;
            	uv.x *= _ScreenParams.x / _ScreenParams.y;

				fixed4 fragTex = tex2D(_MainTex, IN.uv);
				fixed2 centro;
				centro.x = _CentroX*_ScreenParams.x / _ScreenParams.y;
				centro.y = _CentroY;
				if(distance(centro,uv) > _Fade){
					fragTex.xyz = 0;
				}
				return fragTex;


			}
		
			ENDCG
		} 
	}
}
