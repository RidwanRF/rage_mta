//-----------------------------------------------------------------------------
// PrototypeX anti-anisotropic
//-----------------------------------------------------------------------------

texture gTexture;

technique 
{ 
    pass p0 
    {
		Texture[0] = gTexture;
    }
}