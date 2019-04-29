Shader "Custom/Terreno" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Agua ("Agua (RGB)", 2D) = "white" {}
		_Areia ("Areia (RGB)", 2D) = "white" {}
		_Grama ("Grama (RGB)", 2D) = "white" {}
		_Rocha ("Rocha (RGB)", 2D) = "white" {}
		_Vel ("Velocidade X", Vector) = (0,0,0,0)
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma target 4.0
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _Agua;
		sampler2D _Areia;
		sampler2D _Grama;
		sampler2D _Rocha;
		fixed4 _Vel;
		

		struct Input {
			float2 uv_MainTex;
			float2 uv_Agua;
			float2 uv_Areia;
			float2 uv_Grama;
			float2 uv_Rocha;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 corFinal = (1-c.a)* tex2D (_Agua, IN.uv_Agua+=_Time.x*_Vel.xy);
			corFinal+= (c.a)*(c.r)*tex2D (_Areia, IN.uv_Areia);
			corFinal+= (c.a)*(c.g)*tex2D (_Grama, IN.uv_Grama);
			corFinal+= (c.a)*(c.b)*tex2D (_Rocha, IN.uv_Rocha);
			
			
			corFinal = saturate(corFinal);
			o.Albedo = corFinal.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
