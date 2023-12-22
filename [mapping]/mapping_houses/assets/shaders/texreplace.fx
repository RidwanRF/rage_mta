
texture gTexture;

sampler Sampler0 = sampler_state
{
    Texture = <gTexture>;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
    MIPMAPLODBIAS = 0.000000;
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

    float4 finalColor = tex2D(Sampler0, input.TexCoord);
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
