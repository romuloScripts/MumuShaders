Shader "Custom/4a" {
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
			fixed x = IN.uv_MainTex.x;
			fixed y = IN.uv_MainTex.y;
			
			o.Albedo = fixed3(abs(x-y),0,1-abs(x-y));
			o.Alpha = 1;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
