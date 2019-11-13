Shader "Custom/Rotacionar" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Cor", Color) = (1,1,1,1)
		_Vel("Velocidade",Float) =1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert alpha:blend

		sampler2D _MainTex;
		fixed4 _Color;
		half _Vel;

		struct Input {
			float2 uv_MainTex;
		};

		void vert (inout appdata_full v) {
			float _ang = _Time.w*_Vel;
			
			float x = cos(_ang)*v.vertex.x + sin(_ang)*v.vertex.z;
			float z = -sin(_ang)*v.vertex.x + cos(_ang)*v.vertex.z;
			v.vertex.x = x;
			v.vertex.z = z;
			
			x = cos(_ang)*v.normal.x + sin(_ang)*v.normal.z;
			z = -sin(_ang)*v.normal.x + cos(_ang)*v.normal.z;
			v.normal.x = x;
			v.normal.z = z;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb*_Color;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
