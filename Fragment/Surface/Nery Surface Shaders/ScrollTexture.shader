Shader "Nery Shaders/Assets/ScrollTexture"
{
	Properties
	{
		_MainTint ("Cor", Color) = (1,1,1,1)
		_MainTex ("Imagem base", 2D) = "white" {}
		_ScrollXSpeed ("Velocidade X", Range(0,10)) = 2
		_ScrollYSpeed ("Velocidade Y", Range(0,10)) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		
		fixed4 _MainTint;
		sampler2D _MainTex;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed2 scrolledUV = IN.uv_MainTex;
			
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;
			
			scrolledUV += fixed2(xScrollValue, yScrollValue);
			
			half4 c = tex2D (_MainTex, scrolledUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
