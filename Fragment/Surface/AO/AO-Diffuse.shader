Shader "AO/Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _AO;
		sampler2D _MainTex;
		fixed4 _Color;

		struct Input {
			float2 uv_AO;
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			o.Albedo = ao.rgb * c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback "VertexLit"
}