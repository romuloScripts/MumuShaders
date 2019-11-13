Shader "Custom/Double_Sided_Alpha2"
{
	Properties
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_ColorTint ("Tint", Color) = (0.5, 0.5, 0.5, 1.0)
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		Cull Off

		CGPROGRAM
		#pragma surface surf IgnoreNormal 
		//alphatest:_Cutoff
		
		sampler2D _MainTex;
		fixed4 _ColorTint;
		fixed _Cutoff;
		
		struct Input
		{
			float2 uv_MainTex;
		};

		half4 LightingIgnoreNormal(SurfaceOutput s, half3 lightDir, half atten)
		{
			half NdotL = dot (s.Normal, lightDir);
            half4 c;
            c.rgb = saturate(s.Albedo * _LightColor0.rgb * abs(NdotL) * atten * 2);
            return c;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _ColorTint;
			
			if (c.a < _Cutoff) 
			{
               discard; // descarta o pixel
            }            
            
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}