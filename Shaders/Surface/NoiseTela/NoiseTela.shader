Shader "Custom/NoiseTela" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Noise ("Noise", 2D) = "white" {}
		_EscalaCinza("Escala de Cinza",Range(0,1)) = 0.1
		_vel ("Velocidade", Vector) = (1, 1, 0.1, 0.1)
		//_ForcaNoise("ForcaNoise",Range(0,10)) = 1
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _Noise;
		fixed _EscalaCinza;
		fixed4 _vel;
		//fixed _ForcaNoise;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Noise;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 n = tex2D (_Noise, IN.uv_Noise+ _Time.x*_vel.xy);
			c = lerp(c,n*n,_EscalaCinza);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
