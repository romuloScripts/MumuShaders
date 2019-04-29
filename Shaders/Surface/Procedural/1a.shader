Shader "Custom/1a" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Multi("Multi",Range(0,100)) = 25.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _Multi;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 x = IN.uv_MainTex.x-0.5;
			half4 y = IN.uv_MainTex.y-0.5;
			o.Albedo = saturate(cos(_Multi*sqrt(x*x+y*y)));
			o.Alpha = 1.0;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
