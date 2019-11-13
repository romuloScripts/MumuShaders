Shader "Custom/Pisca" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Frequencia( "Frequencia do Pulso", Float ) = 60.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert alpha
		        // surface shader, metodo e iluminaçao 
		sampler2D _MainTex;
		half _Frequencia;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a * (sin(_Time*_Frequencia)*0.5) +0.5;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
