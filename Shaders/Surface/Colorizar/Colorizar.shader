// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Colorizar" {
	Properties {
		[MaterialToggle] bg ("Background", Float) = 0
		_Color ("Cor", Color) = (1,1,1)
		_Color2 ("Cor 2", Color) = (1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_trans ("Transicao", Float) = 0.15
		_delay ("Delay", Float) = 0.0
		//_Curvature("Curvature",Range(0.000,1)) = 0.001
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma multi_compile DUMMY BG_ON

		fixed4 _Color;
		fixed4 _Color2;
		sampler2D _MainTex;
		float3 _posDiv;
		float3 _posDiv2;
		float _trans;
		float _delay;
		float _Curvature;
		//float _Curvature2;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		float Senoide(Input IN){
			return 	sin(IN.worldPos.y *7)*0.2f
			// sin(IN.worldPos.y *5 + 2)*0.2f*sin(_Time.y)
			//		+ sin(IN.worldPos.y *5)*0.2f 
				 ;
		}

		void vert(inout appdata_full v){
			// transformar as coordenadas de um vertice de espaço local
			// para espaço global
			float4 vv = mul(unity_ObjectToWorld,v.vertex);
			// calcular a distancia relativa entre o vertive e a camera
			vv.xyz -= _WorldSpaceCameraPos.xyz;
			//float _Curvature = 0.035;
			// reduzir a coordenada y (altura) do verticea medida que se
			// distancia da camera no eixo z (profundidade),
			// multiplicando pela curvatura desejada
			//vv = float4(0.0f,(vv.z*vv.z)* - _Curvature,0.0f,0.0f);
			//if(vv.x >0){
//			#ifdef BG_ON
//			vv = float4(0.0f,(vv.x*vv.x)*-_Curvature2*10,(vv.x*vv.x)* - _Curvature2,0.0f);
//			#else
			vv = float4(0.0f,(vv.x*vv.x)*+_Curvature*0.2f,(vv.x*vv.x)* - _Curvature,0.0f);
			//#endif
			// retorna as coordenadas do vertice para o espaço local
			v.vertex -= mul(unity_WorldToObject,vv);
			//}
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 c2 = (c.r+c.g+c.b)/3 * _Color2;
			_trans = 0.3f;
			_delay = sin(IN.worldPos.z)*3+1.5f;
			#ifdef BG_ON
				float smooth = smoothstep(IN.worldPos.x-_trans, IN.worldPos.x+_trans, _posDiv2.x-_delay-Senoide(IN));
			#else
				float smooth = smoothstep(IN.worldPos.x-_trans, IN.worldPos.x+_trans, _posDiv.x-_delay-Senoide(IN));
			#endif
			o.Albedo = lerp(c2.rgb, c.rgb*_Color, smooth);
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
