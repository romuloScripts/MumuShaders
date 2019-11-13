Shader "Nery Shaders/Camera/Letterbox" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Top ("Top Bar", Range(0.0,1.0)) = 1.0
		_Bottom ("Bottom Bar", Range(0.0,1.0)) = 1.0
		_Color("Base(RGB)", Color) = (1,1,1,1)
	}
	SubShader 
	{
		Pass
		{
		
		CGPROGRAM
		#pragma vertex vert_img
		#pragma fragment frag
		#pragma target 3.0
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform float4 _Color;
		uniform float _Top;
		uniform float _Bottom;
		
		float4 frag(v2f_img i) : COLOR
		{
			float4 screen = tex2D(_MainTex, i.uv);
			float4 bars;
			bars.y = i.uv.y;
			screen.xyz = (bars.y > _Bottom && bars.y < _Top) ? screen.xyz : 0.0;
			return screen;
			
		
		}

		ENDCG
		} 
	}
}