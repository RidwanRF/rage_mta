

texture gTexture;

float progress = 0;

sampler Sampler0 = sampler_state
{
    Texture         = (gTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

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
    float4 BottomColor : TEXCOORD6;
    float3 SparkleTex : TEXCOORD7;
    float4 Diffuse2 : COLOR1;
};


float4 PixelShaderFunction(PSInput PS) : COLOR0
{

    float4 final = tex2D( Sampler0, PS.TexCoord )/6;
    final.rgb *= (1+progress*3);

    return final;

}


technique TexReplace
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}
