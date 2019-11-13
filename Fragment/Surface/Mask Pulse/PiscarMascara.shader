Shader "Custom/PiscaMascara" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_GreyTex("Textura Contraste (GreyScale)", 2D) = "white" {}
		_CorPulso("Cor do Pulso",Color) = (1,1,1,1)
		_Frequencia( "Frequencia do Pulso", Float ) = 60.0
		_EscalaCinzaBase("Escala de Cinza Base",Range(0,1)) = 0.1
		_AmplitudeMinima("Amplitude Minima",Range(0,1)) = 0.7
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		        // surface shader, metodo e iluminaçao 
		sampler2D _MainTex;
		sampler2D _GreyTex;
		fixed4 _CorPulso;
		fixed _EscalaCinzaBase;
		half _Frequencia;
		fixed _AmplitudeMinima;

		struct Input {
			float2 uv_MainTex;
			float2 uv_GreyTex;
		};

		void surf (Input IN, inout SurfaceOutput result) {
			half4 PixelOriginal = tex2D (_MainTex, IN.uv_MainTex).rgba;
			fixed PixelEscalaCinza = tex2D (_GreyTex, IN.uv_GreyTex).rgba;
			
			if(PixelEscalaCinza >= _EscalaCinzaBase){
				fixed SenoideY = (sin(_Time.x *_Frequencia)*0.5) +0.5;
				fixed AmplitudeNormalizada = SenoideY * (1 - _AmplitudeMinima)+ _AmplitudeMinima;
				result.Albedo = PixelOriginal + (_CorPulso.rgb * AmplitudeNormalizada);
			}else{
				result.Albedo = PixelOriginal.rgb;	
			}
			
			result.Alpha = PixelOriginal.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
