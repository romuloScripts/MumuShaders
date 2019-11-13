Shader "AO/WorldTex Bumped Diffuse CubeMap" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_BaseScale ("Base Tiling", Vector) = (1,1,1,0)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		[MaterialToggle] Noise ("Texture Noise", Float) = 0
		_NoiseColor ("Noise Color", Color) = (1,1,1,1)
		_Noise ("Texture Noise", 2D) = "white" {}
		_PocaXYWH ("Poca XYWH", Vector) = (0,0,1,1)
		_Poca ("Poças", 2D) = "white" {}
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_Cube ("Reflection Cubemap", Cube) = "_Skybox" //{ TexGen CubeReflect }
		_CubeBump ("Normalmap", 2D) = "bump" {}
		_vel ("Velocidade", Vector) = (0.5, 0.25, 0.1, 0.1)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300

		CGPROGRAM
		#pragma target 3.0	
		#pragma surface surf BlinnPhong
		#pragma multi_compile DUMMY NOISE_ON

		fixed4 _Color;
		half _Shininess;
		fixed4 _ReflectColor;
		sampler2D _AO;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Noise;
		fixed4 _NoiseColor;
		fixed4 _BaseScale;
		fixed4 _PocaXYWH;
		sampler2D _Poca;
		samplerCUBE _Cube;
		sampler2D _CubeBump;
		fixed4 _vel;

		struct Input {
			float2 uv_AO;
			float3 worldRefl;
			float3 worldPos;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.worldPos.xz * _BaseScale.x);
			fixed4 n = tex2D(_BumpMap, IN.worldPos.xz * _BaseScale.y);
			fixed4 poca = tex2D(_Poca, (IN.worldPos.xz - _PocaXYWH.xy) / _PocaXYWH.zw );
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			fixed2 offsetPoca = fixed2(_BaseScale.w,0); 
			fixed4 n2 = tex2D(_CubeBump, (IN.worldPos.xz+offsetPoca)*_vel.zw + _Time.x*_vel.xy*_vel.zw);

			o.Albedo = ao.rgb * c.rgb * _Color.rgb;
			o.Gloss = c.a * poca;
			o.Specular = _Shininess;

			#ifdef NOISE_ON
				fixed4 noise = tex2D(_Noise, IN.worldPos.xz * _BaseScale.z) * _NoiseColor;
				o.Albedo = lerp(o.Albedo, o.Albedo*noise, _NoiseColor.a);
			#endif
			o.Alpha = c.a * _Color.a;
			n = lerp(n, n2, poca.rgba );
			o.Normal = UnpackNormal( normalize(n) );

			fixed3 reflcol = texCUBE (_Cube, IN.worldRefl+o.Normal);
			//reflcol *= c.a;
			o.Albedo = lerp(o.Albedo, reflcol, _ReflectColor.a*poca.rgb);
			o.Emission = reflcol.rgb * _ReflectColor.rgb * poca.rgb;

		}

		ENDCG  
	}

	FallBack "Diffuse"
}
