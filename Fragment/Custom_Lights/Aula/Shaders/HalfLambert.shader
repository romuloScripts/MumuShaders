Shader "Example/HalfLambert" {
	Properties {
    	_MainTex ("Texture", 2D) = "white" {}
    }
    
    SubShader {
    	
    	Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf HalfLambert
  
  		// O nome da funçao recebe o prefixo Lightning       
        half4 LightingHalfLambert (SurfaceOutput s, half3 lightDir, half atten) {
	        half NdotL = dot (s.Normal, lightDir);
	        half halfLambert = 0.5 + NdotL * 0.5;
	        half4 c;
	        c.rgb = saturate(s.Albedo * _LightColor0.rgb * halfLambert * atten );
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