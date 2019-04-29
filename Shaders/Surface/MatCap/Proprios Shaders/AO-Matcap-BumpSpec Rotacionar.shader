Shader "AO/Matcap Bumped Specular Rotacionar" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_MainTex ("Base(RGB) RefStrGloss(A)", 2D) = "white" {}
		_matcap ("Mat Cap", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_Vel("Velocidade",Float) =1
	}

	SubShader {
		//Lighting Off
		Tags { "RenderType"="Opaque" }
		LOD 400
//		ZWrite Off
//		Blend SrcAlpha OneMinusSrcAlpha
		 
		CGPROGRAM
		//#pragma surface surf Standard fullforwardshadows
		#pragma surface surf BlinnPhong vertex:vert
		#pragma target 4.0
		//input limit (8) exceeded, shader uses 9
		//#pragma exclude_renderers d3d11_9x

		sampler2D _AO;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _matcap;

		fixed4 _Color;
		fixed4 _ReflectColor;
		half _Shininess;
		half _Vel;
		
		struct Input {
			float2 uv_AO;
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 tan1;
			float3 tan2;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void vert (inout appdata_full v, out Input o) {
			
			//Rotacionar
			float _ang = _Time.w*_Vel;
			float x = cos(_ang)*v.vertex.x + sin(_ang)*v.vertex.z;
			float z = -sin(_ang)*v.vertex.x + cos(_ang)*v.vertex.z;
			v.vertex.x = x;
			v.vertex.z = z;
			x = cos(_ang)*v.normal.x + sin(_ang)*v.normal.z;
			z = -sin(_ang)*v.normal.x + cos(_ang)*v.normal.z;
			v.normal.x = x;
			v.normal.z = z;
			
			
			
			UNITY_INITIALIZE_OUTPUT(Input,o);

			TANGENT_SPACE_ROTATION;
			o.tan1 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
			o.tan2 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

			float2 litSphereUV;
			litSphereUV.x = dot(IN.tan1, o.Normal);
			litSphereUV.y = dot(IN.tan2, o.Normal);
			fixed4 reflcol = tex2D (_matcap, litSphereUV*0.5+0.5);

			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			fixed4 c = tex * _Color;
			o.Albedo = ao.rgb * c.rgb;
			//o.Albedo = c.rgb;

			o.Gloss = tex.a;
			o.Specular = _Shininess;

			//float3 worldRefl = WorldReflectionVector (IN, o.Normal);
			//fixed4 reflcol = texCUBE (_Cube, worldRefl);
			reflcol *= tex.a;
			o.Emission = reflcol.rgb * _ReflectColor.rgb;
			o.Alpha = reflcol.a * _ReflectColor.a;
		}
		ENDCG
	}

	FallBack "AO/Bumped Diffuse"
}
