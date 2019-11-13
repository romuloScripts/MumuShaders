Shader "Custom/Vert Bumped" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows
		#pragma vertex vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			fixed3 vertColor;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void vert(inout appdata_full v, out Input o) {
			o.vertColor  = v.color;
			o.uv_MainTex = v.texcoord;
			o.uv_BumpMap = v.texcoord;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c1 = fixed4( IN.vertColor.rgb, 1);
			fixed4 c2 = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c1.rgb * c2.rgb * _Color;
			o.Normal = UnpackNormal( tex2D(_BumpMap, IN.uv_BumpMap) );

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c2.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
