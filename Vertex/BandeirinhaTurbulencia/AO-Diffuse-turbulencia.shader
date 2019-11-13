Shader "AO/Diffuse Turbulencia" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_AO ("Ambiente Oclusion", 2D) = "white" {}
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_vento ("Vento", Vector) = (1, 1, 1, 1)
		_forca ("Forca", Vector) = (0.1, 0.1, 0.1, 0.1)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Cull Off

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _AO;
		sampler2D _MainTex;
		fixed4 _Color;
		fixed4 _vento;
		fixed4 _forca;

		struct Input {
			float2 uv_AO;
			float2 uv_MainTex;
		};

		float hash(float n) {
			return frac(sin(n)*43758.5453);
		}

		float noise(float3 x) {
		    // The noise function returns a value in the range -1.0f -> 1.0f

			float3 p = floor(x);
			float3 f = frac(x);

			f = f*f*(3.0-2.0*f);
			float n = p.x + p.y*57.0 + 113.0*p.z;

			return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
				lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
				lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
				lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
		}

		void vert (inout appdata_full v) {
			//_ang *= v.color.z;
//			float x = cos(_ang)*v.vertex.x + sin(_ang)*v.vertex.y;
//			float y = -sin(_ang)*v.vertex.x + cos(_ang)*v.vertex.y;
			_forca = fixed4 (v.color.r*_forca.x, v.color.g*_forca.y, v.color.b*_forca.z, _forca.w);
			
			v.vertex = v.vertex + _forca*noise(v.vertex*_vento.w + _vento.xyz*_Time.w);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed4 ao = tex2D(_AO, IN.uv_AO);
			o.Albedo = ao.rgb * c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback "VertexLit"
}
