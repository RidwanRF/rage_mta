#include "mta-helper.fx"

float noAlpha = 0;
float coordMul = 1;

texture gTexture;
texture mask;
sampler Sampler0 = sampler_state
{
    Texture = <gTexture>;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
    MIPMAPLODBIAS = 0.000000;
};

sampler Sampler1 = sampler_state
{
    Texture = <mask>;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
    MIPMAPLODBIAS = 0.000000;
};

struct VertexShaderInput
{
    float3 Position : POSITION0;
    float4 Color : COLOR0;
    float3 Normal : NORMAL0;
    float2 TexCoord : TEXCOORD0;
};
 
struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float4 Color : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 WorldNormal : TEXCOORD1;
    float3 WorldPosition : TEXCOORD2;
    float4 Specular : COLOR1;
};

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
    float4 finalColor = tex2D(Sampler0, input.TexCoord*coordMul);
    float4 mask = tex2D(Sampler1, input.TexCoord*coordMul);

    if (mask.a == 0){return 0;}

    if (finalColor.a < 1 && noAlpha == 1){
        finalColor = float4(0,0,0,1);
    }
    finalColor.rgb /= 2;
    return finalColor;
}

technique CarShader
{
    pass Pass0
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}


// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
