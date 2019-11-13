Shader "Custom/PulseShader" 
{
	// Propriedades de configuraçao
	Properties 
	{
		// Textura principal 2D colorida (default = white)
		_MainTex ("Textura Base (RGB)", 2D) = "white" {}
		
		// Textura secundaria 2D escala de cinsa (default = white)
		_GreyTex ("Textura Contraste (GreyScale)", 2D) = "white" {}
		
		// Cor do pulso (default = ARGB 100% 100% 100% 100%)
		_CorPulso ("Cor do Pulso", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		
		// Frequencia do pulso float (default = 1)
		_Frequencia( "Frequencia do Pulso", Float ) = 60.0
		
		// A partir dessa escala de cinza o shader sera aplicado 0 e 1 (default = 0.5)
		_EscalaCinzaBase( "Escala de Cinza Base", Range( 0, 1 ) ) = 0.8

		// Amplitude minima do pulso com barra de rolagem entre 0 e 1 (default = 0.5)
		_AmplitudeMinima( "Amplitude Minima", Range( 0, 1 ) ) = 0.65
	}
	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		// Propriedades mapeadas no shader
		sampler2D _MainTex;
		sampler2D _GreyTex;
 		fixed4 _CorPulso;
 		half _EscalaCinzaBase;
		half _Frequencia;
		half _AmplitudeMinima;
		
		// Estrutura de entrada para o shader
		struct Input 
		{
			// Mapeamento uv da textura principal no objeto
			float2 uv_MainTex;
			float2 uv_GreyTex;
		};

		// Processamento de Surface Shader (roda em qualquer dispositivo)
		void surf (Input IN, inout SurfaceOutput result) 
		{
			// Armazena o pixel original, baseado no mapeamento UV
			half4 PixelOriginal = tex2D (_MainTex, IN.uv_MainTex);
			
			// Captura a escala de cinza do pixel
			half PixelEscalaCinza = tex2D(_GreyTex, IN.uv_GreyTex);
			
			// Testa se a escala de cinza no pixel atual da superficie esta acima do cinza base a modificar 
			if ( PixelEscalaCinza >= _EscalaCinzaBase)
			{
				// A escala de cinza nesse pixel eh igual ou mais clara que a escala de cinza base
				
				// Pega um ponto da senoide (eixo y) baseado no tempo (eixo x)
				// Modificadores (0.5) para a senoide variar entre 0 e 1 (eixo y) 
				half SenoideY = 0.5 * sin( _Frequencia * _Time.x ) + 0.5;
				
				// Normalizaçao inferior da senoide
				// A AmplitudeResultante vai variar entre AmplitudeMinima e o Y maximo da senoide no tempo atual
				half AmplitudeNormalizada = SenoideY * ( 1 - _AmplitudeMinima ) + _AmplitudeMinima;
				
				// O pixel final sera o original(todos canais) * a cor do pulso (todos canais) * a amplitude normalizada da senoide (brilho)
				result.Albedo = PixelOriginal.rgb * _CorPulso.rgb * AmplitudeNormalizada;
			}
			else
			{
				// O pixel original na escala de cinza e mais escuro que o cinza base
				
				// O pixel final nao se modifica
				result.Albedo = PixelOriginal.rgb;
			}
			
			// Mantem o alfa do pixel
			result.Alpha = PixelOriginal.a;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}