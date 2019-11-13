Shader "Grama2" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGBA) ", 2D) = "white" {}
		_Altura ("Altura", Range (.0002, 1)) = .25
		_Gravidade("gravidade", Float) = (0,0,0,0)
		_Forca ("Força",Range(0,1)) = 0
	}

	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjection"="True" "RenderType"="Transparent"}
		ZWrite On
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0
		 
		fixed4 _Color;
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.05
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.10
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.15
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.20
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.25
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.30
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.35
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.40
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.45
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.50
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.55
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.60
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.65
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.70
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.75
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.80
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.85
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.90
		#include "Repeticao2.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert
		#define PASSO 0.95
		#include "Repeticao2.cginc"
		ENDCG


	}

	Fallback "Diffuse"
}
