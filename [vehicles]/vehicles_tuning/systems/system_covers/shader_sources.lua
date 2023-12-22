


-- ShaderSources = {}
-- local name = 'shader_sources.lua'

-- if fileExists( name ) then

--   local file = fileOpen('shader_sources.lua')
--   local content = fileRead( file, file.size )

--   loadstring( content )()

--   fileClose(file)

-- end


ShaderSources = {}
ShaderSources.default = [=[

  float2 sEffectFade = float2(50, 40);
  float brightnessFactor;
  float m_fixed = 1;
  float light = 2.0;

  texture gScreenSource : SCREEN_SOURCE;
  texture gDepthBuffer : DEPTHBUFFER;

texture paintJobTexture;
texture temp_paintJobTexture;
sampler VinylSampler = sampler_state
{
    Texture         = (paintJobTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler temp_VinylSampler = sampler_state
{
    Texture         = (temp_paintJobTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

  texture sSnow;
  texture sSnowA;

  texture sReflectionTexture;
  texture sRandomTexture;

  #include "assets/shader/rage.fx"

  sampler Sampler0 = sampler_state
  {
      Texture = (gTexture0);
  };

  samplerCUBE VReflDaySampler = sampler_state
  {
      Texture = (sReflectionTexture);
      MAGFILTER = LINEAR;
      MINFILTER = LINEAR;
      MIPFILTER = LINEAR;
      SRGBTexture=FALSE;     
      MaxMipLevel=0;
      MipMapLodBias=0;
  };

  samplerCUBE ReflDaySampler = sampler_state
  {
      Texture = (sReflectionTexture);
      MAGFILTER = LINEAR;
      MINFILTER = LINEAR;
      MIPFILTER = LINEAR;
      SRGBTexture=FALSE;      
      MaxMipLevel=0;
      MipMapLodBias=0;
  };

  sampler SamplerColor = sampler_state
  {
      Texture = (gScreenSource);
      MinFilter = LINEAR;
      MagFilter = LINEAR;
      MipFilter = LINEAR;
      AddressU  = Clamp;
      AddressV  = Clamp;
      SRGBTexture=FALSE;  
  };

  struct VSInput
  {
      float4 Position : POSITION0;
      float2 TexCoord : TEXCOORD0;
      float3 Normal : NORMAL0;
      
      float4 Color : COLOR0;  
  };

  struct PSInput
  {
      float4 Position : POSITION0;
      float4 Position2 : POSITION1;   
      float2 TexCoord : TEXCOORD0;
      float4 Color : COLOR0;
      float4 AmbC : TEXCOORD1;
      float4 invTex : TEXCOORD2;
      float3 Material : TEXCOORD3;    
      float3 Normal : TEXCOORD4;
      float4 View : TEXCOORD5;
      float4 Light : TEXCOORD6;   
      float4 Diffuse : TEXCOORD7;     
  };

  PSInput VertexShaderFunction(VSInput VS)
  {
      PSInput PS = (PSInput)0;

      float3 Normal = mul(VS.Normal, (float3x3)gWorld);
      PS.Normal = Normal;
      Normal = normalize(Normal); 

      float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );

      PS.Position = mul(float4(VS.Position.xyz , 1.0), gWorldViewProjection);
      PS.Position2 = PS.Position;
      
      PS.AmbC = gMaterialAmbient;
      PS.Material = AlphaMaterial();
      PS.View.xyz = gCameraPosition - worldPos.xyz;
      
      PS.Diffuse = gMaterialDiffuse;  
      PS.Light = CalcGTADynamicDiffuse(Normal); 
      PS.TexCoord.xy = VS.TexCoord.xy;
      return PS; 
  }

  float3 GetCorrection(float3 color)
  {
    return color; 
  }

  float3 Uncharted2Tonemap(float3 x)
  {
      float A = 1.0;
      float B = 0.25;
      float C = 0.52;
      float D = 0.34;
      float E = 0.0;
      float F = 1.0;

      return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
  }

  float2 wpd2(float3 cd)
  {
     float4 tv = float4(cd.xyz, 1.0);
     float4 wp = mul(tv, gViewInverseTranspose); 
            
            wp.x = -wp.x;           
            wp.xy = wp.xy*0.0+0.0;
     return wp.xy;
  }

  float4 PS_Reflection(PSInput PS) : COLOR0
  {
      float3 vView = normalize(PS.View.xyz);  

      float wx = gWeather;
      
      float  wpos2 = length(vView.xyz);
      float3 camdir = vView.xyz / wpos2;  
      float3 npos = normalize(PS.Normal);
      
    float hourMinutes = (1 / 59) * 15;
    float GameTime = 15 + hourMinutes;

     float t0 = GameTime;
     float x1 = smoothstep(0.0, 4.0, t0);
     float x2 = smoothstep(4.0, 5.0, t0);
     float x3 = smoothstep(5.0, 6.0, t0);
     float x4 = smoothstep(6.0, 7.0, t0);
     float xE = smoothstep(8.0, 11.0, t0);
     float x5 = smoothstep(16.0, 17.0, t0);
     float x6 = smoothstep(18.0, 19.0, t0);
     float x7 = smoothstep(19.0, 20.0, t0);
     float xG = smoothstep(20.0, 21.0, t0);  
     float xZ = smoothstep(21.0, 22.0, t0);
     float x8 = smoothstep(22.0, 24.0, t0);   
     
  float3  f = lerp(float3(0.,0.,-.61), float3(.583,-.257,-.0108), smoothstep(0.,5.,GameTime));

     float3 df0 = lerp(0.70*float3(0.90, 0.95, 1.02), 0.70*float3(0.90, 0.95, 1.02), x1);
 
     float3 sh0 = lerp(0.70, 0.70, x1);
            sh0 = lerp(sh0, 0.70, x2);
            sh0 = lerp(sh0, 0.95, x3);
            sh0 = lerp(sh0, 0.95, x4);
            sh0 = lerp(sh0, 0.95, xE);
            sh0 = lerp(sh0, 0.95, x5);
            sh0 = lerp(sh0, 0.80, x6);
            sh0 = lerp(sh0, 0.80, x7);
            sh0 = lerp(sh0, 0.80, xG);    
            sh0 = lerp(sh0, 0.75, xZ);                  
            sh0 = lerp(sh0, 0.70, x8); 
            
  float3 shadowColor = float3(1, 1, 1.0);           
     float3 Color0 = float3(1.15, 0.99, 0.85);    
     float3 bl0 = lerp(0.0, 0.0, x1);     
     float sp0 = lerp(0.0, 0.0, x1);
           
     float3 X2 = normalize(f+camdir); 
     float specular3 = pow(0.01-dot(npos.xyz, X2.xyz), 0.15);
                
      float4 ColorCar = PS.Diffuse;   
      float4 texel = tex2D(Sampler0, PS.TexCoord);
             
      float texelA = saturate(texel.rgb); 
      float mix = lerp(0.7, 2.2, texelA); 
      float diff = saturate(0.1-dot(npos, -f)) - 2; 
            diff = pow(diff, 0.5);

      float3 sv3 = normalize(float3(0.0, 0.0, 0.7)+vView.xyz);    
      float fresnelz = (0.05-dot(-sv3, npos));        
            fresnelz = pow(fresnelz, 5.0);
            fresnelz = fresnelz*fresnelz;
            fresnelz/= 2.5;   
            fresnelz*= 0.7;                         
            
      float3 lighting = lerp(sh0*shadowColor, df0, saturate(diff));              
      
      float3 refl = reflect(vView, npos); 
      
      float4 CubeD = texCUBE(ReflDaySampler, -refl.xzy);
             CubeD*= 1.5; 
      float4 CubeDV = texCUBE(VReflDaySampler, -refl.xzy);
             CubeDV*= 1.5;
                 
      float3 CurrentRefl =  CubeDV.rgb;

      if (wx.x==0) CurrentRefl = CubeD.rgb;
      if (wx.x==1) CurrentRefl = CubeD.rgb;
      if (wx.x==2) CurrentRefl = CubeD.rgb;
      if (wx.x==3) CurrentRefl = CubeD.rgb;
      if (wx.x==4) CurrentRefl = CubeD.rgb;
      
      
      float4 CubeN = texCUBE(ReflDaySampler, -refl.xzy);
             CubeN.rgb*= 1*float3(0.82, 0.95, 1.05);

      float3 cb = lerp(CubeN.xyz, CubeN.xyz, x1);
             cb = lerp(cb, CubeN.xyz, x2);
             cb = lerp(cb, CurrentRefl.xyz*0.92, x3);
             cb = lerp(cb, CurrentRefl.xyz, x6);
             cb = lerp(cb, CurrentRefl.xyz*0.85, x7);
             cb = lerp(cb, CurrentRefl.xyz*0.8, xG);         
             cb = lerp(cb, CubeN.xyz, xZ);           
             cb = lerp(cb, CubeN.xyz, x8);
             
      float3 n0 = normalize(cb.xyz);
      float3 ct0=cb.xyz/n0.xyz;
             ct0=pow(ct0, 2.0);
             n0.xyz = pow(n0.xyz, 0.8);   
             cb.xyz = ct0*n0.xyz;  
             cb.xyz*= 1.25;              
      
      float fresnel = 0.001*1.0-dot(npos, -camdir);       
            fresnel = saturate(pow(fresnel, 0.15));         
            
     float m0 = lerp(0.20, 0.20, x1);
           m0 = lerp(m0, 0.10, x2);
           m0 = lerp(m0, 0.0, x3);
           m0 = lerp(m0, 0.0, x4);
           m0 = lerp(m0, 0.0, x5);
           m0 = lerp(m0, 0.0, x6);
           m0 = lerp(m0, 0.0, x7);         
           m0 = lerp(m0, 0.20, x8);
          
      float3 MoonVector = normalize(float3(-0.00732, -0.39, 0.317));
      float m1 = saturate(0.001 + dot(normalize(-MoonVector-camdir), -npos.xyz)); 
            m1 = pow(m1, 35.0);
      float3 moon = (m1*m1)*m0*2.0;         
         
      float mix2 = lerp(0.9, 5.0, texelA);         
      float4 texel2 = tex2D(Sampler0, PS.TexCoord);   

      float4 diffuse  = gDiffuseMaterialSource  == 0 ? ColorCar  : 0;


      float Stg = ((texel.a <=0.9999) || PS.Material);

      float4 DiffAmb = PS.AmbC*2.0;
    if (Stg) DiffAmb = ColorCar*0.6;
         
      float4 finalColor2 = float4((DiffAmb.rgb)*texel2.rgb*0.9, min(diffuse.a, texel2.a));  
         
      float3 specmix2 = lerp(specular3*1.5, specular3*finalColor2*1.5, 2.5); 
          

     float factor3 = 0.1 - dot(-vView, npos);
           factor3 = pow(factor3, 0.65);
     float fr3 = (factor3*factor3); 
           fr3/= 2.5; 
           fr3 = saturate(fr3*0.2);   
           fr3 = lerp(1.0, fr3, 0.35);        

             finalColor2.rgb*= fr3;           
          
             finalColor2.rgb*= (lighting);                   
             finalColor2.rgb+= specmix2*bl0*0.7; 
             finalColor2.rgb+= moon*float3(1.85, 1.95, 1.1)*0.5;
             finalColor2.rgb+= saturate(lerp(fresnelz*2.3, finalColor2.xyz*fresnelz*1.1, 0.92)*0.7);                 


    float3 v = {0.6, 0.6, 0.95};  
    
    float3 n = normalize(npos.xyz*v);      
    float3 ref0 = reflect(vView.xyz, n.xyz);             
    float3 ref2 = (1.0*ref0)/0.5;   
    
    float3 r0 = (vView.xyz+ref2)*0.95;    
    float2 r1 = wpd2(r0.xyz);     
      
      float2 rc = r1.xy;      
      
      float4 envMap = tex2D(SamplerColor, rc);


      float c08 = 6.7;
      float c07 = 1.0;

      float nf02 = saturate(c08*(r1.y));
            nf02*= saturate(c08*(r1.x));                  
            nf02 = pow(nf02, c07);            

      
      float fresnelR = 0.01-dot(npos, -camdir);       
            fresnelR = saturate(pow(fresnelR, 4.0));  

              cb = lerp(cb, envMap.xyz*3.3,  envMap.w*nf02*pow(0.01*0.5, fresnelR));
              float4 vinyl = tex2D( VinylSampler, PS.TexCoord );
              float fixed = 0.475 + vinyl.a;
      float3 reflection = lerp(m_fixed*fixed*cb+(sp0*4.0), finalColor2.rgb, 0.97*fresnel);
   

      
      // float brightnessFactor = ( vinyl.a > 0 ) ? 0.2 : 0.4;
      float brightnessFactor = 0.4 - 0.2*vinyl.a;
      float3 vRef = reflection * (brightnessFactor + ( 0.6 * (1-vinyl.a)));
                  
      finalColor2.rgb = lerp(finalColor2.rgb+float3(10.92, 10.96, 10.0), vRef, Stg); 
                   
        finalColor2.rgb += vinyl.rgb;

      float3 TM0 = GetCorrection(finalColor2.rgb*light);
      float3 TM1 = Uncharted2Tonemap(finalColor2.rgb*light);    
             finalColor2.rgb = lerp(TM0, TM1, 1);            
      
             finalColor2.rgb = pow(finalColor2.rgb, 1.8);

             finalColor2.a*= ColorCar.a;

      return finalColor2;
  }


  technique tec0
  {
      pass P0
      {
          VertexShader = compile vs_3_0 VertexShaderFunction();   
          PixelShader = compile ps_3_0 PS_Reflection();
      }
  }

  technique fallback
  {
      pass P0
      {}
  }
]=]

ShaderSources.chrome = [=[

float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gWorldView : WORLDVIEW;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gViewInverse : VIEWINVERSE;
float4x4 gWorldInverseTranspose : WORLDINVERSETRANSPOSE;
float4x4 gViewInverseTranspose : VIEWINVERSETRANSPOSE;

float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraDirection : CAMERADIRECTION;

float gTime : TIME;

float4 gLightAmbient : LIGHTAMBIENT;
float4 gLightDiffuse : LIGHTDIFFUSE;
float4 gLightSpecular : LIGHTSPECULAR;
float3 gLightDirection = float3(0.35, 0.35, -0.35);

int gLighting                      < string renderState="LIGHTING"; >;                      

float4 gGlobalAmbient              < string renderState="AMBIENT"; >;                   

int gDiffuseMaterialSource         < string renderState="DIFFUSEMATERIALSOURCE"; >;           
int gSpecularMaterialSource        < string renderState="SPECULARMATERIALSOURCE"; >;          
int gAmbientMaterialSource         < string renderState="AMBIENTMATERIALSOURCE"; >;           
int gEmissiveMaterialSource        < string renderState="EMISSIVEMATERIALSOURCE"; >;          

float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialSpecular    < string materialState="Specular"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;
float gMaterialSpecPower    < string materialState="Power"; >;

texture gTexture0           < string textureState="0,Texture"; >;
texture gTexture1           < string textureState="1,Texture"; >;
texture gTexture2           < string textureState="2,Texture"; >;
texture gTexture3           < string textureState="3,Texture"; >;

int gDeclNormal             < string vertexDeclState="Normal"; >;   

texture paintJobTexture;
texture temp_paintJobTexture;
sampler VinylSampler = sampler_state
{
    Texture         = (paintJobTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler temp_VinylSampler = sampler_state
{
    Texture         = (temp_paintJobTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

float MTAUnlerp( float from, float to, float pos )
{
    if ( from == to )
        return 1.0;
    else
        return ( pos - from ) / ( to - from );
}

float4 MTACalcScreenPosition( float3 InPosition )
{
    float4 posWorld = mul(float4(InPosition,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    return mul(posWorldView, gProjection);
}

float3 MTACalcWorldPosition( float3 InPosition )
{
    return mul(float4(InPosition,1), gWorld).xyz;
}

float3 MTACalcWorldNormal( float3 InNormal )
{
    return mul(InNormal, (float3x3)gWorld);
}

float4 MTACalcGTABuildingDiffuse( float4 InDiffuse )
{
    float4 OutDiffuse;

    if ( !gLighting )
    {
        OutDiffuse = InDiffuse;
    }
    else
    {
        float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
        float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
        float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
        OutDiffuse = gGlobalAmbient * saturate( ambient + emissive );
        OutDiffuse.a *= diffuse.a;
    }
    return OutDiffuse;
}

float4 MTACalcGTAVehicleDiffuse( float3 WorldNormal, float4 InDiffuse )
{
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
    float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;

    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );

    float DirectionFactor = max( 0.2, (dot(WorldNormal, -gLightDirection) + 1)/2 );
    float4 TotalDiffuse = ( diffuse * gLightDiffuse * DirectionFactor );

    float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
    OutDiffuse.a *= diffuse.a;

    return OutDiffuse;
}

float3 MTACalculateCameraDirection( float3 CamPos, float3 InWorldPos )
{
    return normalize( InWorldPos - CamPos );
}

float MTACalcCameraDistance( float3 CamPos, float3 InWorldPos )
{
    return distance( InWorldPos, CamPos );
}

float MTACalculateSpecular( float3 CamDir, float3 LightDir, float3 SurfNormal, float SpecPower )
{
    LightDir = normalize(LightDir);
    SurfNormal = normalize(SurfNormal);
    float3 halfAngle = normalize(-CamDir - LightDir);
    float r = dot(halfAngle, SurfNormal);
    return pow(saturate(r), SpecPower);
}

int CUSTOMFLAGS
<
#ifdef GENERATE_NORMALS
    string createNormals = "yes";           
#endif
    string skipUnusedParameters = "yes";  
>;

void MTAFixUpNormal( out float3 OutNormal )
{
    if ( !gDeclNormal )
        OutNormal = float3(0,0,1); 
}

texture sReflectionTexture;
texture sRandomTexture;

float brightnessFactor = 0.25;
float4 paintColor2 = float4(0, 0, 0, 0);
float4 specularColor = float4(0, 0, 0, 0);
float share = 40;
float multiply = 3.2;

sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
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

samplerCUBE ReflectionSampler = sampler_state
{
   Texture = (sReflectionTexture);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   MIPMAPLODBIAS = 0.000000;
};

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
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
    float3 SparkleTex : TEXCOORD6;
    float4 Specular   : COLOR1;
};


PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    float3 worldPosition = MTACalcWorldPosition( VS.Position );
    float3 viewDirection = normalize(gCameraPosition - worldPosition);

    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );
    PS.TexCoord = VS.TexCoord;
    PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );
    PS.NormalSurf = VS.Normal;
    PS.View = viewDirection;
    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 4.0;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 4.0;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 4.0;

    PS.Specular.rgb = gMaterialSpecular.rgb*MTACalculateSpecular(gCameraDirection, gLightDirection, PS.Normal, 1000) * paintColor2 / 300;
    PS.Diffuse = MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );

    return PS;
}


float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 blickColor = MTACalculateSpecular(gCameraDirection, gLightDirection, PS.Normal, 10000) * specularColor / 300;

    float4 OutColor = 1;

    float microflakePerturbation = 0;
    float normalPerturbation = 0.0;
    float microflakePerturbationA = 0;

    float4 base = gMaterialAmbient;
    float4 paintColorMid;
    float4 paintColor2;
    float4 paintColor0;
    float4 flakeLayerColor;

    paintColorMid = base;
    paintColor2.r = base.g / 2 + base.b / 2;
    paintColor2.g = (base.r / 2 + base.b / 2);
    paintColor2.b = base.r / 2 + base.g / 2;

    paintColor0.r = base.r / 2 + base.g / 2;
    paintColor0.g = (base.g / 2 + base.b / 2);
    paintColor0.b = base.b / 2 + base.r / 2;

    flakeLayerColor.r = base.r / 2 + base.b / 2;
    flakeLayerColor.g = (base.g / 2 + base.r / 2);
    flakeLayerColor.b = base.b / 2 + base.g / 2;


    float3 vNormal = PS.Normal;

    float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;

    vFlakesNormal = 2 * vFlakesNormal - 1.0;

    float3 vNp1 = microflakePerturbationA * vFlakesNormal + normalPerturbation * vNormal ;

    float3 vNp2 = microflakePerturbation * ( vFlakesNormal + vNormal ) ;

    float3 vView = normalize( PS.View );

    float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent, PS.Binormal, PS.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, vNormal ));

    float fNdotV = saturate(dot( vNormalWorld, vView));
    
    
    float3 Nn = normalize(vNormal);
    float3 Vn = PS.View; 
    float3 vReflection = reflect(Vn,Nn);
    
      vReflection.xy += vNp2.xy * 0.2;
      vReflection.xyz = vReflection.xzy;
    float4 envMap = texCUBE( ReflectionSampler, -vReflection );

    envMap.rgb = envMap.rgb * envMap.rgb * envMap.rgb;

    envMap.rgb *= brightnessFactor;
    
    float4 maptex = tex2D(Sampler0,PS.TexCoord.xy);
    
    float3 vNp1World = normalize( mul( mTangentToWorld, vNp1) );
    float fFresnel1 = saturate( dot( vNp1World, vView ));

    float3 vNp2World = normalize( mul( mTangentToWorld, vNp2 ));
    float fFresnel2 = saturate( dot( vNp2World, vView ));

    float fFresnel1Sq = fFresnel1 * fFresnel1;

    float4 paintColor = fFresnel1 * paintColor0 +
        fFresnel1Sq * paintColorMid +
        fFresnel1Sq * fFresnel1Sq +
        pow( fFresnel2, 32 ) * flakeLayerColor;

    float fEnvContribution = 1.0 - 0.5 * fNdotV;

    float4 finalColor;
    finalColor = envMap * fEnvContribution + paintColor;
    finalColor.a = 1.0;

    float4 Color = 1;
    Color = finalColor / 1 + PS.Diffuse / multiply;
    Color += finalColor * PS.Diffuse * share;
    Color.a = 500.3;
    Color.rgb += PS.Specular.rgb;
    Color.a = PS.Diffuse.a;

    float4 cColor = Color;
    float4 vColor = tex2D(VinylSampler, PS.TexCoord);
    float4 temp_vColor = tex2D(temp_VinylSampler, PS.TexCoord);

    float4 fColor = cColor;

    if(vColor.a){
        fColor = ( fColor * (1 - vColor.a) ) + vColor;
        float4 Color = 1;
        finalColor = envMap * fEnvContribution;
        finalColor.a = 1.0;
        Color = (finalColor - paintColor) / 1;
        Color.rgb += PS.Specular.rgb*2;
        Color.a = PS.Diffuse.a;
        fColor += Color;
    }
  
    return fColor;
}

technique carpaint_fix_v2
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}


technique fallback
{
    pass P0
    {}
}

]=]


