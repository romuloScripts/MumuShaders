using UnityEngine;
using System.Collections;

public class PerlinNoise : MonoBehaviour {

	public int pixWidth;
	public int pixHeight;
	public float xOrg;
	public float yOrg;
	public float scale;
	public Vector3 colorInfluence;


	private Texture2D noiseTex;
	private Color[] pix;
	private Renderer rend;

	void Start() {
		rend = GetComponent<Renderer>();
		noiseTex = new Texture2D(pixWidth, pixHeight);
		pix = new Color[noiseTex.width * noiseTex.height];
		rend.material.SetTexture("_MainTex", noiseTex);
		rend.material.SetTexture("_SecTex", noiseTex);
		CalcNoise();
	}

	void CalcNoise() {
		float y = 0.0f;
		while (y < noiseTex.height) {
			float x = 0.0f;
			while (x < noiseTex.width) {
				float xCoord = xOrg + x / noiseTex.width * scale;
				float yCoord = yOrg + y / noiseTex.height * scale;
				float sample = Mathf.PerlinNoise(xCoord, yCoord);
				pix[int.Parse((y * noiseTex.width + x).ToString())] = new Color(sample*colorInfluence.x, sample*colorInfluence.y, sample*colorInfluence.z, Random.Range(0.0f,1.0f));
				x++;
			}
			y++;
		}
		noiseTex.SetPixels(pix);
		noiseTex.Apply();
		rend.material.SetTexture("_MainTex", noiseTex);
		rend.material.SetTexture("_SecTex", noiseTex);
	}

	void FixedUpdate() {
		CalcNoise();
	}
}
