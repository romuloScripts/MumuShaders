Shader "Custom/ReplaceExemple" {
	SubShader {
        Tags { "RenderType"="Opaque" "MyTag" = "RenderRed" }
        LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c*fixed4(1,0,0,0);
			o.Alpha = 1;
		}
		ENDCG
    }
   
    SubShader {
        Tags { "RenderType"="Opaque" "MyTag" = "RenderBlack" }
        LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb+lerp(-0.2,0.2,_SinTime.w);
			o.Alpha = 1;
		}
		ENDCG

    }
}
