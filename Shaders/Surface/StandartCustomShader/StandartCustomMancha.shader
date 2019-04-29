Shader "Custom/StandartCustomMancha"
{
    Properties
    {
        _MainTex ("Albedo, Metallic", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _BumpMap ("Normal", 2D) = "bump"{}
		_BumpScale("Scale", Range(0, 2)) = 1
		_Oclusion("AO", 2D) = "white" {}
		_OclusionScale ("AO scale", Range(0, 1)) = 1
		_Mancha("Mancha", 2D) = "white" {}
		_ManchaScale ("Mancha scale", Range(0, 1)) = 1
		_Mancha2("Mancha2", 2D) = "white" {}
		_ManchaScale2("Mancha2 scale", Range(0, 1)) = 1
		
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
        sampler2D _Mancha;
 		sampler2D _Mancha2;
        half _BumpScale;
        half4 _Color;
        half _MetallicBias;
        half _MetallicScale;
        half _SmoothnessBias;
        half _SmoothnessScale;
        half _OclusionScale;
        half _ManchaScale;
        half _ManchaScale2;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Oclusion;
            float2 uv_Mancha;
            float2 uv_Mancha2;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = saturate((c.rgb + c.rgb) * _Color.rgb) 
            			* lerp(1,tex2D(_Mancha, IN.uv_Mancha),_ManchaScale) 
            			* lerp(1,tex2D(_Mancha2, IN.uv_Mancha2),_ManchaScale2);
            o.Normal = UnpackScaleNormal(tex2D(_BumpMap, IN.uv_MainTex), _BumpScale);
            o.Metallic = saturate(c.a * _MetallicScale + _MetallicBias);
            o.Smoothness = saturate(c.a * _SmoothnessScale + _SmoothnessBias);
            o.Occlusion =  lerp(1,tex2D(_Oclusion, IN.uv_Oclusion),_OclusionScale) ;
        }

        ENDCG
    } 
    FallBack "Diffuse"
}
