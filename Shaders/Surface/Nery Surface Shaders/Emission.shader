Shader "Nery Shaders/Assets/Emission"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white"{}      // Diffuse Map
		_BumpMap("Bumpmap", 2D) = "bump"{}       // Bump Map
		_SpecMap("Specularmap", 2D) = "black"{}  // Spec Map
		_SpecColor("Specular Color", Color) = (0.5,0.5,0.5,1.0) // Sets SpecColor to Grey
		_SpecPower("Specular Power", Range(0,1)) = 0.5 // Set Spec Shiness along a range. Defaults at 0.5
		_EmitMap("Emissive Map", 2D) = "black"{}      // Emit Map
		_EmitPower("Emit Power", Range(0,1)) = 1.0
	}

	SubShader 
	{
		Tags {"RenderType" = "Opaque"}

		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma exclude_renderers flash 

		sampler2D _MainTex; // In order for it to be editable in the Unity Inspector
		sampler2D _BumpMap;
		sampler2D _SpecMap;
		sampler2D _EmitMap;
		float _SpecPower;
		float _EmitPower;

		struct Input
		{
			float2 uv_MainTex;  // (1.0, 1.0) U, V
			float2 uv_BumpMap;
			float2 uv_SpecMap;
			float2 uv_EmitMap;
		};


		void surf (Input IN, inout SurfaceOutput o) 
		{

			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 specTex = tex2D(_SpecMap, IN.uv_SpecMap);
			fixed4 emitTex = tex2D(_EmitMap, IN.uv_EmitMap);

			o.Albedo = tex.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Specular = _SpecPower;
			o.Gloss = specTex.rgb;
			o.Emission = emitTex.rgb * _EmitPower;
		}

		ENDCG 

	}

	Fallback "Specular"

}