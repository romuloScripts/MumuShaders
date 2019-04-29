Shader "Custom/Fade" {
		Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Fade ("Fade", Range(0.0,1.0)) = 1.0
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
			
			float4 frag(v2f_img IN) : COLOR{
				fixed4 fragTex = tex2D(_MainTex, IN.uv);
				fixed x = IN.uv.x;
				fragTex.xyz = (x > _Fade) ? fragTex.xyz : 0.0;
				return fragTex;
			}
		
			ENDCG
		} 
	}
}