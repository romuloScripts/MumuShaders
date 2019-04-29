Shader "AO/Corrosao Matcap Specular" {

	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_MainTex ("Base(RGB) RefStrGloss(A)", 2D) = "white" {}
		_matcap ("Mat Cap", 2D) = "white" {}
		_corrosao ("TexCorrosao", 2D) = "white" {}
		_pos ("posicao", Vector) = (0.0 ,0.0 ,0.0 ,0.0)
		_pos2 ("Brilho", Vector) = (28.4 ,0.5 ,0.54 ,45)
		_Emission ("Emision Color", Color) = (0,0,0,0)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 400

		CGPROGRAM
		#pragma surface surf BlinnPhong vertex:vert
		#pragma target 4.0
		//input limit (8) exceeded, shader uses 9
		#pragma exclude_renderers d3d11_9x

		sampler2D _AO;
		sampler2D _MainTex;
		sampler2D _matcap;
		sampler2D _corrosao;
		float4 _pos;
		float4 _pos2;
		fixed4 _Emission;
		fixed4 _Color;
		fixed4 _ReflectColor;
		half _Shininess;

		struct Input {
			float2 uv_AO;
			float2 uv_MainTex;
			float2 uv_corrosao;
			float3 tan1;
			float3 tan2;
			float3 worldRefl;
			float3 worldPos;
			INTERNAL_DATA
		};

		void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);

			TANGENT_SPACE_ROTATION;
			o.tan1 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
			o.tan2 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float2 litSphereUV;
			litSphereUV.x = dot(IN.tan1, o.Normal);
			litSphereUV.y = dot(IN.tan2, o.Normal);
			fixed4 reflcol = tex2D (_matcap, litSphereUV*0.5+0.5);

			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			fixed4 c = tex * _Color;
			o.Albedo = ao.rgb * c.rgb;

			// Corrosao
			half3 c2 = tex2D (_corrosao, IN.uv_corrosao);
			float dist = distance(IN.worldPos.xyz, _pos.xyz);
			float smooth = smoothstep(_pos.w, _pos.w-0.3, dist);
			smooth = clamp( smooth - c2, 0, 1);
			o.Albedo = lerp(o.Albedo, c2.rgb, smooth);
			if (smooth>0 && smooth<0.7) {
				o.Albedo += float3(0, 1, 0);
			}

			o.Gloss = tex.a;
			o.Specular = _Shininess;


			//float3 worldRefl = WorldReflectionVector (IN, o.Normal);
			//fixed4 reflcol = texCUBE (_Cube, worldRefl);
			
			//brilho
			float _ang = _pos2.w;
			float2 xy = float2(cos(_ang)*IN.worldPos.x + sin(_ang)*IN.worldPos.y,
								-sin(_ang)*IN.worldPos.x + cos(_ang)*IN.worldPos.y) ;					
			fixed4 brilho =  saturate(sin(xy.x*_pos2.z+(_Time.w*_pos2.y))*_pos2.x-(_pos2.x-0.25))*(1-smooth);
			
			reflcol *= tex.a;
			o.Emission = reflcol.rgb * _ReflectColor.rgb + _Emission + brilho;
			o.Alpha = reflcol.a * _ReflectColor.a;
		}
		ENDCG
	}

	FallBack "AO/Bumped Diffuse"
}
