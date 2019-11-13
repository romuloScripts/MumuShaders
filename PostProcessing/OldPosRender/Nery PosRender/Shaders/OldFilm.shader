//from Unity Shaders and Effects Cookbook.
Shader "Nery Shaders/Camera/OldFilm" 
{
	Properties 
	{
	    _MainTex("Base (RGB)", 2D) = "white"{}
	    _VignetteTex("Vignette Texture", 2D) = "white"{}
	    _ScratchesTex("Scratches Texture", 2D) = "white"{}
	    _DustTex("Dust Texture", 2D) = "white"{}
	    _SepiaColor("Sepia Color", Color) = (1,1,1,1)
	    _EffectAmount("Old Film Effect Amount", Range(0,1)) = 1.0
	    _VignetteAmount("Vignette Opacity", Range(0,1)) = 1.0
	    _ScratchesYSpeed("Scratches Y Speed", Float) = 10.0
	    _ScratchesXSpeed("Scratches X Speed", Float) = 10.0
	    _DustXSpeed("Dust X Speed", Float) = 10.0
	    _DustYSpeed("Dust Y Speed", Float) = 10.0
	    _RandomValue("Random Value", Float) = 1.0
	}
	SubShader 
	{
	    Pass
	    {
	        CGPROGRAM
	        #pragma vertex vert_img
	        #pragma fragment frag
	        #pragma fragmentoption ARB_precision_hint_fastest
	        #include "UnityCG.cginc"

	        uniform sampler2D _MainTex;
	        uniform sampler2D _VignetteTex;
	        uniform sampler2D _ScratchesTex;
	        uniform sampler2D _DustTex;
	        fixed4 _SepiaColor;
	        fixed  _VignetteAmount;
	        fixed  _ScratchesYSpeed;
	        fixed  _ScratchesXSpeed;
	        fixed  _DustYSpeed;
	        fixed  _DustXSpeed;
	        fixed  _EffectAmount;
	        fixed  _RandomValue;

	        fixed4 frag(v2f_img i) : COLOR
	        {
	            //get rendertexture and uv.
	            half2 renderTexUV = half2(i.uv.x, i.uv.y + (_RandomValue * _SinTime.z * 0.005));
	            fixed4 renderTex = tex2D(_MainTex, renderTexUV);
	            //get vignette pixel.
	            fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

	            //process scratches uv and pixels.
	            half2 scratchesUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _ScratchesXSpeed), i.uv.y + (_Time.x * _ScratchesYSpeed));
	            fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);
	            //process dust uv and pixels.
	            half2 dustUV = half2(i.uv.x + (_RandomValue * (_SinTime.z * _DustXSpeed)), i.uv.y + (_RandomValue * (_SinTime.z * _DustYSpeed)) );
	            fixed4 dustTex = tex2D(_DustTex, dustUV);

	            //get luminosity from render texture.
	            fixed lum = dot( fixed3(0.299, 0.587, 0.114), renderTex.rgb);

	            //add constant to lum.
	            fixed4 finalColor = lum + lerp(_SepiaColor, _SepiaColor + fixed4(0.1f, 0.1f, 0.1f, 1.0f), _RandomValue);
	            //Constant white color use to adjust opacity of effect.
	            fixed3 constantWhite = fixed3(1,1,1);

	            //composite all params.
	            finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
	            finalColor.rgb *= lerp(scratchesTex, constantWhite, (_RandomValue));
	            finalColor.rgb *= lerp(dustTex.rgb, constantWhite, (_RandomValue * _SinTime.z));
	            finalColor = lerp(renderTex, finalColor, _EffectAmount);

	            return finalColor;
	        }

	        ENDCG
		}
	}
}