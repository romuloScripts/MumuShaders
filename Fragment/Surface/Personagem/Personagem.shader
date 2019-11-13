Shader "Custom/Personagem" {
    Properties {	
      _Color ("Main Color", Color) = (1,1,1,1)
      _MainTex ("Texture", 2D) = "white" {}
      _BumpMap ("Bumpmap", 2D) = "bump" {}
      _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
      _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
      _Cutoff ("Alpha cutoff", Range(0,0.9)) = 0.5
     // _Cube ("Cubemap", CUBE) = "" {}
    }
    SubShader {
      Cull Back
     	Tags
		{
			"Queue" = "AlphaTest"
			"IgnoreProjector" = "True"
			"RenderType" = "TransparentCutout"
		}
		//Blend SrcAlpha OneMinusSrcAlpha
      CGPROGRAM
      #pragma surface surf Lambert alphatest:_Cutoff
      //#pragma surface surf Lambert
      struct Input {
          float2 uv_MainTex;
          float2 uv_BumpMap;
          float3 viewDir;
         // float3 worldRefl;
      };
      fixed4 _Color;
      sampler2D _MainTex;
      sampler2D _BumpMap;
      float4 _RimColor;
      float _RimPower;
     // samplerCUBE _Cube;
      void surf (Input IN, inout SurfaceOutput o) {
          fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
          o.Albedo = c.rgb;
          o.Alpha = c.a;
          o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
          half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
          o.Emission = _RimColor.rgb * pow (rim, _RimPower);
      }
      ENDCG
      	Cull Front
      	CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff
		sampler2D _MainTex;
		fixed4 _Color;
	
		struct Input
		{
			float2 uv_MainTex;
		};
	
		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex)* _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
    } 
    Fallback "Diffuse"
}
