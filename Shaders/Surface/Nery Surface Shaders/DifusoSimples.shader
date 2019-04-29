// Shader criado por Marcelo Souza Nery
// Versao 1.0
// Data criaçao: 22/11/2013
// Ultima alteracao: 22/11/2013

// Difusao com "bidirectional reflectance distribution" (BDRF)

Shader "Nery Shaders/Assets/Difuso com BDRF"
{
	Properties
	{
		_MainTex ("Imagem base", 2D) = "white" {}
		_EmissiveColor ("Cor emitida", Color) = (1,1,1,1)
		_AmbientColor ("Cor ambiente", Color) = (1,1,1,1)
		_RampTex ("BDRF", 2D) = "white" {}
		
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BasicDiffuse

		sampler2D _MainTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
		sampler2D _RampTex;
		

		struct Input
		{
			float2 uv_MainTex;
		};
		
		inline float4 LightingBasicDiffuse (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed3 halfVector = normalize (normalize(lightDir) + normalize(viewDir));
			float NdotL = dot(s.Normal, lightDir);
			
			float difLight = dot (s.Normal, lightDir);
			float rimLight = dot(s.Normal, viewDir);
			
			float hLambert = difLight * 0.5 + 0.5;
			float3 ramp = saturate(tex2D(_RampTex, float2(hLambert, rimLight)).rgb);
			
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * NdotL * ramp * difLight * atten;
			col.a = s.Alpha;
			
			return col;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) + _EmissiveColor + _AmbientColor;
			c /= 3;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		ENDCG
	}

	FallBack "Diffuse"
}
