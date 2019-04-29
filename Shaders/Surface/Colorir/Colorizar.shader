Shader "Custom/Colorizar" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_paleta ("paleta", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Unlit

		half4 LightingUnlit (SurfaceOutput s, half3 lightDir, half atten) {
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		sampler2D _MainTex;
		sampler2D _paleta;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			if (c.r > 0)
				c = tex2D(_paleta, float2(c.r, 0.8));
			else if (c.g > 0)
				c = tex2D(_paleta, float2(c.g, 0.6));
			else if (c.b > 0)
				c = tex2D(_paleta, float2(c.b, 0.4));
			o.Albedo = c.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
