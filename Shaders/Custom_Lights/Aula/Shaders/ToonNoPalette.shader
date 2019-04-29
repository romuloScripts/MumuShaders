Shader "Custom/ToonNoPalette" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Outline ("Outline", Range(0,1)) = 0.4
        _Tooniness ("Tooniness", Range(0.1,20)) = 4
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
 
        CGPROGRAM
        #pragma surface surf Tooniness
 
        sampler2D _MainTex;
        float _Tooniness;
        fixed _Outline;
 
        struct Input {
            float2 uv_MainTex;
            float3 viewDir;
        };
 
 		half4 LightingTooniness(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = dot(s.Normal, lightDir);
            half NdotLToon = floor(NdotL * _Tooniness)/_Tooniness;            
            half4 c;
            c.rgb = saturate(s.Albedo * _LightColor0.rgb * NdotLToon * atten );
            c.a = s.Alpha;
            return c;
        }
        
        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);    
            half NdotViewdir = saturate(dot (o.Normal, normalize(IN.viewDir)));
            half multi;
            
			if(NdotViewdir < _Outline)
				multi = NdotViewdir / 4;
			else
				multi = 1;
				
			o.Albedo = c.rgb * multi;
        }        
 
        ENDCG
    }
    FallBack "Diffuse"
}