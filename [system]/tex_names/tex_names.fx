// texture gTexture;
// float Time : TIME;

// float4 GetColor()
// {
    // return float4( 0, 0, 0, 0 );
// }

// technique tec0
// {
    // pass P0
    // {

        // texture[0] = gTexture;
    // }
// }


struct PSInput
{
  float4 Position : POSITION0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
};

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 pixelColor = PS.Diffuse;
    pixelColor.r *= 1;
    pixelColor.g *= 0.5;
    pixelColor.b *= 0.5;
    pixelColor.a = 0.8;
    return pixelColor;
}

technique TexReplace
{
	pass P0
	{
        PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}
