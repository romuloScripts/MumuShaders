// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader criado por Marcelo Souza Nery
// Versao 1.0
// Data criaçao: 21/11/2013
// Ultima alteracao: 21/11/2013

// Obs.: este e usado em objetos separadamente, pois tem teste de Z, culling e fog!
Shader "Nery Shaders/Assets/HSI Assets"
{
	// Propriedades do shader
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Matiz ("Matiz (H)", Range(0.0, 2.0)) = 1.0
		_Saturacao ("Saturacao (S)", Range(0.0, 2.0)) = 1.0
		_Luminosidade ("Luminosidade (I)", Range(0.0, 2.0)) = 1.0
	}

	// Primeiro subshader (unico)
	SubShader
	{
		Pass
		{
			ZTest Always Cull Back ZWrite On ZTest LEqual
			Fog { Mode off }
				
			CGPROGRAM
			// Exclui shaders do OpenGL ES 2.0 porque nao possuem tanto vertex quanto fragment
			//#pragma exclude_renderers gles
			#pragma vertex vert
			#pragma fragment _FragmentShader
			#pragma fragmentoption ARB_precision_hint_fastest 
			#include "UnityCG.cginc"

			// Recupera as variaveis do shader para usar no programa Cg
			uniform sampler2D _MainTex;
			uniform float _Matiz;
			uniform float _Saturacao;
			uniform float _Luminosidade;
			
			 float4 vert (float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

			
			// FragmentShader: o efeito principal ocorre aqui
			fixed4 _FragmentShader (v2f_img _Imagem) : COLOR
			{	
				// Converte a informacao do fragmento que veio em "i" para um formato usavel
				half4 _Original = tex2D(_MainTex, _Imagem.uv);
			
				// Converte RGB para o modelo YIQ
				fixed Y = dot (fixed3(0.299, 0.587, 0.114), _Original.rgb);    // Componente de luz
				fixed I = dot (fixed3(0.596, -0.275, -0.321), _Original.rgb);  // Componente de cor 1
				fixed Q = dot (fixed3(0.212, -0.523, 0.311), _Original.rgb);   // Componente de cor 2
	
				// Converte de volta para RGB, alterando a matiz
				I = I + (1 - _Matiz) * Q;
				Q = Q + (1 - _Matiz) * I;
				
				fixed R = Y + 0.956 * I + 0.621 * Q;
				fixed G = Y - 0.272 * I - 0.647 * Q;
				fixed B = Y - 1.105 * I + 1.702 * Q;
				
				// Cria a nova cor RGB do fragmento, com matiz alterada
				fixed4 _RGB = float4(R, G, B, _Original.a);
	
				// Finaliza a correcao HSI, alterando a saturacao e luminosidade sobre as cores RGB com matiz alterada
				fixed4 _Saida = (_Saturacao * _RGB + (1 - _Saturacao) * Y) * _Luminosidade;
				_Saida.a = _Original.a;
	
				return _Saida;
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}