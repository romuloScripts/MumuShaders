Shader "Custom/PiscarCor" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Frequencia( "Frequencia do Pulso", Float ) = 60.0
		_Cor1("Cor1",Color) = (1,1,1,1)
		_Cor2("Cor2",Color) = (1,1,1,1)
		_DistanciaMax( "DistanciaMax", Float ) = 5
		_DistanciaMin( "DistanciaMin", Float ) = 0
		_pos ("posicao", Vector) = (0.0 ,0.0 ,0.0 ,0.0)
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha
		#pragma target 3.0
		
		sampler2D _MainTex;
		half _Frequencia;
		half4 _Cor1;
		half4 _Cor2;
		half _DistanciaMax;
		half _DistanciaMin;
		float4 _pos;
		
		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			half4 c2;
			c2 = lerp(_Cor1,_Cor2,(sin(_Time.x *_Frequencia)*0.5) +0.5);
			float dist = distance(IN.worldPos.xyz, _pos.xyz);
			float smooth = smoothstep(_DistanciaMin, _DistanciaMax, dist);
			half4 preto = (0,0,0,0);

			c2 = lerp(preto, c2, smooth);
			o.Albedo = c2.rgb;

			o.Alpha = c2.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
