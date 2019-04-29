Shader "Nery Shaders/Assets/Contrast"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_inGamma ("Input Gamma", Range(0,2)) = 1.61
	
		_inBlack ("Input Black", Range(0,255)) = 0
		_inWhite ("Input White", Range(0,255)) = 255
		
		_outBlack("Output Black", Range(0,255)) = 0
		_outWhite("Output White", Range(0,255)) = 255
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _inBlack, _inGamma, _inWhite, _outBlack, _outWhite;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			float outRPixel = (c.r * 255.0);
			float outGPixel = (c.r * 255.0);
			float outBPixel = (c.r * 255.0);
			
			outRPixel = max(0, outRPixel - _inBlack);
			outRPixel = saturate(pow(outRPixel / (_inWhite - _inBlack), _inGamma));
			outRPixel = (outRPixel * (_outWhite - _outBlack) + _outBlack) / 255.0;
			
			outGPixel = max(0, outGPixel - _inBlack);
			outGPixel = saturate(pow(outGPixel / (_inWhite - _inBlack), _inGamma));
			outGPixel = (outGPixel * (_outWhite - _outBlack) + _outBlack) / 255.0;
			
			outBPixel = max(0, outBPixel - _inBlack);
			outBPixel = saturate(pow(outBPixel / (_inWhite - _inBlack), _inGamma));
			outBPixel = (outBPixel * (_outWhite - _outBlack) + _outBlack) / 255.0;
			
			fixed4 cor = float4(outRPixel, outRPixel, outRPixel, c.a);
			
			o.Albedo = cor;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
