Shader "Custom/BoxMap" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TexScale ("Texture scale", Float) = 1
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader {
        Tags { "RenderType"="Opaque" "DisableBatching"="True" }
        LOD 200
   
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0
        sampler2D _MainTex;
        float _TexScale;
        struct Input {
            float3 worldPos;
            float3 worldNormal;
        };
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o) {
 
            // get scale from matrix
            float3 scale = float3(
                length(unity_WorldToObject._m00_m01_m02),
                length(unity_WorldToObject._m10_m11_m12),
                length(unity_WorldToObject._m20_m21_m22)
                );
 
            // get translation from matrix
            float3 pos = unity_WorldToObject._m03_m13_m23 / scale;
 
            // get unscaled rotation from matrix
            float3x3 rot = float3x3(
                normalize(unity_WorldToObject._m00_m01_m02),
                normalize(unity_WorldToObject._m10_m11_m12),
                normalize(unity_WorldToObject._m20_m21_m22)
                );
                
            // make box mapping with rotation preserved
            float3 map = mul(rot, IN.worldPos) + pos;
            float3 norm = mul(rot, IN.worldNormal);
 
            float3 blend = abs(norm) / dot(abs(norm), float3(1,1,1));
            float2 uv;
            if (blend.x > max(blend.y, blend.z)) {
                uv = map.yz;
            } else if (blend.z > blend.y) {
                uv = map.xy;
            } else {
                uv = map.xz;
            }
            fixed4 c = tex2D(_MainTex, uv * (1/_TexScale));
            o.Albedo = c.rgb * _Color;
 
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}