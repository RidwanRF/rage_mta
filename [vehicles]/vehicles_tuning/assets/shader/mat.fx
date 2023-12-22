//
// car_paint.fx
// File version: 1.2.1-custom. Modified and rewritten by Ren_712 on custom order for a shader not impacting GPU performance at all (due to techniques)
// Date updated: 2017-11-30
//

//---------------------------------------------------------------------
// Settings
//---------------------------------------------------------------------
float2 uvMul = float2(1,1);
float2 uvMov = float2(0,0.25);
float sNorFacXY = 0.25;
float sNorFacZ = 1;
float sSparkleSize = 0.5;
float bumpSize = 1;
float envIntensity = 1;
float specularValue = 1;
float refTexValue = 0.2;

float sAdd = 0.1;
float sMul = 1.1;
float sPower = 2;
float sCutoff = 0.16;
static const float pi = 3.141592653589793f;

float4 specularColor = float4(1,1,1,1);

texture gTexture;
texture paintJobTexture;
texture temp_paintJobTexture;
texture sRandomTexture;


//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#define GENERATE_NORMALS      // Uncomment for normals to be generated
#include "mta-helper.fx"

//---------------------------------------------------------------------
// Sampler for the main texture
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler Sampler1 = sampler_state
{
    Texture = (gTexture1);
    AddressU = Wrap;
    AddressV = Wrap;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

sampler VinylSampler = sampler_state
{
    Texture = (paintJobTexture);
    AddressU = Wrap;
    AddressV = Wrap;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

sampler temp_VinylSampler = sampler_state
{
    Texture         = (temp_paintJobTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler3D RandomSampler = sampler_state
{
    Texture = (sRandomTexture);
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = POINT;
    MIPMAPLODBIAS = 0.000000;
};

sampler2D ReflectionSampler = sampler_state
{
    Texture = (gTexture); 
    AddressU = Mirror;
    AddressV = Mirror;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
  float3 Position : POSITION0;
  float3 Normal : NORMAL0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
  float2 TexCoord1 : TEXCOORD1;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
  float4 Position : POSITION0;
  float4 Diffuse : COLOR0;
  float4 Specular : COLOR1;
  float2 TexCoord : TEXCOORD0;
  float3 Normal : TEXCOORD1;
  float3 WorldPos : TEXCOORD2;
  float3 PosProj : TEXCOORD3;
  float3 SparkleTex : TEXCOORD4;
  float2 TexCoord1 : TEXCOORD5;
  float3 ViewNormal : TEXCOORD6;
};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Make sure normal is valid
    MTAFixUpNormal( VS.Normal );

    // PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 4.0/sSparkleSize;
    // PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 4.0/sSparkleSize;
    // PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 4.0/sSparkleSize;
    PS.SparkleTex = VS.Normal;

    // Set information to do specular calculation
    // PS.Normal = mul(VS.Normal, (float3x3)gWorld);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );
    PS.WorldPos = mul( VS.Position.xyz, (float3x3)gWorld );

    // Pass through tex coord
    PS.TexCoord = VS.TexCoord;

    float3 posInWorld = gWorld[3].xyz * 0.02;
    posInWorld.x = ( posInWorld.x  - int(posInWorld.x )) * -gWorld[1].x;
    posInWorld.y = ( posInWorld.y  - int(posInWorld.y )) * -gWorld[1].y;

    float anim = posInWorld.x + posInWorld.y;
    PS.TexCoord1 = VS.TexCoord1 + float2( anim, 0 );

    // Calculate screen pos of vertex   
    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );    
    float4 viewPos = mul( worldPos , gView );
    float4 projPos = mul( viewPos, gProjection);
    // PS.Position = projPos / 100;
    PS.Position = MTACalcScreenPosition(VS.Position);

    // Reflection lookup coords to pixel shader
    projPos.x *= uvMul.x; projPos.y *= uvMul.y; 
    float projectedX = (0.5 * ( projPos.w + projPos.x ))+ uvMov.x;
    float projectedY = (0.5 * ( projPos.w + projPos.y )) + uvMov.y;
    // PS.PosProj = float3(projectedX,projectedY,projPos.w );
    PS.PosProj = float3(1,1,1);

    // Set information for the refraction
    PS.ViewNormal = normalize( mul(PS.Normal, (float3x3)gView )) /2;

    // Calculate GTA lighting for Vehicles
    PS.Diffuse = MTACalcGTAVehicleDiffuse( PS.Normal * 2, VS.Diffuse );
    PS.Specular.rgb = gMaterialSpecular.rgb * MTACalculateSpecular( gCameraDirection, gLightDirection, PS.Normal, gMaterialSpecPower ) * specularValue;

    PS.Specular.a = pow( mul( VS.Normal, (float3x3)gWorld ).z ,2.5 );
    float3 h = normalize(normalize(gCameraPosition - worldPos.xyz) - normalize(gCameraDirection));
    PS.Specular.a *= 1 - saturate(pow(saturate(dot(PS.Normal,h)), 2));
    PS.Specular.a *= saturate(1 + gCameraDirection.z);
    PS.Specular *= 0.1;
    return PS;
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    // float4 envMap = tex2D( ReflectionSampler, PS.TexCoord );

    // return envMap * PS.Diffuse;


    float4 cColor = PS.Diffuse;
    float4 vColor = tex2D(VinylSampler, PS.TexCoord);
    float4 temp_vColor = tex2D(temp_VinylSampler, PS.TexCoord);

    float4 fColor = cColor;

    if(vColor.a){
        fColor = ( fColor * (1 - vColor.a) ) + vColor;
    }

    if(temp_vColor.a){
        fColor = ( fColor * (1 - temp_vColor.a) ) + temp_vColor;
    }
    
    return fColor;

    // return PS.Diffuse + tex2D(temp_VinylSampler, PS.TexCoord)
    //     + tex2D(VinylSampler, PS.TexCoord);
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique car_paint_reflite
{
    pass P0
    {
        // Texture[1] = gTexture;
        // VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();

        // Texture[0] = paintJobTexture;
        // AlphaOp[0] = SelectArg1;
        // AlphaArg1[0] = Texture;
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