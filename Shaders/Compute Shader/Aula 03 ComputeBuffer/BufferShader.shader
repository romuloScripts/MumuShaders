// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BufferShader"
{
    SubShader
    {
       Pass
       {
            ZTest Always Cull Off ZWrite Off
            Fog { Mode off }
 
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            
            struct Vert
            {
                float3 position;
                float3 color;
            };
  			//uniform StructuredBuffer<int3> buffer;
            //uniform StructuredBuffer<float3> buffer;
 			 uniform StructuredBuffer<Vert> buffer;
 			
            struct v2f
            {
                float4  pos : SV_POSITION;
                float3 col : COLOR;
            };
 
            v2f vert(uint id : SV_VertexID)
            {
                //float4 pos = float4(buffer[id], 1);
                Vert vert = buffer[id];
                v2f OUT;
                //OUT.pos = mul(UNITY_MATRIX_MVP, pos);
                OUT.pos = UnityObjectToClipPos(float4(vert.position, 1));
                OUT.col = vert.color;
                return OUT;
            }
 
            float4 frag(v2f IN) : COLOR
            {
                //return float4(1,0,0,1);
                return float4(IN.col,1);
            }
 
            ENDCG
        }
    }
}
