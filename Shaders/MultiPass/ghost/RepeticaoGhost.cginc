// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

sampler2D _MainTex;
sampler2D _AlphaTex;
fixed4 _Array[3];
			
struct appdata_t
{
	float4 vertex   : POSITION;
	float4 color    : COLOR;
	float2 texcoord : TEXCOORD0;
};

struct v2f
{
	float4 vertex   : SV_POSITION;
	fixed4 color    : COLOR;
	float2 texcoord  : TEXCOORD0;
};
			
fixed4 _Color;

v2f vert(appdata_t IN)
{
	v2f OUT;
	OUT.vertex = UnityObjectToClipPos(IN.vertex);
	OUT.texcoord = IN.texcoord;
	//float4 vv = mul(unity_ObjectToWorld,OUT.vertex);
	OUT.vertex.x += _Array[PASSO].x;
	OUT.vertex.y += _Array[PASSO].y;
	//OUT.vertex = mul(unity_WorldToObject,vv);
	//unity_ObjectToWorld
	//unity_WorldToObject
	OUT.color = IN.color * _Color;
	#ifdef PIXELSNAP_ON
	OUT.vertex = UnityPixelSnap (OUT.vertex);
	#endif
	return OUT;
}



fixed4 SampleSpriteTexture (float2 uv)
{
	fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
	// get the color from an external texture (usecase: Alpha support for ETC1 on android)
	color.a = tex2D (_AlphaTex, uv).r;
#endif //ETC1_EXTERNAL_ALPHA

	return color;
}

fixed4 frag(v2f IN) : SV_Target
{
	fixed4 c = SampleSpriteTexture (IN.texcoord) * IN.color;
	c.a *=ALPHA;
	c.rgb *= c.a;
	
	return c;
}