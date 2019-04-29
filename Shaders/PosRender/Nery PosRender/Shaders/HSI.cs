// Shader criado por Marcelo Souza Nery
// Versao 1.0
// Data criaçao: 21/11/2013
// Ultima alteracao: 21/11/2013

// *** SHADER DE POST-PROCESSING IMAGING (CAMERA) ***
// Descricao: altera isoladamente a matiz, saturaçao e luminosidade de toda a cena vista pela camera.
// Os valores padronizados para os tres parametros e 1. O intervalo de saturaçao e luminosidade (valores comuns) e 0.0 a 1.0.
// O intervalo para a matiz (valores que pega todo o intervalo comum) e 0.0 a 2.0.
// Qualquer alteraçao a mais gera efeitos colaterais diversos. Nao ha correçao de contraste nesse shader.

// Trabalho futuro: acrescentar controle de contraste.

using UnityEngine;

// Força o shader ser executado no modo de ediçao (nao e valido para post-processing imaging de camera)
[ExecuteInEditMode]

// Adiciona o shader na lista de menus
[AddComponentMenu("Nery Shaders/Camera/HSI")]

// Força ter uma camera
[RequireComponent (typeof(Camera))]

// Classe que manipula o efeito de imagem desejado
public class HSI : ImageEffectBase
{
	// Parametros do shader
	public float Matiz;
	public float Saturacao;
	public float Luminosidade;

	// Chamado pela camera para aplicar o efeito desejado
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_Matiz", Matiz);
		material.SetFloat("_Saturacao", Saturacao);
		material.SetFloat("_Luminosidade", Luminosidade);
		
		Graphics.Blit (source, destination, material);
	}
}