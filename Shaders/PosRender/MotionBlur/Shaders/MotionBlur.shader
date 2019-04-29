Shader "Custom/MotionBlur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tx1 ("Base (RGB)", 2D) = "white" {}
		_Tx2 ("Base (RGB)", 2D) = "white" {}
		_Tx3 ("Base (RGB)", 2D) = "white" {}
		_Blur ("Blur Amount", Range(0,1)) = 0.3
	}
	
	SubShader {	
		Tags { "Queue" = "Transparent" } 
		// Alpha Blend
		Blend SrcAlpha OneMinusSrcAlpha

		Pass {		
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag alpha
			// Reduz a precisao e acelera o fragment shader
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _Tx1;
			uniform sampler2D _Tx2;
			uniform sampler2D _Tx3;
			fixed _Blur;
										
			fixed4 frag(v2f_img IN) : COLOR {
				fixed4 fragTex = tex2D(_MainTex, IN.uv);
				fixed4 t1 = tex2D(_Tx1, IN.uv);	
				fixed4 t2 = tex2D(_Tx2, IN.uv);	
				fixed4 t3 = tex2D(_Tx3, IN.uv);	
				
				t1.a = _Blur;
				t2.a = _Blur;
				t3.a = _Blur;		
				fragTex.a = 1.0f;	

				fixed4 finalColor = lerp(t1, t2, 0.5);
				finalColor = lerp(finalColor, t3, 0.5);
				finalColor = lerp(finalColor, fragTex, 0.3);
							
				return saturate(finalColor);
			}
			ENDCG
		} 		
	}
}
