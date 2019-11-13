Shader "AO/WorldTex Bumped Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_BaseScale ("Base Tiling", Vector) = (1,1,1,0)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		[MaterialToggle] Noise ("Texture Noise", Float) = 0
		_NoiseColor ("Noise Color", Color) = (1,1,1,1)
		_Noise ("Texture Noise", 2D) = "white" {}

//		_MetallicBias ("Metallic Bias", Range(0, 1)) = 0
//        _MetallicScale ("Metallic Scale", Range(0, 2)) = 0
//        _SmoothnessBias ("Smoothness Bias", Range(0, 1)) = 0
//        _SmoothnessScale ("Smoothness Scale", Range(0, 2)) = 1
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300

		CGPROGRAM
		#pragma target 3.0	
		#pragma surface surf Lambert
		// #pragma surface surf Standard fullforwardshadows
		#pragma multi_compile DUMMY NOISE_ON

		sampler2D _AO;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;
		sampler2D _Noise;
		fixed4 _NoiseColor;
		fixed3 _BaseScale;

//		half _MetallicBias;
//        half _MetallicScale;
//        half _SmoothnessBias;
//        half _SmoothnessScale;

		struct Input {
			float2 uv_AO;
			float3 worldPos;
		};

//		void surf(Input IN, inout SurfaceOutputStandard o)
//        {
		void surf (Input IN, inout SurfaceOutput o) {
			//- Calculo da coordenada global da textura
			fixed4 c = tex2D(_MainTex, IN.worldPos.xz * _BaseScale.x);
			fixed4 n = tex2D(_BumpMap, IN.worldPos.xz * _BaseScale.y);

			fixed4 ao = tex2D(_AO, IN.uv_AO);
			o.Albedo = ao.rgb * c.rgb * _Color.rgb;
			//o.Albedo = c.rgb * _Color.rgb;
			#ifdef NOISE_ON
				fixed4 noise = tex2D(_Noise, IN.worldPos.xz * _BaseScale.z) * _NoiseColor;
				o.Albedo = lerp(o.Albedo, o.Albedo*noise, _NoiseColor.a);
			#endif
			o.Alpha = c.a * _Color.a;
			o.Normal = UnpackNormal(n);
//		 	o.Occlusion = ao.rgb;
//			o.Metallic = saturate(c.a * _MetallicScale + _MetallicBias);
//            o.Smoothness = saturate(c.a * _SmoothnessScale + _SmoothnessBias);
		}

		ENDCG  
	}

	FallBack "Diffuse"
}
