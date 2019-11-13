// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Deserto" {
		Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Multiplicador ("Multiplicador", Float) = 1.0
		_Inico ("Inicio", Float) = 0
		_Fim ("Fim", Float) = 1.0
//		_Cor("Cor",Color) = (1,1,1,1)
//		_Forca("Forca", Range(0,1)) = 1
		_Speed      ("Wave Speed", Range(0.1, 80)) = 2
	    _Length     ("Wave Length", Range(1,5)) = 2.6
	    _Amplitude  ("Wave Amplitude", Range(0,1)) = 0.3
	    _OffsetY    ("Wave Offset Y", Range(0,1)) = 0.1
	    _FimY ("FimY", Float) = 1.0
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
			uniform half _Speed;    
	    	uniform half _Length;    
	    	uniform half _Amplitude;  
	    	uniform fixed _OffsetY;
			uniform half _Multiplicador;
			uniform half _Inicio;
			uniform half _Fim;
			uniform half _FimY;
//			uniform fixed4 _Cor;
//			uniform fixed _Forca;
			
			struct v2f {
			   float4 pos : SV_POSITION;
			   float4 scrPos:TEXCOORD1;
			};
			
			v2f vert (appdata_base v){
			   v2f o;
			   o.pos = UnityObjectToClipPos (v.vertex);
			   o.scrPos=ComputeScreenPos(o.pos);
			   return o;
			}
			
			float4 frag(v2f IN) : COLOR{
				float depthValue = Linear01Depth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(IN.scrPos)).r);
				depthValue = smoothstep(_Inicio,_Fim,depthValue*_Multiplicador);
				
   				float2 waveHeight = IN.scrPos.xy;
				if(IN.scrPos.y > _OffsetY ){
					fixed peso = smoothstep(_OffsetY,_FimY,IN.scrPos.y);
					fixed peso3 = 1 - smoothstep(_FimY,1,IN.scrPos.y);
					fixed peso2 =  smoothstep(0.5,0.4,abs(IN.scrPos.x - 0.5));// 1- abs(IN.scrPos.x - 0.5)*2;
				  	waveHeight.x += sin( (_Time.y * _Speed) + waveHeight.y * _Length ) * _Amplitude * peso*peso3*peso2*depthValue;			  
				}
   				
   				fixed4 fragTex = tex2D(_MainTex, waveHeight);
				return fragTex;
			}
			ENDCG
		} 
	}
}
