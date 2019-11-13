// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Desaturar" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Multiplicador ("Multiplicador", Float) = 1.0
		_Inico ("Inicio", Float) = 0
		_Fim ("Fim", Float) = 1.0
		_Cor("Cor",Color) = (1,1,1,1)
		_Forca("Forca", Range(0,1)) = 1
	}
	SubShader 
	{
		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		
			uniform sampler2D _MainTex;
			uniform sampler2D _CameraDepthTexture;
			uniform half _Multiplicador;
			uniform half _Inicio;
			uniform half _Fim;
			uniform fixed4 _Cor;
			uniform fixed _Forca;
			
			struct v2f {
			   float4 pos : SV_POSITION;
			   float4 scrPos:TEXCOORD1;
			};
			
			v2f vert (appdata_base v){
			   v2f o;
			   o.pos = UnityObjectToClipPos (v.vertex);
			   o.scrPos=ComputeScreenPos(o.pos);
			   //o.scrPos.y = 1 - o.scrPos.y;
			   return o;
			}
			
			float4 frag(v2f IN) : COLOR{
   				fixed4 fragTex = tex2D(_MainTex, IN.scrPos.xy);
				float depthValue = Linear01Depth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(IN.scrPos)).r);
//				float depthValue = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, IN.scrPos.xy);
//				depthValue = Linear01Depth(depthValue);
   				half4 escalaCinza =  (fragTex.r+fragTex.b+fragTex.g)/3.0;
   				escalaCinza= lerp (fragTex,escalaCinza*_Cor,_Forca);
				if(depthValue == 1){
					return fragTex;
				}else
   					return lerp(fragTex,escalaCinza,smoothstep(_Inicio,_Fim,depthValue*_Multiplicador));
			}
			ENDCG
		} 
	}
}
