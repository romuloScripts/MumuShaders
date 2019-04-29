Shader "Custom/bolha" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Cor2("Cor2",Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_OffSetEscudo( "OffSetEscudo", Float ) = 0
		_MultiplicadorEscudo( "MultiplicadortEscudo", Float ) = 1
		_Frequencia( "Frequencia do Pulso", Float ) = 60.0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
		LOD 200
		//Zwrite off
		
		CGPROGRAM
		#pragma surface surf Lambert alpha
		#pragma target 3.0


		sampler2D _MainTex;
		fixed4 _Color;
		half4 _Cor2;
		half _Frequencia;
		half _OffSetEscudo;
		half _MultiplicadorEscudo;

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
		};
		
		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = lerp(_Color,_Cor2,(sin(_Time.x *_Frequencia)*0.5) +0.5);
			float3 view = IN.viewDir;
			half NdorViewdir = 1 - saturate(dot(o.Normal,normalize(view)));
			o.Albedo = c.rgb;
			o.Alpha = (NdorViewdir-_OffSetEscudo)*_MultiplicadorEscudo * c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
