Shader "Custom/Terreno" {
	Properties {
		_MainTex ("Main Tex (RGB)", 2D) = "white" {}
		_Grama ("Grama", 2D) = "white" {}
		_Rocha ("Rocha (RGB)", 2D) = "white" {}
		_Terra ("Terra (RGB)", 2D) = "white" {}
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_Intencidade ("Intencidade Main Tex", Range(0,1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma exclude_renderers gles
		#pragma surface surf Lambert
		#pragma vertex vert
		#pragma target 4.0	
		sampler2D _MainTex;
		sampler2D _Rocha;
		sampler2D _Terra;
		sampler2D _AO;
		sampler2D _Grama;
		half4 _Color;
		fixed _Intencidade;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Rocha;
			float2 uv_Terra;
			float2 uv_AO;
			float2 uv_Grama;
			float3 vertColor;
		};
		
		void vert(inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.vertColor  = v.color;
			o.uv_MainTex = v.texcoord;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half3 c = IN.vertColor;
			half4 corFinal = (c.g)*tex2D (_Grama, IN.uv_Grama);
			corFinal+= (c.r)*tex2D (_Terra, IN.uv_Terra);
			corFinal+= (c.b)*tex2D (_Rocha, IN.uv_Rocha);
			half4 ao = tex2D (_AO, IN.uv_AO);
			half4 corDefault = tex2D (_MainTex, IN.uv_MainTex);
			corFinal = saturate(corFinal)*ao*lerp((1,1,1,1),corDefault,_Intencidade)+_Color;
			o.Albedo = corFinal.rgb;
			o.Alpha = 1;
			 
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
