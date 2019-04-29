// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/curvatura" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Curvature("Curvature",Range(0.000,0.01)) = 0.001
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		
		#pragma surface surf Lambert vertex:vert addshadow


		uniform sampler2D _MainTex;
		uniform float _Curvature;

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{
			// transformar as coordenadas de um vertice de espaço local
			// para espaço global
			float4 vv = mul(unity_ObjectToWorld,v.vertex);
			// calcular a distancia relativa entre o vertive e a camera
			vv.xyz -= _WorldSpaceCameraPos.xyz;
			// reduzir a coordenada y (altura) do verticea medida que se
			// distancia da camera no eixo z (profundidade),
			// multiplicando pela curvatura desejada
			vv = float4(0.0f,(vv.z*vv.z)* - _Curvature,0.0f,0.0f);
			// retorna as coordenadas do vertice para o espaço local
			v.vertex += mul(unity_WorldToObject,vv);
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
