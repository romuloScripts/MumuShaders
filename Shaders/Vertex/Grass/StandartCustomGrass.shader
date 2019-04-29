Shader "Custom/StandartCustomPlanta"
{
    Properties
    {
        _MainTex ("Albedo, Metallic", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _BumpMap ("Normal", 2D) = "bump"{}
		_BumpScale("Scale", Range(0, 2)) = 1
		
        _MetallicBias ("Metallic Bias", Range(0, 1)) = 0
        _MetallicScale ("Metallic Scale", Range(0, 2)) = 0
        _SmoothnessBias ("Smoothness Bias", Range(0, 1)) = 0
        _SmoothnessScale ("Smoothness Scale", Range(0, 2)) = 1

		_Speed      ("Wave Speed", Range(0.1, 80)) = 2
	    _Length     ("Wave Length", Range(0,5)) = 2.6
	    _Amplitude  ("Wave Amplitude", Range(0,1)) = 0.3
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_Vento ("Vento", Vector) = (0 ,0 ,0 ,0)
	  
    }
    SubShader {
        Cull off
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
        
        CGPROGRAM
		#pragma vertex vert
        #pragma surface surf Lambert alphatest:_Cutoff  //fullforwardshadows

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

	  	half _Speed;
	    half _Length;
	    fixed _Amplitude;
	    float _Offset;
		float4 _Vento;


        struct Input
        {
            float2 uv_MainTex;
            float4 vertColor;
        };

		void vert(inout appdata_full v, out Input o){
						
			v.vertex.xyz += (v.normal * (v.color * _Length)  * sin( (_Time.y * _Speed) ) * _Amplitude) + (_Vento.xyz * (v.color * _Length) * (sin( _Time.y * _Vento.w)*0.5 + 0.5));
			//v.normal += v.normal * (v.color * _Length)  * sin( (_Time.y * _Speed) ) * _Amplitude;
			o.vertColor  = v.color;
			o.uv_MainTex = v.texcoord;
		}

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _Color.rgb;
            o.Normal = UnpackScaleNormal(tex2D(_BumpMap, IN.uv_MainTex), _BumpScale);
			o.Alpha = c.a;
            //o.Metallic = saturate(c.a * _MetallicScale + _MetallicBias);
            //o.Smoothness = saturate(c.a * _SmoothnessScale + _SmoothnessBias);
        }

        ENDCG
    } 
    FallBack "Diffuse"
}
