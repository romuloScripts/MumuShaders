Shader "Custom/CutScene" {
		Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cima ("Barra de Cima", Range(0.0,1.0)) = 1.0
		_Baixo ("Barra de Baixo", Range(0.0,1.0)) = 1.0
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
			uniform float _Cima;
			uniform float _Baixo;
			
			float4 frag(v2f_img IN) : COLOR{
				fixed4 fragTex = tex2D(_MainTex, IN.uv);
				fixed y = IN.uv.y;
				fragTex.xyz = (y > _Baixo && y < _Cima) ? fragTex.xyz : 0.0;
				return fragTex;
			}
		
			ENDCG
		} 
	}
}
