Shader "Custom/Wave"
{
	Properties 
	{
	    _Tess ("Tessellation", Range(1,32)) = 4
	    _MainTex    ("Texture", 2D) = "white" { }
	    _TintAmount ("Tint Amount", Range(0,1)) = 0.5
	    _ColorUp    ("Color Up", Color) = (1,1,1,1)
	    _ColorDown  ("Color Down", Color) = (0.6,0.6,0.6,1)
	    _Speed      ("Wave Speed", Range(0.1, 80)) = 2
	    _Length     ("Wave Length", Range(1,5)) = 2.6
	    _Amplitude  ("Wave Amplitude", Range(0,1)) = 0.3
	    _OffsetX    ("Wave OffsetX ", Range(0,1)) = 0.1
	}
	
	SubShader 
	{
		Tags {"RenderType" = "Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma target 5.0
		//#pragma exclude_renderers gles		
		//#pragma surface surf Lambert vertex vert tessellate:tessFixed
		#pragma vertex vert
		#pragma surface surf Lambert
		//#pragma tessellate:tessFixed

		sampler2D _MainTex;
	    fixed _TintAmount;
	    float4 _ColorUp;
	    float4 _ColorDown;
	    half _Speed;
	    half _Length;
	    fixed _Amplitude;
	    float _OffsetX;
	    
	     float _Tess;

            float4 tessFixed()
            {
                return _Tess;
            }
		
		struct Input 
		{
			float2 uv_MainTex;
			float3 vertColor;
		};
		
		void vert(inout appdata_full v, out Input o)
		{
			float waveHeight = v.vertex.y;
			
			if(v.texcoord.x > _OffsetX)
			{
			  waveHeight = sin( (_Time.y * _Speed) + v.vertex.x * _Length ) * _Amplitude;			  
			  v.vertex.xyz = float3( v.vertex.x, v.vertex.y + waveHeight, v.vertex.z );
			}

			o.vertColor  = waveHeight;
			o.uv_MainTex = v.texcoord;
		}
		
		void surf( Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			float3 tintColor = lerp(_ColorDown, _ColorUp, IN.vertColor.r).rgb;
			o.Albedo = c.rgb * (tintColor * _TintAmount);
			o.Alpha = c.a;
		}
			
		ENDCG
	}
}
