using UnityEngine;
using System.Collections;

public class Cromatico : MonoBehaviour {

	public Renderer corRender;

	public static Color cor = Color.white;

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

		// mostrador de cor
		corRender.material.color = cor;
	}

}
