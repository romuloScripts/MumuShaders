Shader "AO/Corrosao Specular" {

	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_corrosao ("TexCorrosao", 2D) = "white" {}
		_pos ("posicao", Vector) = (0.0 ,0.0 ,0.0 ,0.0)
		_pos2 ("Brilho", Vector) = (28.4 ,0.5 ,0.54 ,45.0)
		_Emission ("Emision Color", Color) = (0,0,0,0)
		_IntencidadeBrilho(" IntencidadeBrilho",Range(0,1)) = 0.25
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300

		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf BlinnPhong

		sampler2D _AO;
		sampler2D _MainTex;
		sampler2D _corrosao;
		float4 _pos;
		float4 _pos2;
		fixed4 _Color;
		fixed4 _Emission;
		half _Shininess;
		half _IntencidadeBrilho;

		struct Input {
			float2 uv_AO;
			float2 uv_MainTex;
			float2 uv_corrosao;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			o.Albedo = ao.rgb * tex.rgb * _Color.rgb;

			// Corrosao
			half3 c2 = tex2D (_corrosao, IN.uv_corrosao);
			float dist = distance(IN.worldPos.xyz, _pos.xyz);
			float smooth = smoothstep(_pos.w, _pos.w-0.3, dist);
			smooth = clamp( smooth - c2, 0, 1);
			o.Albedo = lerp(o.Albedo, c2.rgb, smooth);
			if (smooth>0 && smooth<0.7) {
				o.Albedo += float3(0, 1, 0);
			}
			
			//brilho
			float _ang = _pos2.w;
			float2 xy = float2(cos(_ang)*IN.worldPos.x + sin(_ang)*IN.worldPos.y,
								-sin(_ang)*IN.worldPos.x + cos(_ang)*IN.worldPos.y) ;					
			//float distX = distance(xy.x, _pos2.x);
			//fixed4 brilho = saturate(lerp(0,1,1-distX*_pos2.z));
			fixed4 brilho =  saturate(sin(xy.x*_pos2.z+(_Time.w*_pos2.y))*_pos2.x-(_pos2.x-_IntencidadeBrilho))*(1-smooth);

			o.Gloss = tex.a;
			o.Alpha = tex.a * _Color.a;
			o.Specular = _Shininess;
			o.Emission = _Emission + brilho ;
		}
		ENDCG
	}

	Fallback "VertexLit"
}
