Shader "Custom/matCap Textura 2" {
	Properties {
		_MainTex ("Textura", 2D) = "white" {}
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_matCap ("MatCap", 2D) = "white" {}
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_influencia ("Influencia", Range(0,1)) = 0.5
		_brilho ("Brilho", Range(0,1)) = 0.5
//		_NormalMap ("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma target 4.0	
		#pragma surface surf BlinnPhong vertex:vert

		sampler2D _MainTex;
		sampler2D _AO;
		sampler2D _matCap;
		float4 _MainTint;
		float _influencia;
		float _brilho;
//		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AO;
			float2 uv_matCap;
//			float2 uv_NormalMap;
			float3 tan1;
			float3 tan2;
		};

		void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);

			TANGENT_SPACE_ROTATION;
			o.tan1 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
			o.tan2 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
		}

		void surf (Input IN, inout SurfaceOutput o) {
//			float3 normals = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
//			o.Normal = normals;

			float2 litSphereUV;
			litSphereUV.x = dot(IN.tan1, o.Normal);
			litSphereUV.y = dot(IN.tan2, o.Normal);

			half4 c1 = tex2D (_MainTex, IN.uv_MainTex);
			half4 cao = tex2D (_AO, IN.uv_AO);
			half4 c2 = tex2D (_matCap, litSphereUV*0.5+0.5) * _MainTint;
			o.Albedo = cao.rgb * lerp(c1.rgb, c2.rgb, _influencia);
			o.Emission = c2.rgb * _brilho;
			o.Alpha = c1.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
