Shader "Custom/StandartMetalSpecularMap" {
	Properties
    {
        _MainTex ("Albedo, Metallic", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _BumpMap ("Normal", 2D) = "bump"{}
		_BumpScale("Scale", Range(0, 2)) = 1
		_Oclusion("AO", 2D) = "white" {}
		_OclusionScale ("AO scale", Range(0, 1)) = 1
		
        _Metallic("Metallic ", 2D) = "black" {}
        _MetallicScale ("Metallic Scale", Range(0, 2)) = 1
        _Smoothness ("Smoothness ", 2D) = "black" {}
        _SmoothnessScale ("Smoothness Scale", Range(0, 2)) = 1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _Oclusion;
        sampler2D _Metallic;
        sampler2D _Smoothness;
        half _BumpScale;
        half4 _Color;
        half _MetallicScale;
        half _SmoothnessScale;
        half _OclusionScale;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _Color.rgb;
            o.Normal = UnpackScaleNormal(tex2D(_BumpMap, IN.uv_MainTex), _BumpScale);
            o.Metallic =  tex2D(_Metallic, IN.uv_MainTex) *_MetallicScale;
            o.Smoothness = tex2D(_Smoothness, IN.uv_MainTex) * _SmoothnessScale;
            o.Occlusion =  lerp(1,tex2D(_Oclusion, IN.uv_MainTex),_OclusionScale) ;
        }

        ENDCG
    } 
    FallBack "Diffuse"
}
