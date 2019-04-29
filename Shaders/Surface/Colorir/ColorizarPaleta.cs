using UnityEngine;
using System.Collections;

public class ColorizarPaleta : MonoBehaviour {

	public Texture2D paleta;

	private Color cor;

	void OnMouseDown() {
		RaycastHit hit;
		if (!Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit))
			return;

		MeshCollider meshCollider = hit.collider as MeshCollider;
		if (GetComponent<Renderer>() == null || GetComponent<Renderer>().sharedMaterial == null || GetComponent<Renderer>().sharedMaterial.mainTexture == null || meshCollider == null)
			return;

		Texture2D tex = (Texture2D) GetComponent<Renderer>().material.mainTexture;
		Vector2 pixelUV = hit.textureCoord;
		pixelUV.x *= tex.width;
		pixelUV.y *= tex.height;
		cor = tex.GetPixel((int)pixelUV.x, (int)pixelUV.y);

		int p;
		if (cor.r > 0f) {
			p = (int) (cor.r*256f);
			paleta.SetPixel(p-1, 3, Cromatico.cor);
			paleta.SetPixel(p+0, 3, Cromatico.cor);
			paleta.SetPixel(p+1, 3, Cromatico.cor);
		} else if (cor.g > 0f) {
			p = (int) (cor.g*256f);
			paleta.SetPixel(p-1, 2, Cromatico.cor);
			paleta.SetPixel(p+0, 2, Cromatico.cor);
			paleta.SetPixel(p+1, 2, Cromatico.cor);
		} else if (cor.b > 0f) {
			p = (int) (cor.b*256f);
			paleta.SetPixel(p-1, 1, Cromatico.cor);
			paleta.SetPixel(p+0, 1, Cromatico.cor);
			paleta.SetPixel(p+1, 1, Cromatico.cor);
		}
		paleta.Apply();
	}

}
