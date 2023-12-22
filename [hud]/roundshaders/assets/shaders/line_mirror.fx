
float mulR = 1;
float mulG = 1;
float mulB = 1;
float mulA = 1;

float x = 1;
float y = 1;

texture MaskTexture;
sampler MaskSampler = sampler_state
{
    Texture = <MaskTexture>;
};

float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0
{
	if (1-uv.x > x)
		return 0;

	if (1-uv.y > y)
		return 0;
	
	float4 result = tex2D(MaskSampler, uv);
	result.r *= mulR;
	result.g *= mulG;
	result.b *= mulB;
	result.a *= mulA;
	return result;
}

technique Technique1
{
    pass Pass1
    {
        AlphaBlendEnable = true;
        SrcBlend = SrcAlpha;
        DestBlend = InvSrcAlpha;
        PixelShader = compile ps_2_0 MaskTextureMain();
    }
}