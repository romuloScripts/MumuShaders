Shader "Hidden/Custom/BlendTextures"
{
    HLSLINCLUDE

        #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        TEXTURE2D_SAMPLER2D(_Left , sampler_Left);
        TEXTURE2D_SAMPLER2D(_Right, sampler_Right);
        float _Blend;

        float4 Frag(VaryingsDefault i) : SV_Target
        {
            float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
            float4 color2 = i.texcoord.x < 0.5 ?
                SAMPLE_TEXTURE2D(_Left , sampler_Left , i.texcoord) :
                SAMPLE_TEXTURE2D(_Right, sampler_Right, i.texcoord);
            color.rgb = lerp(color.rgb, color2.rgb, _Blend.xxx);
            return color;
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment Frag

            ENDHLSL
        }
    }
}