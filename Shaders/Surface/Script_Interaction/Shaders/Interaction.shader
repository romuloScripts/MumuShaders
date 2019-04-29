Shader "Custom/Interaction" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {TexGen EyeLinear}
		_MainTint ("Difuse Tint", Color) = (1,1,1,1)		
		_ScrollXSpeed ("X Scroll Speed", Range(-10, 10)) = 0
		_ScrollYSpeed ("Y Scroll Speed", Range(-10, 10)) = 0
		_Multi ("Multi", Float) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 500
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed4 _MainTint;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
		fixed _Multi;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed2 scrolledUV = IN.uv_MainTex;
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;
			
			scrolledUV += fixed2(xScrollValue, yScrollValue);

			half4 c = tex2D (_MainTex, scrolledUV);
			o.Albedo = c.rgb + _MainTint*_Multi;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
