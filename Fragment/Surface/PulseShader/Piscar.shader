Shader "Custom/Piscar" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Color2 ("Color 2", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Transicao ("Transicao", Range(0,1)) = 0.0
		_Vel("Velocidade",Float) = 1

		_pos ("Brilho", Vector) = (28.4 ,0.5 ,0.54 ,45.0)
		_Emission ("Emision Color", Color) = (0,0,0,0)
		_IntencidadeBrilho(" IntencidadeBrilho",Range(0,1)) = 0.25
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _Color2;
		half _Transicao;
		half _Vel;

		half _IntencidadeBrilho;
		float4 _pos;
		fixed4 _Emission;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * lerp(_Color,_Color2,_Transicao*(sin(_Time.w*_Vel)*0.5+0.5));
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;

			//brilho
			float _ang = _pos.w;
			float2 xy = float2(cos(_ang)*IN.worldPos.x + sin(_ang)*IN.worldPos.y,
								-sin(_ang)*IN.worldPos.x + cos(_ang)*IN.worldPos.y) ;					
			fixed4 brilho =  saturate(sin(xy.x*_pos.z+(_Time.w*_pos.y))*_pos.x-(_pos.x-_IntencidadeBrilho));
			
			o.Emission = _Emission + brilho;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
