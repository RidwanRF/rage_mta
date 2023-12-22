texture gTexture;
float mirrorX = 0;
float mirrorY = 0;
float alpha = 1;

float r = 1;
float g = 1;
float b = 1;

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
    float2 curCoord = PS.TexCoord;
    if(mirrorX == 1){
    	curCoord.x = 1 - PS.TexCoord.x;
    }
    if(mirrorY == 1){
    	curCoord.y = 1 - PS.TexCoord.y;
    }
    float4 finalColor = tex2D(Sampler0, curCoord);
    finalColor.a *= alpha;
    return finalColor * float4(r,g,b,1);
}


technique TexReplace
{
    pass P0
    {
        // Texture[0] = gTexture;
        PixelShader  = compile ps_2_0 PixelShaderFunction();

        // AlphaOp[0] = SelectArg1;
        // AlphaArg1[0] = Texture;

    }
}
