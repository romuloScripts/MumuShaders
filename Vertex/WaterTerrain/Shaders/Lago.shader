 Shader "Custom/Lago" {
        Properties {
            _EdgeLength ("Edge length", Range(2,50)) = 5
            _Phong ("Phong Strengh", Range(0,1)) = 0.5
            _Displacement ("Displacement", Range(0, 1.0)) = 0.3
            _TilingDispTex ("Tiling da textura de displace", Float) = 1
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _DispTex ("Disp Texture", 2D) = "gray" {}
            _NormalMap ("Normalmap", 2D) = "bump" {}
            _Color ("Color", color) = (1,1,1,0)
            _Spec ("Especularidade", Float) = 1
            _Gloss ("Gloss", Float) = 1
            _SpecColor ("Spec color", color) = (0.5,0.5,0.5,0.5)
            _EmissionAmount("Emission Amount", Range(0,1)) = 1
            _Cubemap ("Cubemap", CUBE) = "" {}
            _HeightMapTer("_Height Map Terreno (RGB)", 2D) = "white" {}
            _BordaTex("Textura da borda (RGB)", 2D) = "white" {}
            _EscalaBorda("Escala da Borda", Range(0,1)) = 0
            _EscalaBordaMax("Escala da Borda Max", Range(0,1)) = 1
            _EscalaBordaMin("Escala da Borda Min", Range(-1,1)) = 0
            _PosYTer("Pos Y Terreno",Float)=0
            _DispTer("DisplaceTerreno",Float)=0
            
        }
        SubShader {
            Tags { "RenderType"="Transparent"}
            LOD 300
            CGPROGRAM
            #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:vert tessellate:tessEdge tessphong:_Phong nolightmap alpha:blend
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
            sampler2D _BordaTex;
            sampler2D _HeightMapTer;
            float _Displacement;
            fixed _Spec;
            fixed _Gloss;
            samplerCUBE _Cubemap;
            fixed _EmissionAmount;
            fixed _EscalaBorda;
            fixed _EscalaBordaMax;
            fixed _EscalaBordaMin;
            float _TilingDispTex;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            fixed4 _Color;
            float _PosYTer;
            half _DispTer;
            
             struct Input {
                float2 uv_MainTex;
                float2 uv_BordaTex;
                float2 uv_HeightMapTer;
                float3 worldRefl;
                INTERNAL_DATA
            };

            void vert (inout appdata v){
               float d = tex2Dlod(_DispTex, float4(v.texcoord.xy*_TilingDispTex+_Time.x,0,0)).r * _Displacement;
               v.vertex.xyz += v.normal * d;
            }

            void surf (Input IN, inout SurfaceOutput o){
                half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
                half4 c2 = tex2D (_BordaTex, IN.uv_BordaTex);
                half4 c3 = tex2D (_HeightMapTer, IN.uv_HeightMapTer);
              	fixed escalaCinza = (c3.r+c3.b+c3.g)/3;
                if(escalaCinza >_EscalaBorda){
                	fixed borda = smoothstep(_EscalaBorda-_EscalaBordaMin,_EscalaBorda+_EscalaBordaMax,escalaCinza); 
                	o.Albedo = lerp(c.rgb,c2.rgb,borda);
                	o.Alpha = lerp(_Color.a,1,borda);
           			//o.Alpha= fmod(o.Alpha, 1);
               }else{
                	o.Albedo = c.rgb;
                	o.Alpha = _Color.a;
                }
                o.Specular = _Spec;
                o.Gloss = _Gloss;
                o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
                o.Emission = _EmissionAmount * (texCUBE(_Cubemap, IN.worldRefl).rgb);
            }
            ENDCG
        }
        FallBack "Diffuse"
    }