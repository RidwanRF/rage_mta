texture gTexture;
float curtainProgress = 0;
// float curtainProgress = 0;

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
    float4 finalColor = tex2D(Sampler0, PS.TexCoord);
    finalColor.rgb /= 3;

    if ( PS.TexCoord.y < curtainProgress ) {
        finalColor.rgb = float3(0, 0, 0);
    }

    // return 1;
    return finalColor;
}


technique TexReplace
{
	pass P0
	{
        AlphaBlendEnable = true;
        Lighting = false;
        // Texture[0] = gTexture;
        AlphaArg1[0] = Texture;
        PixelShader  = compile ps_2_0 PixelShaderFunction();
	}
}
