Shader "Custom/PiscarCor" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Frequencia( "Frequencia do Pulso", Float ) = 60.0
		_Cor1("Cor1",Color) = (1,1,1,1)
		_Cor2("Cor2",Color) = (1,1,1,1)
		_Cor3("Cor3",Color) = (1,1,1,1)
		_Valor( "Valor",Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		        // surface shader, metodo e iluminaçao 
		sampler2D _MainTex;
		half _Frequencia;
		half4 _Cor1;
		half4 _Cor2;
		half4 _Cor3;
		fixed _Valor;
		
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 c2;
			if(_Valor > 0){
				c2 = lerp(_Cor2,_Cor3,(sin(_Time.x *_Frequencia)*0.5) +0.5); 	
				o.Albedo = c2;
			}else{
				o.Albedo = _Cor1;
			}
			//half4 c1 = lerp(_Cor1,_Cor2,_Valor); 
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
