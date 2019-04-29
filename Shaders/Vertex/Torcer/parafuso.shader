Shader "Vertex/parafuso" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ang ("Angulo", Float) = 3.1415
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float _ang;

		struct Input {
			float2 uv_MainTex;
		};

		void vert (inout appdata_full v) {
			_ang *= v.color.z;
			float x = cos(_ang)*v.vertex.x + sin(_ang)*v.vertex.y;
			float y = -sin(_ang)*v.vertex.x + cos(_ang)*v.vertex.y;
			v.vertex.x = x;
			v.vertex.y = y;
			x = cos(_ang)*v.normal.x + sin(_ang)*v.normal.y;
			y = -sin(_ang)*v.normal.x + cos(_ang)*v.normal.y;
			v.normal.x = x;
			v.normal.y = y;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
