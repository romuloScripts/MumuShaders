Shader "Custom/JequiBarro"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_Degrade ("Degrade (RGB)", 2D) = "gray" {}
		_Cor ("Cor", Color) = (0.0,0.0,0.0,0.0)
      	_IntensidadeLuz ("Intensidade Luz", Range(0.1,9.0)) = 5.0
      	_DirecaoLuz ("Direcao Luz", Range(-2.0, 2.0)) = 1.0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf ToonRamp
		#pragma lighting ToonRamp exclude_path:prepass
//		#ifndef USING_DIRECTIONAL_LIGHT
//		#endif

		sampler2D _Degrade;
        sampler2D _MainTex;
        float4 _Color;
        float _DirecaoLuz;
        float4 _Cor;
        float _IntensidadeLuz;

   struct Input {
	float2 uv_MainTex : TEXCOORD0;
	float3 viewDir;
};

inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
{
	
	lightDir = normalize(lightDir);
	
	half deg = dot (s.Normal, lightDir)*0.4 + 0.4;
	half3 Degrade = tex2D (_Degrade, float2(deg,deg)).rgb;
	
	half4 cor;
	cor.rgb = s.Albedo * _LightColor0.rgb * Degrade * (atten * 1);
	cor.a = s.Alpha;

	return cor * _Color;
	
	//void surf (Input IN, inout SurfaceOutput o) {
          //fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
          //o.Albedo = c.rgb;
          //o.Alpha = c.a;
          //o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
          //half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
          //o.Emission = _RimColor.rgb * pow (rim, _RimPower);
}

void surf (Input IN, inout SurfaceOutput o) {
	half4 cor = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
	o.Alpha = cor.a;
	
	half sat = _DirecaoLuz - saturate(dot (normalize(IN.viewDir), o.Normal));

  	o.Emission = _Cor.rgb * pow (sat, _IntensidadeLuz);
}
ENDCG
	} 

	Fallback "Diffuse"
}

