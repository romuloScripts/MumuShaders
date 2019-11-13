Shader "Custom/WorldCoord Transparent Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_BaseScale ("Base Tiling", Vector) = (1,1,1,0)
	//_multiplicar("Multiplicar Cor",Range(1,50)) = 1
	//_BumpMap ("Normalmap", 2D) = "bump" {}
	_Cutoff ("Alpha cutoff", Range(0,0.9)) = 0.5
}

SubShader {
	Tags { 
		"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"
	}
	LOD 200

CGPROGRAM
#pragma surface surf Lambert alphatest:_Cutoff

sampler2D _MainTex;

fixed4 _Color;
fixed3 _BaseScale;
//half _multiplicar;
//sampler2D _BumpMap;

struct Input {
	float2 uv_MainTex;
	float3 worldPos;
	float3 worldNormal;
	//float2 uv_BumpMap;

};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 texXY = tex2D(_MainTex, IN.worldPos.xy * _BaseScale.z);// IN.uv_MainTex);
	fixed4 texXZ = tex2D(_MainTex, IN.worldPos.xz * _BaseScale.y);// IN.uv_MainTex);
	fixed4 texYZ = tex2D(_MainTex, IN.worldPos.zy * _BaseScale.x);// IN.uv_MainTex);
	fixed3 mask = fixed3(
		dot (IN.worldNormal, fixed3(0,0,1)),
		dot (IN.worldNormal, fixed3(0,1,0)),
		dot (IN.worldNormal, fixed3(1,0,0)));
	
	fixed4 tex = 
		texXY * abs(mask.x) +
		texXZ * abs(mask.y) +
		texYZ * abs(mask.z);
	fixed4 c = tex * _Color;
	//fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;// * _multiplicar;
	o.Alpha = c.a;
	//o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
}
ENDCG
}

Fallback "Diffuse"
//Fallback "Transparent/Cutout/VertexLit"
}
