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

float progress = 0;
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 finalColor = tex2D(Sampler0, PS.TexCoord);
    // finalColor.rgb *= float3(r,g,b)*(1+progress);

    float _progress = max(0.1, progress);

    if ( (finalColor.r+finalColor.g+finalColor.b) < 0.1 ) {
        return float4(0.01, 0.01, 0.01, 1);
    }

    finalColor.r = max(0.01, finalColor.r*_progress);
    finalColor.g = max(0.01, finalColor.g*_progress);
    finalColor.b = max(0.01, finalColor.b*_progress);

    return finalColor;
}


technique TexReplace
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}
