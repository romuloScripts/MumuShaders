Shader "Custom/ObjetosAgua" {
	        Properties {
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _NormalMap ("Normalmap", 2D) = "bump" {}
            _CausticTex ("Textura Causitc", 2D) = "gray" {}
            _Color ("Color", color) = (1,1,1,0)
            _PosYAgua("Pos Y Agua",Float) =0
        }
        SubShader {
            Tags { "RenderType"="Opaque" }
            LOD 300
            
            CGPROGRAM
            #pragma surface surf Lambert addshadow fullforwardshadows nolightmap
            #pragma target 3.0

            sampler2D _CausticTex;
            float _PosYAgua;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            fixed4 _Color;

            struct Input {
                float2 uv_MainTex;
                float3 worldPos;
                INTERNAL_DATA
            };

            void surf (Input IN, inout SurfaceOutput o) {
                half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
                o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
                fixed dis = _PosYAgua-IN.worldPos.y;
                if(_PosYAgua > IN.worldPos.y ){
                	half4 c2 = tex2D (_CausticTex, IN.uv_MainTex+_Time.x);
                	half4 c3 = tex2D (_CausticTex, IN.uv_MainTex-_Time.x);
                	o.Albedo = lerp(c.rgb,lerp(c3.rgb,c2.rgb,0.5),saturate(lerp(1,0,dis)/2));
                }else
                	 o.Albedo = c.rgb;
            }
            ENDCG
        }
        FallBack "Diffuse"
    }