Shader "Custom/StandartCustom"
{
    Properties
    {
        _MainTex ("Albedo, Metallic", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _BumpMap ("Normal", 2D) = "bump"{}
		_BumpScale("Scale", Range(0, 2)) = 1
		_Oclusion("AO", 2D) = "white" {}
		_OclusionScale ("AO scale", Range(0, 1)) = 1
		
        _MetallicBias ("Metallic Bias", Range(0, 1)) = 0
        _MetallicScale ("Metallic Scale", Range(0, 2)) = 0
        _SmoothnessBias ("Smoothness Bias", Range(0, 1)) = 0
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
        half _BumpScale;
        half4 _Color;
        half _MetallicBias;
        half _MetallicScale;
        half _SmoothnessBias;
        half _SmoothnessScale;
        half _OclusionScale;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Oclusion;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _Color.rgb;
            o.Normal = UnpackScaleNormal(tex2D(_BumpMap, IN.uv_MainTex), _BumpScale);
            o.Metallic = saturate(c.a * _MetallicScale + _MetallicBias);
            o.Smoothness = saturate(c.a * _SmoothnessScale + _SmoothnessBias);
            o.Occlusion =  lerp(1,tex2D(_Oclusion, IN.uv_Oclusion),_OclusionScale) ;
        }

        ENDCG
    } 
    FallBack "Diffuse"
}
