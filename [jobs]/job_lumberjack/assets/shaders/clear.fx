//
// car_paint.fx
// EDIT by Ren712: Paint color and reflection vector fix.

//
// Badly converted from:
//
//      ShaderX2 – Shader Programming Tips and Tricks with DirectX 9
//      http://developer.amd.com/media/gpu_assets/ShaderX2_LayeredCarPaintShader.pdf
//
//      Chris Oat           Natalya Tatarchuk       John Isidoro
//      ATI Research        ATI Research            ATI Research
//

//---------------------------------------------------------------------
// Car paint settings
//---------------------------------------------------------------------
//---------------------------------------------------------------------
#include "mta-helper.fx"


//------------------------------------------------------------------------------------------
// Samplers for the textures
//------------------------------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 Tangent : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
    float3 NormalSurf : TEXCOORD4;
    float3 View : TEXCOORD5;
    float3 SparkleTex : TEXCOORD6;
    float4 Specular : COLOR1;
};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    return PS;
}


//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    return 0;
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique carpaint_fix_v2
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
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
