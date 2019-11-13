Shader "AO/Bumped Diffuse" {
	Properties {
		[MaterialToggle] Noise ("Ativar Noise", Float) = 0
		_Color ("Main Color", Color) = (1,1,1,1)
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300

		CGPROGRAM
		#pragma target 3.0	
		#pragma surface surf Lambert
		#pragma multi_compile DUMMY NOISE_ON

		sampler2D _AO;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;
		
		struct Input {
			float2 uv_AO;
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldPos;
		};

		// hash based 3d value noise
		// function taken from [url]https://www.shadertoy.com/view/XslGRr[/url]
		// Created by inigo quilez - iq/2013
		// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
		float hash(float n) {
			return frac(sin(n)*43758.5453);
		}

		float noise(float3 x) {
		    // The noise function returns a value in the range -1.0f -> 1.0f

			float3 p = floor(x);
			float3 f = frac(x);

			f = f*f*(3.0-2.0*f);
			float n = p.x + p.y*57.0 + 113.0*p.z;

			return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
				lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
				lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
				lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			#ifdef NOISE_ON
				o.Albedo = ao.rgb * c.rgb * _Color.rgb * (noise( IN.worldPos )*0.5 + 0.5);
			#else
				o.Albedo = ao.rgb * c.rgb * _Color.rgb;
			#endif
			o.Alpha = c.a * _Color.a;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		}

		ENDCG  
	}

	FallBack "Diffuse"
}
