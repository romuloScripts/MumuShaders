Shader "Custom/3a" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = fixed3(IN.uv_MainTex.x,0,1-IN.uv_MainTex.x);
			o.Alpha = 1;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
