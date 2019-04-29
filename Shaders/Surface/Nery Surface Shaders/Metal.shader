// Shader criado por Marcelo Souza Nery
// Versao 1.0
// Data criaçao: 22/11/2013
// Ultima alteracao: 22/11/2013

Shader "Nery Shaders/Assets/Metal"
{
	Properties
	{
		_MainTint ("Cor", Color) = (0.5, 0.5, 0.5, 1.0)
		_MainTex ("Imagem base", 2D) = "white" {}
		_SpecularColor ("Cor do brilho", Color) = (1, 1, 1, 1)
		_Specular ("Quantidade de brilho", Range(0,1)) = 0.5
		_SpecPower ("Potencia do brilho", Range(0,1)) = 0.5
		_AnisoDir ("Direçao de anisotropia", 2D) = "" {}
		_AnisoOffset ("Offset da anisotropia", Range(-1,1)) = -0.2
		_CubeMap ("Relfexao do ambiente", CUBE) = "" {}
		_ReflectAmount ("Intensidade do ambiente", Range(0.01,1)) = 0.5
		_ReflectMask ("Mapa de reflexao", 2D) = "" {}
		_NormalMap ("Mapa de normais", 2D) = "" {}
		_NormalAmount ("Intesidade de normais", Range(0, 10)) = 0.5
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Anisotropic
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _AnisoDir;
		float4 _MainTint;
		float4 _SpecularColor;
		float _AnisoOffset;
		float _Specular;
		float _SpecPower;
		samplerCUBE _CubeMap;
		float _ReflectAmount;
		sampler2D _ReflectMask;
		sampler2D _NormalMap;
		float _NormalAmount;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_AnisoDir;
			float3 worldReflect;
			float2 uv_NormalMap;
		};
		
		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 AnisoDirection;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};
		
		inline fixed4 LightingAnisotropic (SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed3 halfVector = normalize (normalize(lightDir) + normalize(viewDir));
			float NdotL = saturate(dot(s.Normal, lightDir));
			
			fixed HdotA = dot(normalize(s.Normal + s.AnisoDirection), halfVector);
			float aniso = max(0, sin(radians((HdotA + _AnisoOffset) * 180)));
			
			float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);
			
			fixed4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec)) * (atten * 2);
			c.a = 1.0;
			return c;
		}

		void surf (Input IN, inout SurfaceAnisoOutput o)
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));
			float4 reflMask = tex2D(_ReflectMask, IN.uv_MainTex);
			float3 normals = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
			
			o.Normal = normals * _NormalAmount;
			o.Emission = texCUBE(_CubeMap, IN.worldReflect).rgb * _ReflectAmount * reflMask;
			o.AnisoDirection = anisoTex;
			o.Specular = _Specular * reflMask * _ReflectAmount;
			o.Gloss = _SpecPower * reflMask * _ReflectAmount;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	
	FallBack "Diffuse"
}
