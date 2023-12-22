float3 bgcolor = float3(1,1,1);
float3 glasscolor = float3(1,1,1);

texture gTexture;

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
    float4 tex = tex2D(Sampler0, PS.TexCoord);

    if (
        abs(bgcolor.r - tex.r) <= 0.4
        && abs(bgcolor.g - tex.g) <= 0.4
        && abs(bgcolor.b - tex.b) <= 0.4
    ) {
        tex.rgba = 0;
    }

    if (
        // abs(glasscolor.r - tex.r) <= 0.4
        // && abs(glasscolor.g - tex.g) <= 0.4
        // && abs(glasscolor.b - tex.b) <= 0.4
        ( tex.r ) <= (10/255)
        &&( tex.g ) > 0.1
        &&( tex.b ) < (14/255)
    ) {
        tex.rgb = 0;
        tex.a = 0.7;
    }

    return tex;

}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique tec0
{
    pass P0
    {
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
