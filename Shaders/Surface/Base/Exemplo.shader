Shader "Custom/ExemploSurfaceShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert 
		//#pragma surface surfaceFunction lightModel [optionalparams]
		// surface shader, metodo e iluminaçao 
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		
//     outputs do surface shader
//		struct SurfaceOutput {
//    		half3 Albedo;
//    		half3 Normal;
//    		half3 Emission;
//    		half Specular;
//    		half Gloss;
//    		half Alpha;
//		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
