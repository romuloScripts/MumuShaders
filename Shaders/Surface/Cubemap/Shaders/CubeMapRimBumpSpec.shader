// PONTIFICIA UNIVERSIDADE CATOLICA DE MINAS GERAIS
// JOGOS DIGITAIS
// Eduardo Fantini
//
// Especular, Emissao de Cubemap, Rim e Bump

Shader "PUCMINAS_JOGOS/CubeMapRimBumpSpec" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump" {}
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_Cubemap ("Cubemap", CUBE) = "" {}
		_EmissionAmount("Emission Amount", Range(0,1)) = 1
		_FresnelFalloff ("Fresnel Falloff", Range(0.1, 8.0)) = 2
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecNS ("Specular Concentration", float) = 0.5
		_Gloss ("Gloss", float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;
		float4 _MainTint;
		samplerCUBE _Cubemap;
		fixed _EmissionAmount;
		half _FresnelFalloff;
		half _SpecNS;
		half _Gloss;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 viewDir;
			float3 worldRefl;			
			INTERNAL_DATA // habilita World Reflection
		};

		void surf (Input IN, inout SurfaceOutput o) {
		
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 normals = UnpackNormal(tex2D(_Bump, IN.uv_Bump)).rgb;
			o.Normal = normals;
			
			float InvNdotView = 1 - saturate(dot(o.Normal, normalize(IN.viewDir)));
			float rimEffect = pow( InvNdotView, _FresnelFalloff);
			
			o.Albedo = c.rgb * _MainTint;
			o.Emission = _EmissionAmount * (texCUBE(_Cubemap, WorldReflectionVector(IN, o.Normal)).rgb * rimEffect);
			o.Specular = _SpecNS;
			o.Gloss = _Gloss;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
