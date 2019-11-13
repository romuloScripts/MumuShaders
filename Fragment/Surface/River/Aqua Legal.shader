Shader "Custom/AguaLegal" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//_BumpMap ("Normalmap", 2D) = "bump" {}
		[MaterialToggle] Noise ("Esmaecer", Float) = 0
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_Cube ("Reflection Cubemap", Cube) = "_Skybox" //{ TexGen CubeReflect }
		_CubeBump ("Normalmap", 2D) = "bump" {}
		_vel ("Velocidade", Vector) = (0.5, 0.25, 0.1, 0.1)
		_YMax("YMax", Float) = 2
		_YMin("YMin", Float) = 2
	}

	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 300
		
    	Fog {Mode Off}
		
		CGPROGRAM
		#pragma target 3.0	
		#pragma surface surf BlinnPhong alpha:blend
		//#pragma surface surf Lambert alpha
		//#pragma surface surf BlinnPhong alphatest:_Cutoff
		#pragma multi_compile DUMMY NOISE_ON
		
		fixed4 _Color;
		half _Shininess;
		fixed4 _ReflectColor;
		sampler2D _MainTex;
		//sampler2D _BumpMap;
		samplerCUBE _Cube;
		sampler2D _CubeBump;
		fixed4 _vel;
		fixed _YMax;
		fixed _YMin;

		struct Input {
			float2 uv_MainTex;
			//float2 uv_BumMap;
			float2 uv_CubeBump;
			float3 worldRefl;
			float3 worldPos;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex*_vel.zw + _Time.x*_vel.xy*_vel.zw);
			//fixed4 n = tex2D(_BumpMap, IN.uv_BumpMap);
			fixed4 n2 = tex2D(_CubeBump, IN.uv_CubeBump*_vel.zw + _Time.x*_vel.xy*_vel.zw);
			
			fixed alfa=1;
			#ifdef NOISE_ON
				alfa = smoothstep(_YMax,_YMin,IN.worldPos.y);
			#endif
			o.Albedo = c.rgb * _Color.rgb;
			o.Gloss = c.a * alfa;
			o.Specular = _Shininess;

			o.Alpha = c.a * _Color.a * alfa;
			o.Normal = UnpackNormal( n2 );

			fixed3 reflcol = texCUBE (_Cube, IN.worldRefl+o.Normal);
			reflcol *= c.a * alfa;
			o.Albedo = lerp(o.Albedo, reflcol, _ReflectColor.a* alfa);
			o.Emission = reflcol.rgb * _ReflectColor.rgb;

		}

		ENDCG  
	}

	FallBack "Diffuse"
}
