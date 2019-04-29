Shader "Custom/Gota" {
			Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Amplitude("Amplitude",Float) = 1
		_Vel("Velocidade",Float) = 1
		_Length("Lenght",Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		
		#pragma surface surf Lambert vertex:vert addshadow


		uniform sampler2D _MainTex;
		uniform float _Amplitude;
		uniform float _Vel;
		uniform float _Length;
		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v){
		 	float result = sin( (_Time.y * _Vel) + v.vertex.y * _Length ) * _Amplitude;			  
			v.vertex.x +=result;
			v.normal.x +=result;
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
