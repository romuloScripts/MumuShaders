Shader "Custom/Sprite" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NumColunas( "Numero Total de Colunas", Float ) = 10
		_NumLinhas( "Numero Total de Linhas", Float ) = 3
		_Linha( "Linha Atual", Float ) = 0
		_Coluna( "Coluna Atual", Float ) = 0
		_Lado( "Lado do Sprite", Float ) = 1
	}
	SubShader {
		Tags {"Queue"="Transparent" "RenderType"="Transparent"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		half _NumColunas;
		half _NumLinhas;
		half _Linha;
		half _Coluna;
		half _Lado;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			//IN.uv_MainTex.x *=_Lado;
			half col = _Coluna;
			if(_Lado == -1){
				col = col-1;
			}
			fixed2 novoUV = fixed2((IN.uv_MainTex.x/_NumColunas+(col/_NumColunas))*_Lado,
								   IN.uv_MainTex.y/_NumLinhas+(_Linha/_NumLinhas));
			
			half4 c = tex2D (_MainTex, novoUV);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
