Shader "Nery Shaders/Assets/Gamma" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_inBlack("input black",Range(0,255))=0
		_inGamma("input gamma",float)=1
		_inWhite("input white",Range(0,255))=255

		_outWhite("out white",Range(0,255))=255
		_outBlack("out black",Range(0,255))=0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert
		float _inBlack;
		float _inGamma;
		float _inWhite;
		float _outWhite;
		float _outBlack;

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};


		float getPixel(float color)
		{

			float outRPixel;
			outRPixel=color*255.0;
			outRPixel=max(0,outRPixel-_inBlack);

			outRPixel=saturate(pow(outRPixel/(_inWhite-_inBlack),_inGamma));

			outRPixel=((outRPixel*(_outWhite-_outBlack))+_outBlack)/255.0;
			return outRPixel;
		}

		void surf (Input IN, inout SurfaceOutput o) {


			float4 outColor;
			float4 c = tex2D (_MainTex, IN.uv_MainTex);

			outColor.r= getPixel(c.r);
			outColor.g= getPixel(c.g);
			outColor.b= getPixel(c.b);
			outColor.a= getPixel(c.a);


			o.Albedo = outColor.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}