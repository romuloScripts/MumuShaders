#pragma target 3.0

fixed4 _Color;
sampler2D _MainTex;
uniform float _Altura;

void vert (inout appdata_full v)
{
	fixed3 direction = lerp(v.normal, v.normal, PASSO);
	v.vertex.xyz += direction * _Altura * PASSO;
	v.vertex.x += ((sin(_Time.w)*0.5+0.5)/20)*PASSO;
	v.vertex.z += ((sin(_Time.z)*0.5+0.5)/20)*PASSO;
}

struct Input {
	float2 uv_MainTex;
	float3 viewDir;
};

void surf (Input IN, inout SurfaceOutputStandard o) {

	fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;

	o.Alpha = step( lerp(0, 1 , PASSO), c.g);

	float alpha = 1 - (PASSO * PASSO);
	alpha += dot(IN.viewDir, o.Normal) - 1;

	o.Alpha *= alpha;
}