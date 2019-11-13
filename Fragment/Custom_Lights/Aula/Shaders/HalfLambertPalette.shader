Shader "Example/HalfLambertPallette" {
	Properties {
    	_MainTex ("Texture", 2D) = "white" {}
    	_Palette ("Palette", 2D) = "white" {}
    }
    
    SubShader {
    	
    	Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf HalfLambertPalette
  
  		sampler2D _Palette;
  		
  		// O nome da funçao recebe o prefixo Lighting       
        half4 LightingHalfLambertPalette (SurfaceOutput s, half3 lightDir, half atten) {
	        half NdotL = dot (s.Normal, lightDir); // -1 a 1
	        half halfLambert = 0.5 + NdotL * 0.5; // 0 a 1
	        half3 paletteColor = tex2D (_Palette, float2(halfLambert, 0.0)).rgb;
	        half4 c;
	        c.rgb = saturate(s.Albedo * _LightColor0.rgb * paletteColor * atten );
	        c.a = s.Alpha;
	        return c;
	    }
  
        struct Input {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        
        ENDCG
	}
    
    Fallback "Diffuse"
}