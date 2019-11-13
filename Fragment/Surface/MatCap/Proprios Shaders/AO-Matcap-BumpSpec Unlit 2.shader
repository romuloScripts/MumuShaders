// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "AO/Matcap Bumped Specular Unlit 2" {
	Properties {
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex("Textura",2D) = "white"{}
		_AO("AO",2D) = "white"{}
		_BumpMap ("Bumpmap (RGB)", 2D) = "bump" {}
		_MatCap ("MatCap (RGB)", 2D) = "white" {}
	}
	
	Subshader {
		//Tags { "RenderType"="Opaque" }
		//Fog { Color [_AddFog] }
		
		Pass {
			//Name "BASE"
			Tags {"LightMode" = "Always" "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
			//Tags { "LightMode" = "Always" }
			//ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
				//#pragma exclude_renderers xbox360
				#pragma vertex vert
				#pragma fragment frag
				//#pragma fragmentoption ARB_fog_exp2
				//#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"
				
				struct v2f { 
					float4 pos : SV_POSITION;
					float2	uv : TEXCOORD0;
					float3	TtoV0 : TEXCOORD1;
					float3	TtoV1 : TEXCOORD2;
				};
				
				uniform float4 _BumpMap_ST;
				
				v2f vert (appdata_tan v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos (v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord,_BumpMap);
					
					TANGENT_SPACE_ROTATION;
					o.TtoV0 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
					o.TtoV1 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
					return o;
				}
				
				uniform float4 _Color;
				uniform sampler2D _BumpMap;
				uniform sampler2D _MatCap;
				uniform sampler2D _MainTex;
				uniform sampler2D _AO;
				
				float4 frag (v2f i) : COLOR
				{
					float3 normal = UnpackNormal(tex2D(_BumpMap, i.uv));
					// normal = normalize(normal);
					
					half2 vn;
					vn.x = dot(i.TtoV0, normal);
					vn.y = dot(i.TtoV1, normal);
					
					float4 matcapLookup = tex2D(_MatCap, vn*0.5 + 0.5);
					float4 tex = tex2D(_MainTex, i.uv);
					float4 ao = tex2D(_AO, i.uv);
					matcapLookup.a = 1;
					
					float4 c = tex*ao*_Color*matcapLookup*2;
					
					return float4(c.r,c.g,c.b,tex.a*_Color.a);//tex*_Color*matcapLookup*2*tex.a;
				}
			ENDCG
		}
	}
	FallBack "AO/Bumped Diffuse"
}