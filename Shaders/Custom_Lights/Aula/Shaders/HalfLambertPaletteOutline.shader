Shader "Example/HalfLambertPaletteOutline" {
	Properties {
    	_MainTex ("Texture", 2D) = "white" {}
    	_Palette ("Palette", 2D) = "white" {}
    	_Outline ("Outline", Range(0,1)) = 0.4
    	_ColorLine ("Color", Color) = (0,0,0,1)
    }
    
    SubShader {
    	
    	Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf HalfLambertPalette
  
  		sampler2D _Palette;
  		fixed _Outline;
  		float3 _ColorLine;
  		
  		// O nome da funçao recebe o prefixo Lightning       
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
            float3 viewDir;
        };
        
        sampler2D _MainTex;
        
        void surf (Input IN, inout SurfaceOutput o) {
        
        	float3 c = tex2D (_MainTex, IN.uv_MainTex).rgb;
        	half NdotView = saturate(dot (o.Normal, normalize(IN.viewDir)));
			
			if(NdotView < _Outline) {
				o.Albedo = _ColorLine;
			}
			else {
				o.Albedo = c.rgb;
			}
        }
        
        ENDCG
	}
    
    Fallback "Diffuse"
}