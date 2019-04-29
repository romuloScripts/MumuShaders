Shader "Custom/Terreno" {
        Properties {
            _EdgeLength ("Edge length", Range(2,50)) = 5
            _Phong ("Phong Strengh", Range(0,1)) = 0.5
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _DispTex ("Disp Texture", 2D) = "gray" {}
            _NormalMap ("Normalmap", 2D) = "bump" {}
            _CausticTex ("Textura Causitc", 2D) = "gray" {}
            _Displacement ("Displacement", Range(0, 3.0)) = 0.3
            _Color ("Color", color) = (1,1,1,0)
            _SpecColor ("Spec color", color) = (0.5,0.5,0.5,0.5)
            _PosYAgua("Pos Y Agua",Float) =0
        }
        SubShader {
            Tags { "RenderType"="Opaque" }
            LOD 300
            
            CGPROGRAM
            #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessEdge tessphong:_Phong nolightmap
            #include "Tessellation.cginc"
            #pragma target 5.0

            struct appdata {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };
            
			float _Phong;
            float _EdgeLength;

            float4 tessEdge (appdata v0, appdata v1, appdata v2)
            {
                return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
            }

            sampler2D _DispTex;
            sampler2D _CausticTex;
            float _Displacement;
           // float _Displacement;
           // float _Caustic;
            float _PosYAgua;

            void disp (inout appdata v)
            {
                float d = tex2Dlod(_DispTex, float4(v.texcoord.xy,0,0)).r * _Displacement;
                v.vertex.xyz += v.normal * d;
            }

            struct Input {
                float2 uv_MainTex;
                float3 worldPos;
            };

            sampler2D _MainTex;
            sampler2D _NormalMap;
            fixed4 _Color;

            void surf (Input IN, inout SurfaceOutput o) {
                half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
                if(_PosYAgua > IN.worldPos.y){
                	half4 c2 = tex2D (_CausticTex, IN.uv_MainTex+_Time.x);
                	half4 c3 = tex2D (_CausticTex, IN.uv_MainTex-_Time.x);
                	fixed dis = abs(_PosYAgua-IN.worldPos.y);
                	o.Albedo = lerp(c.rgb,lerp(c3.rgb,c2.rgb,0.5),saturate(lerp(0,0.6,dis)));
                }else
                	 o.Albedo = c.rgb;
                o.Specular = 0.2;
                o.Gloss = 1.0;
                o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            }
            ENDCG
        }
        FallBack "Diffuse"
    }

