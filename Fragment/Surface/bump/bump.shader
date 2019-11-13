Shader "Custom/bump" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_BumpMulti ( "Amplitude", Float ) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed _BumpMulti;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex).rgba;
			o.Albedo = c;
			o.Normal = UnpackNormal( tex2D(_BumpMap, IN.uv_BumpMap)) * _BumpMulti;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
