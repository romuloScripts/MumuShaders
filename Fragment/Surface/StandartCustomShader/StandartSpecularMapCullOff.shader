Shader "Custom/StandartSpecularMapCullOff" {
	 Properties
    {
        _MainTex ("Albedo, Metallic", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _BumpMap ("Normal", 2D) = "bump"{}
		_BumpScale("Scale", Range(0, 2)) = 1
		_Oclusion("AO", 2D) = "white" {}
		_OclusionScale ("AO scale", Range(0, 2)) = 1
		
        _Specular("Specular ", 2D) = "black" {}
        _SpecularScale ("Specular Scale", Range(0, 2)) = 1
        _Smoothness ("Smoothness ", 2D) = "black" {}
        _SmoothnessScale ("Smoothness Scale", Range(0, 2)) = 1
		_Emission ("Emission", Color) = (0, 0, 0, 0)
    }
    SubShader {
		Cull off
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM

        #pragma surface surf StandardSpecular fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _Oclusion;
        sampler2D _Specular;
        sampler2D _Smoothness;
        half _BumpScale;
        half4 _Color;
		half4 _Emission;
        half _SpecularScale;
        half _SmoothnessScale;
        half _OclusionScale;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _Color.rgb;
            o.Normal = UnpackScaleNormal(tex2D(_BumpMap, IN.uv_MainTex), _BumpScale);
            o.Specular = tex2D(_Specular, IN.uv_MainTex).rgb * _SpecularScale;
            o.Smoothness = tex2D(_Smoothness, IN.uv_MainTex).rgb * _SmoothnessScale;
            o.Occlusion =  lerp(1,tex2D(_Oclusion, IN.uv_MainTex),_OclusionScale) ;
			o.Emission = _Emission;
        }

        ENDCG
    } 
    FallBack "Diffuse"
}
