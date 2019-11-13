Shader "Custom/5a" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		//usa produto escalar dot(v1,v2)
		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half3 c = tex2D (_MainTex, IN.uv_MainTex);
			half NdorViewdir = saturate(dot(o.Normal,normalize(IN.viewDir)));
			o.Albedo = c.rgb;
			o.Alpha = NdorViewdir;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
