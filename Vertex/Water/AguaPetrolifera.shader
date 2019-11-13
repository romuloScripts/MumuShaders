Shader "Custom/AguaPetrolifera" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		
		
        _DispTex ("Disp Texture", 2D) = "gray" {}
		_Displacement ("Displacement", Range(0, 1.0)) = 0.3
        _TilingDispTex ("Tiling da textura de displace", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent-1" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert alpha:blend

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		
		sampler2D _DispTex;
		sampler2D _NormalMap;
		float _TilingDispTex;
		float _Displacement;
		
//		struct appdata {
//                float4 vertex : POSITION;
//                float4 tangent : TANGENT;
//                float3 normal : NORMAL;
//                float2 texcoord : TEXCOORD0;
//            };
         
		void vert (inout appdata_full v){
               float d = tex2Dlod(_DispTex, float4(v.texcoord.xy*_TilingDispTex+_Time.x*0.2,0,0)).r * _Displacement;
               v.vertex.xyz += v.normal * d;
        }

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness*c.a;
		 	o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
