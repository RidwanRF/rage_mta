// Variable to fetch the texture from the script
texture paintJobTexture;

// My nice technique. Requires absolutely no tools, worries nor skills
technique TexReplace
{
    pass P0
    {
        // Set the texture
        Texture[0] = paintJobTexture;
        //
        AlphaOp[0] = SelectArg1;
        AlphaArg1[0] = Texture;
    }
}
