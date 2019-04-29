Shader "Custom/Personagem2" {
	Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
	_Shininess ("Shininess", Range (0.01, 3)) = 1.5
	_Gloss("Gloss", Range (0.00, 1)) = .5
	_Reflection("Reflection", Range (0.00, 1)) = 0.5
	_Cube ("Reflection Cubemap", Cube) = "Black" { TexGen CubeReflect }
	_FrezPow("Fresnel Reflection",Range(0,2)) = .25
	_FrezFalloff("Fresnal/EdgeAlpha Falloff",Range(0,10)) = 4
	_Metalics("Metalics",Range(0,1)) = .5
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	
	_MainTex ("Diffuse(RGB) Alpha(A)",2D) = "White" {}
	_BumpMap ("Normalmap", 2D) = "Bump" {}
	_Spec_Gloss_Reflec_Masks ("Spec(R) Gloss(G) Reflec(B)",2D) = "White" {}

	
}

	SubShader {
		
		
		// Zprime Front Faces
		Pass {
		Tags {"Queue" = "Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "LightMode" = "Always"}
			zwrite on Cull back
			colormask 0
			Lighting Off
			Alphatest Greater [_Cutoff]
			SetTexture [_MainTex] { combine texture }
		} 

		// Front Faces
		Tags {"Queue" = "Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		UsePass "Hidden/Hardsurface Pro Front Cut Out Specular/FORWARD"
		
		Cull Front
      	CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff
		sampler2D _MainTex;
		fixed4 _Color;
	
		struct Input
		{
			float2 uv_MainTex;
		};
	
		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex)* _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	//FallBack "Transparent/Cutout/VertexLit"
}
