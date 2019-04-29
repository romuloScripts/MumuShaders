Shader "Custom/Escalonar" {
		Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_EscalaMax("Escala Maxima",Float) = 1
		_EscalaMin("Escala Minina",Float) = 1
		_Vel("Velocidade",Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		
		#pragma surface surf Lambert vertex:vert


		uniform sampler2D _MainTex;
		uniform float _EscalaMin;
		uniform float _EscalaMax;
		uniform float _Vel;
		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{
			float result = lerp(_EscalaMin, _EscalaMax,sin(_Time.y*_Vel)*0.5+0.5);
			v.vertex.xyz += v.normal.xyz * result;
			//v.normal.xyz *=result;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
