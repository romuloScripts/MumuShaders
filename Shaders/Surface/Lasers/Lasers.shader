// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Lasers" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_LaserCenter ("Laser Center", Float) = (0,0,0)
		_LaserColor ("Laser Color", Color) = (1,1,1,1)
		_LaserWidth ("Laser Width", Float) = 1
		_LaserPotency ("Laser Potency", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 position_in_world_space : TEXCOORD0;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float3 _LaserCenter;
		fixed4 _LaserColor;
		fixed _LaserWidth;
		fixed _LaserPotency;

		void vert(inout appdata_full v, out Input o)
		{
			float4 worldVertex = mul(unity_ObjectToWorld, v.vertex);
			o.position_in_world_space = worldVertex;
			o.uv_MainTex = v.texcoord;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			if( IN.position_in_world_space.x >= (_LaserCenter.x - _LaserWidth/2) && IN.position_in_world_space.x <= (_LaserCenter.x + _LaserWidth/2)) {
				o.Albedo = _LaserColor * _LaserPotency;
			}

			if( IN.position_in_world_space.y >= (_LaserCenter.y - _LaserWidth/2) && IN.position_in_world_space.y <= (_LaserCenter.y + _LaserWidth/2)) {
				o.Albedo = _LaserColor * _LaserPotency;
			}

			if( IN.position_in_world_space.z >= (_LaserCenter.z - _LaserWidth/2) && IN.position_in_world_space.z <= (_LaserCenter.z + _LaserWidth/2)){
				o.Albedo = _LaserColor * _LaserPotency;
			}		

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
