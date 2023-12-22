texture gTexture0           < string textureState="0,Texture"; >;
sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
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

float r = 0;
float g = 0;
float b = 0;
float progress = 0;

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 finalColor;
    finalColor = tex2D(Sampler0, PS.TexCoord);
    if(abs(PS.TexCoord.x - 0.5) < (progress/2)){
        finalColor.rgb *= float3(r,g,b);
    } else {
        finalColor.rgb /= 8;
    }
    return finalColor;
}


technique TexReplace
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}
