Shader "Custom/Corrosao RimBump" {
	
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
		_corrosao ("TexCorrosao", 2D) = "white" {}
		_pos ("posicao", Vector) = (0.0 ,0.0 ,0.0 ,0.0)
	}

	SubShader {
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma target 3.0	
		struct Input {
			float2 uv_MainTex;
			float2 uv_corrosao;
			float2 uv_BumpMap;
			float3 viewDir;
			float3 worldPos;
		};

		half4 _Color;
		sampler2D _MainTex;
		sampler2D _corrosao;
		float4 _pos;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			half3 c2 = tex2D (_corrosao, IN.uv_corrosao);
			float dist = distance(IN.worldPos.xyz, _pos.xyz);
			float smooth = smoothstep(_pos.w, _pos.w-0.3, dist);
			smooth = clamp( smooth - c2, 0, 1);
			o.Albedo = lerp(c.rgb, c2.rgb, smooth);
			if (smooth>0 && smooth<0.7) {
				o.Albedo += float3(0, 1, 0);
			}
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow (rim, _RimPower);
			o.Alpha = c.a;
		}
		ENDCG
	} 
	Fallback "Diffuse"
 }
