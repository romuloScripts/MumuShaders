Shader "Custom/Poeira" {
Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Textura ("Textura (RGB)", 2D) = "white" {}
      	_OffSet ("OffSet", Float) = 0
      	//_Vel("Velocidade",Float) = 1
	}
	SubShader 
	{
		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert_img
			#pragma fragment frag alpha
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		
			uniform sampler2D _MainTex;
			uniform sampler2D _Textura;
			uniform fixed _OffSet;
			//uniform fixed _Vel;
			
			float4 frag(v2f_img IN) : COLOR{
				fixed4 fragTex = tex2D(_MainTex, IN.uv);
				fixed2 offset2 = IN.uv;
				offset2.x =IN.uv.x + _OffSet;
				fixed4 poeira = tex2D(_Textura, offset2);
				return fragTex+poeira;
			}
		
			ENDCG
		} 
	}
}
