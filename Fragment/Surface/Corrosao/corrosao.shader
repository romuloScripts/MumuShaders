Shader "Custom/Corrosao Difuse" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_corrosao ("TexCorrosao", 2D) = "white" {}
		_pos ("posicao", Vector) = (0.0 ,0.0 ,0.0 ,0.0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _corrosao;
		float4 _pos;

		struct Input {
			float2 uv_MainTex;
			float2 uv_corrosao;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half3 c = tex2D (_MainTex, IN.uv_MainTex);
			half3 c2 = tex2D (_corrosao, IN.uv_corrosao);
			float dist = distance(IN.worldPos.xyz, _pos.xyz);
			float smooth = smoothstep(_pos.w, _pos.w-0.3, dist);
			smooth = clamp( smooth - c2, 0, 1);
			o.Albedo = lerp(c.rgb, c2.rgb, smooth);
			if (smooth>0 && smooth<0.7) {
				o.Albedo += float3(0, 1, 0);
			}
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
