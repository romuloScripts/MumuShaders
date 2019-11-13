Shader "Custom/animated" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpeedMX ("Speed X", Range(-1,1)) = 0.01
		_SpeedMY ("Speed Y", Range(-1,1)) = 0.01
		
		_SecTex ("Albedo (RGB)", 2D) = "white" {}
		_SpeedSX ("Speed X", Range(-1,1)) = 0.01
		_SpeedSY ("Speed Y", Range(-1,1)) = 0.01

		_Color1("Cor1", Color)=(1 ,1 ,1 ,1)
		_Color2("Cor2", Color)=(1, 1, 1, 1)
		_Offset("offset", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Transparent" }
		LOD 200
		
		CGPROGRAM
	
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		sampler2D _SecTex;
		

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecTex;
		};

		half _SpeedMX;
		half _SpeedMY;
		half _SpeedSX;
		half _SpeedSY;
		fixed4 _Color1;
		fixed4 _Color2;
		half _Offset;


		void surf (Input IN, inout SurfaceOutput o) {
			
			fixed c = tex2D (_MainTex, float2(IN.uv_MainTex.x+(_Time.y*_SpeedMX),IN.uv_MainTex.y+(_Time.y*_SpeedMY) ));
			fixed d = tex2D (_SecTex, float2(IN.uv_SecTex.x+(_Time.y*_SpeedSX),IN.uv_SecTex.y+(_Time.y*_SpeedSY) ));

			if (c*IN.uv_SecTex.y / 2 + d*IN.uv_SecTex.y / 2 > _Offset)//(c + d > 0.5)
				o.Albedo = 1* lerp(_Color1.rgb, _Color2.rgb, pow(1-IN.uv_SecTex.y,07));//1;
			else
				discard;//o.Albedo=1;//0;
			//o.Albedo = lerp(c.rgb, d.rgb, 0.5);
			o.Alpha = 1;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
