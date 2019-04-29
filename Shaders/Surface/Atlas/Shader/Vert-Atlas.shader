Shader "Custom/Vert Atlas" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_tiles ("Tiles Atlas", Float) = 4.0
		_cut ("Corte", Range(0,1)) = 1
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
			float2 _offset;
		};

		float _tiles;
		float _cut;
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void vert(inout appdata_full v, out Input o) {
			o.vertColor = v.color;
			o._offset = float2( floor(v.texcoord.x*_tiles), floor(v.texcoord.y*_tiles) ) / _tiles;
			o.uv_MainTex = v.texcoord;
			o.uv_BumpMap = v.texcoord;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c1 = fixed4( IN.vertColor.rgb, 1);
			float2 tile = frac(IN.uv_MainTex*_tiles)/_tiles;
			fixed4 c2 = tex2D (_MainTex, tile*_cut + IN._offset + float2(0.5/_tiles,0.5/_tiles)*(1-_cut));
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
