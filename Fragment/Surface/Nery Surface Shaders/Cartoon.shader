// Shader criado por Marcelo Souza Nery
// Versao 1.0
// Data criaçao: 21/11/2013
// Ultima alteracao: 21/11/2013

Shader "Nery Shaders/Assets/Cartoon"
{
	// Propriedades do shader
	Properties
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Ramp ("Toon Ramp (RGB)", 2D) = "gray" {}
		_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
      	_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
	}

	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf ToonRamp

		sampler2D _Ramp;
sampler2D _MainTex;
float4 _Color;

struct Input {
	float2 uv_MainTex : TEXCOORD0;
	float3 viewDir;
};

float4 _RimColor;
float _RimPower;

		// custom lighting function that uses a texture ramp based
// on angle between light direction and normal
#pragma lighting ToonRamp exclude_path:prepass
inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
{
	#ifndef USING_DIRECTIONAL_LIGHT
	lightDir = normalize(lightDir);
	#endif
	
	half d = dot (s.Normal, lightDir)*0.5 + 0.5;
	half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
	
	half4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
	c.a = s.Alpha;

	return c * _Color;
}




void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;;//c.rgb;
	o.Alpha = c.a;
	
	half rim = 1.2 - saturate(dot (normalize(IN.viewDir), o.Normal));

  	o.Emission = _RimColor.rgb * pow (rim, _RimPower);
}
ENDCG
	} 

	Fallback "Diffuse"
}
