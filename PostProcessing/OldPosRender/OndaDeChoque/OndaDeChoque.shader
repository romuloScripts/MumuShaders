// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/OndaDeChoque" {
		Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Speed      ("Wave Speed", Range(0.1, 80)) = 2
	    _Amplitude  ("Wave Amplitude", Range(0,1)) = 0.3
	    _transicao ("Transicao",Range(0,1)) = 1
	    _x  ("X", Range(0,1)) = 0.5
	    _y  ("Y", Range(0,1)) = 0.5
	           
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
			uniform half _Speed;    
	    	uniform half _Amplitude;
	    	uniform half _x;  
	    	uniform half _y;
	    	uniform half _transicao;    

			uniform sampler2D _Tx1;
			
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
			
			float2 uv = IN.scrPos;
    		uv.x *= _ScreenParams.x / _ScreenParams.y;
			
			float2 waveHeight = uv.xy;
			_x *= _ScreenParams.x / _ScreenParams.y;
			half4 x = waveHeight.x-_x;
			half4 y = waveHeight.y-_y;
		  	float dis = sqrt(x*x+y*y);
	
		  	fixed4 fragTex; 
		  	fixed resul = saturate(cos((_Time.y * _Speed) + _Amplitude*dis));
		  	if(resul > 0.5 ){
		  		waveHeight.x += smoothstep(0.5,1,resul)/10;
		  		waveHeight.y += smoothstep(0.5,1,resul)/10;
		  		fragTex = tex2D(_MainTex, waveHeight);
		  	}else{
		  		fragTex = tex2D(_Tx1, IN.scrPos);
		  	}
		  	//fixed4 tex = tex2D(_MainTex, IN.scrPos);
			fragTex = lerp(tex2D(_MainTex, IN.scrPos),fragTex,_transicao * smoothstep(0.1,0.25,dis));
			return fragTex;
			}
			ENDCG
		} 
	}
}
