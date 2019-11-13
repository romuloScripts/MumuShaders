Shader "Custom/textureBlending" {
	Properties {
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_tex ("Texture Default", 2D) = "white" {}
		_texBlend ("Texture Blending", 2D) = "white" {}
		_texR ("Texture R", 2D) = "white" {}
		_texG ("Texture G", 2D) = "white" {}
		_texB ("Texture B", 2D) = "white" {}
		_texA ("Texture A", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma target 5.0
		#pragma surface surf Lambert

		sampler2D _AO;
		sampler2D _tex;
		sampler2D _texBlend;
		sampler2D _texR;
		sampler2D _texG;
		sampler2D _texB;
		sampler2D _texA;

		struct Input {
			float2 uv_AO;
			float2 uv_tex;
			float2 uv_texBlend;
			float2 uv_texR;
			float2 uv_texG;
			float2 uv_texB;
			float2 uv_texA;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 cAO = tex2D (_AO, IN.uv_AO);
			half4 c = tex2D (_tex, IN.uv_tex);
			half4 cm = tex2D (_texBlend, IN.uv_texBlend);
			half4 cr = tex2D (_texR, IN.uv_texR);
			half4 cg = tex2D (_texG, IN.uv_texG);
			half4 cb = tex2D (_texB, IN.uv_texB);
			half4 ca = tex2D (_texA, IN.uv_texA);
			c = lerp(c, cr, cm.r);
			c = lerp(c, cg, cm.g);
			c = lerp(c, cb, cm.b);
			c = lerp(c, ca, 1-cm.a);
			o.Albedo = cAO.rgb * c.rgb;
			//o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
