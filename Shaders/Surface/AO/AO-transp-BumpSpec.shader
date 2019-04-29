Shader "AO Transp/Bumped Specular" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_MainTex ("Base(RGB) Gloss(A)", 2D) = "white" {}
		_BumpMap ("Bump Map", 2D) = "bump" {}
	}

	SubShader { 
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 400

		CGPROGRAM
		#pragma surface surf BlinnPhong alpha:blend

		sampler2D _MainTex;
		sampler2D _AO;
		sampler2D _BumpMap;
		fixed4 _Color;
		half _Shininess;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AO;
			float2 uv_BumpMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			o.Albedo = ao.rgb * tex.rgb * _Color.rgb;
			o.Gloss = tex.a;
			o.Alpha = ao.a;
			o.Specular = _Shininess;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		}
		ENDCG
	}
	FallBack "Specular"
}