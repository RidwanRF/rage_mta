

texture gTexture0           < string textureState="0,Texture"; >;
float progress = 1;
float3 color = float3(1,1,1);

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

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 finalColor = tex2D(Sampler0, PS.TexCoord);
    // finalColor.rgb *= float3(0,0,0);
    finalColor.rgb *= progress*color;
    return finalColor/2;
}


technique TexReplace
{
	pass P0
	{
        PixelShader  = compile ps_2_0 PixelShaderFunction();
	}
}
