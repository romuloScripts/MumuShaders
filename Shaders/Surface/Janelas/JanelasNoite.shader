Shader "Custom/JanelaNoite" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_MainTex2 ("Base (RGB)", 2D) = "white" {}
	_Mascara ("Mascara", 2D) = "white" {}
	//_Illum ("Illumin (A)", 2D) = "white" {}
	_MascaraXYWH ("Mascara XYWH", Vector) = (0,0,1,1)
	_Multiplicador("Multiplicador",Float)=1
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 200
	
CGPROGRAM
#pragma target 3.0	
#pragma surface surf Lambert

sampler2D _MainTex;
//sampler2D _Illum;
sampler2D _Mascara;
sampler2D _MainTex2;
//sampler2D _Illum;
fixed4 _Color;
fixed4 _MascaraXYWH;
half _Multiplicador;

struct Input {
	float2 uv_MainTex;
	float2 uv_MainTex2;
	//float2 uv_Illum;
	//float2 uv_Mascara;
	float3 worldPos;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 tex2 = tex2D(_MainTex2, IN.uv_MainTex2);
	fixed4 corMas = tex2D(_Mascara, (IN.worldPos.xy - _MascaraXYWH.xy) / _MascaraXYWH.zw );
	corMas.r = -cos(corMas.r*3.14159)*0.5+0.5;
	corMas.r = -cos(corMas.r*3.14159)*0.5+0.5;
	fixed4  result = lerp(tex2,tex,corMas.r);
	fixed4 c = result * _Color;
	o.Albedo = c.rgb;
	o.Emission = c.rgb * corMas.r*_Multiplicador;
	o.Alpha = c.a;
}
ENDCG
} 
FallBack "Legacy Shaders/Self-Illumin/VertexLit"
CustomEditor "LegacyIlluminShaderGUI"
}