ShaderSources.perlamutr = [=[

#include "assets/shader/mta-helper.fx"

texture sReflectionTexture;
texture sRandomTexture;
texture paintJobTexture;
texture temp_paintJobTexture;

float4 specularColor = float4(1,1,1,1);
float specularValue = 6;
float share = 30;
float multiply = 2.2;


sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler VinylSampler = sampler_state
{
    Texture         = (paintJobTexture);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
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

samplerCUBE ReflectionSampler = sampler_state
{
   Texture = (sReflectionTexture);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   MIPMAPLODBIAS = 0.000000;
};

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
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
    float3 SparkleTex : TEXCOORD6;
    float4 Specular : COLOR1;
};


PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    float3 worldPosition = MTACalcWorldPosition( VS.Position );
    float3 viewDirection = normalize(gCameraPosition - worldPosition);

    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );
    PS.TexCoord = VS.TexCoord;
    PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );
    PS.NormalSurf = VS.Normal;
    PS.View = viewDirection;
    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 4.0;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 4.0;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 4.0;

    PS.Specular.rgb = gMaterialSpecular.rgb * MTACalculateSpecular( gCameraDirection*1000000, gLightDirection *1.5,
        PS.Normal, gMaterialSpecPower ) * specularValue;

    PS.Specular *= specularColor / 250;

    PS.Diffuse = MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 OutColor = 1;

    // Some settings for something or another
    float microflakePerturbation = 0;
    float brightnessFactor = 0.5;
    float normalPerturbation = 0.0;
    float microflakePerturbationA = 0;

    float4 base = gMaterialAmbient;
    float4 paintColorMid;
    float4 paintColor2;
    float4 paintColor0;
    float4 flakeLayerColor;

    paintColorMid = base;
    paintColor2.r = base.g / 2 + base.b / 2;
    paintColor2.g = (base.r / 2 + base.b / 2);
    paintColor2.b = base.r / 2 + base.g / 2;

    paintColor0.r = base.r / 2 + base.g / 2;
    paintColor0.g = (base.g / 2 + base.b / 2);
    paintColor0.b = base.b / 2 + base.r / 2;

    flakeLayerColor.r = base.r / 2 + base.b / 2;
    flakeLayerColor.g = (base.g / 2 + base.r / 2);
    flakeLayerColor.b = base.b / 2 + base.g / 2;

    float3 vNormal = PS.Normal;

    float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;

    vFlakesNormal = 2 * vFlakesNormal - 1.0;
    float3 vNp1 = microflakePerturbationA * vFlakesNormal + normalPerturbation * vNormal ;

    float3 vNp2 = microflakePerturbation * ( vFlakesNormal + vNormal ) ;

    float3 vView = normalize( PS.View );

    float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent, PS.Binormal, PS.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, vNormal ));

    float fNdotV = saturate(dot( vNormalWorld, vView));
     
    float3 Nn = normalize(vNormal);
    float3 Vn = PS.View; 
    float3 vReflection = reflect(Vn,Nn);
    vReflection.xy += vNp2.xy * 0.2;
    vReflection.xyz = vReflection.xzy;
    float4 envMap = texCUBE( ReflectionSampler, -vReflection );

    envMap.rgb = envMap.rgb * envMap.rgb * envMap.rgb;

    envMap.rgb *= brightnessFactor;

    float4 maptex = tex2D(Sampler0,PS.TexCoord.xy);
    
    float3 vNp1World = normalize( mul( mTangentToWorld, vNp1) );
    float fFresnel1 = saturate( dot( vNp1World, vView ));
    float3 vNp2World = normalize( mul( mTangentToWorld, vNp2 ));
    float fFresnel2 = saturate( dot( vNp2World, vView ));
    float fFresnel1Sq = fFresnel1 * fFresnel1;

    float4 paintColor = fFresnel1 * paintColor0 +
        fFresnel1Sq * paintColorMid +
        fFresnel1Sq * fFresnel1Sq * paintColor2 +
        pow( fFresnel2, 32 ) * flakeLayerColor;
    float fEnvContribution = 1.0 - 0.5 * fNdotV;

    float4 finalColor;
    finalColor = envMap * fEnvContribution + paintColor;
    finalColor.a = 1.0;
    float4 Color = 1;
    Color = finalColor / 1 + PS.Diffuse / 1;
    Color += finalColor * PS.Diffuse * 0.5;
    Color.rgb += PS.Specular.rgb/3.5;
    Color.a = PS.Diffuse.a;

    float4 cColor = Color;
    float4 vColor = tex2D(VinylSampler, PS.TexCoord);
    float4 temp_vColor = tex2D(temp_VinylSampler, PS.TexCoord);

    float4 fColor = cColor;

    if(vColor.a){
        fColor = ( fColor * (1 - vColor.a) ) + vColor;
        float4 Color = 1;
        finalColor = envMap * fEnvContribution;
        finalColor.a = 1.0;
        Color = (finalColor - paintColor) / 1;
        Color.rgb += PS.Specular.rgb/5;
        Color.a = PS.Diffuse.a;
        fColor += Color;
    }
   
    return fColor;
}

technique carpaint_fix_v2
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {}
}


]=]