// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X
Shader "PlanetCrust"
{
	Properties
	{
		[NoScaleOffset] _ColorTexture("Color Texture", 2D) = "gray" {}
		[Toggle]_EnableClouds("Enable Clouds", Float) = 1
		_PolarMask("Polar Mask", 2D) = "white" {}
		[NoScaleOffset]_NecessaryWaterMask("Necessary Water Mask", 2D) = "black" {}
		[NoScaleOffset]_CloudsTexture("CloudsTexture", 2D) = "black" {}
		_CitiesTexture("Cities Texture", 2D) = "black" {}
		[HDR]_ColorA("Color + A", Color) = (4.541205,4.541205,4.541205,0.3607843)
		_CloudSpeed("Cloud Speed", Float) = 1
		_ShadowsYOffset("Shadows Y Offset", Range(-0.02 , 0.02)) = -0.005
		_ShadowsXOffset("Shadows X Offset", Range(-0.02 , 0.02)) = -0.005
		_ShadowsSharpness("Shadows Sharpness", Range(0 , 10)) = 2.5
		[Toggle]_EnableCities("Enable Cities", Float) = 1
		[HDR]_Citiescolor("Cities color", Color) = (7.906699,2.649365,1.200494,0)
		[HDR]_AtmosphereColor("Atmosphere Color", Color) = (0.3764706,1.027451,1.498039,0)
		_InteriorSize("Interior Size", Range(-2 , 10)) = 0.3
		_IlluminationSmoothness("Illumination Smoothness", Float) = 4
		_InteriorIntensity("Interior Intensity", Range(0 , 1)) = 0.65
		_IlluminationAmbient("Illumination Ambient", Color) = (0.09019608,0.06666667,0.1490196,0)
		_LightSource("_LightSource", Vector) = (1,0,0,0)
		[Toggle]_EnableAtmosphere("Enable Atmosphere", Float) = 1
		_CitiesDetail("Cities Detail", Range(1 , 20)) = 4
		_EnumFloat("_EnumFloat", Float) = 0
		_WaterColor("Water Color", Color) = (0.282353,0.4431373,0.5176471,0)
		_SpecularIntensity("Specular Intensity", Range(0 , 1)) = 1
		_Normals("Normals", 2D) = "bump" {}
		_NormalsIntensity("Normals Intensity", Range(0 , 2)) = 1
		[Toggle]_EnableWater("Enable Water", Float) = 1
		_CloudsNormals("Clouds Normals", 2D) = "bump" {}
		_BaseColormodifier("Base Color modifier", Color) = (1,1,1,0)
		_ShadowColorA("Shadow Color + A", Color) = (0.09803922,0.2313726,0.4117647,1)
		_ReliefIntensity("ReliefIntensity", Float) = 2
		_ReliefSmoothness("Relief Smoothness", Range(0 , 5)) = 2
		_IlluminationBoost("Illumination Boost", Float) = 1
		_SkyblendA("Sky blend (A)", Color) = (0.5529412,0.6845676,0.7843137,0)
		[HideInInspector] _texcoord("", 2D) = "white" {}
	}

		SubShader
	{
		Tags { "RenderType" = "Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0

		Pass
		{
			Name "Unlit"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
		//only defining to not throw compilation error over Unity 5.5
		#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
		#endif
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_instancing
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityStandardBRDF.cginc"

		struct appdata
		{
			float4 vertex : POSITION;
			float4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
			float4 ase_texcoord : TEXCOORD0;
			float4 ase_tangent : TANGENT;
			float3 ase_normal : NORMAL;
		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			UNITY_VERTEX_INPUT_INSTANCE_ID
			UNITY_VERTEX_OUTPUT_STEREO
			float4 ase_texcoord : TEXCOORD0;
			float4 ase_texcoord1 : TEXCOORD1;
			float4 ase_texcoord2 : TEXCOORD2;
			float4 ase_texcoord3 : TEXCOORD3;
			float4 ase_texcoord4 : TEXCOORD4;
		};

		uniform sampler2D _ColorTexture;
		uniform float4 _BaseColormodifier;
		uniform float4 _WaterColor;
		uniform float _EnableWater;
		uniform sampler2D _NecessaryWaterMask;
		uniform float4 _ShadowColorA;
		uniform float _EnableClouds;
		uniform sampler2D _CloudsTexture;
		uniform float _ShadowsXOffset;
		uniform float _ShadowsYOffset;
		uniform float _CloudSpeed;
		uniform float _ShadowsSharpness;
		uniform float4 _ColorA;
		uniform sampler2D _PolarMask;
		uniform float4 _PolarMask_ST;
		uniform float _EnumFloat;
		uniform float4 _IlluminationAmbient;
		uniform float _ReliefIntensity;
		uniform sampler2D _CloudsNormals;
		uniform float _ReliefSmoothness;
		uniform float _NormalsIntensity;
		uniform sampler2D _Normals;
		uniform float3 _LightSource;
		uniform float _IlluminationSmoothness;
		uniform float _EnableCities;
		uniform sampler2D _CitiesTexture;
		uniform float _CitiesDetail;
		uniform float4 _Citiescolor;
		uniform float _EnableAtmosphere;
		uniform float _InteriorSize;
		uniform float _InteriorIntensity;
		uniform float4 _AtmosphereColor;
		uniform float _SpecularIntensity;
		uniform float4 _SkyblendA;
		uniform float _IlluminationBoost;

		v2f vert(appdata v)
		{
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			UNITY_TRANSFER_INSTANCE_ID(v, o);

			float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
			o.ase_texcoord1.xyz = ase_worldTangent;
			float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
			o.ase_texcoord2.xyz = ase_worldNormal;
			float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
			float3 ase_worldBitangent = cross(ase_worldNormal, ase_worldTangent) * ase_vertexTangentSign;
			o.ase_texcoord3.xyz = ase_worldBitangent;
			float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			o.ase_texcoord4.xyz = ase_worldPos;

			o.ase_texcoord.xy = v.ase_texcoord.xy;

			//setting value to unused interpolator channels and avoid initialization warnings
			o.ase_texcoord.zw = 0;
			o.ase_texcoord1.w = 0;
			o.ase_texcoord2.w = 0;
			o.ase_texcoord3.w = 0;
			o.ase_texcoord4.w = 0;
			float3 vertexValue = float3(0, 0, 0);
			#if ASE_ABSOLUTE_VERTEX_POS
			vertexValue = v.vertex.xyz;
			#endif
			vertexValue = vertexValue;
			#if ASE_ABSOLUTE_VERTEX_POS
			v.vertex.xyz = vertexValue;
			#else
			v.vertex.xyz += vertexValue;
			#endif
			o.vertex = UnityObjectToClipPos(v.vertex);
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			UNITY_SETUP_INSTANCE_ID(i);
			UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
			fixed4 finalColor;
			float2 uv_ColorTexture61 = i.ase_texcoord.xy;
			float4 BaseColor2300 = (tex2D(_ColorTexture, uv_ColorTexture61) * _BaseColormodifier);
			float4 WaterColor2302 = _WaterColor;
			float4 blendOpSrc2099 = BaseColor2300;
			float4 blendOpDest2099 = WaterColor2302;
			float WaterTransparency2306 = _WaterColor.a;
			float4 lerpResult2121 = lerp(BaseColor2300 , (saturate(((blendOpDest2099 > 0.5) ? (1.0 - 2.0 * (1.0 - blendOpDest2099) * (1.0 - blendOpSrc2099)) : (2.0 * blendOpDest2099 * blendOpSrc2099)))) , WaterTransparency2306);
			float4 lerpResult2120 = lerp(lerpResult2121 , WaterColor2302 , WaterTransparency2306);
			float4 BaseAndWater2266 = lerpResult2120;
			float2 uv_NecessaryWaterMask82 = i.ase_texcoord.xy;
			float clampResult2089 = clamp((((_EnableWater) ? (tex2D(_NecessaryWaterMask, uv_NecessaryWaterMask82).b) : (0.0)) * 10.0) , 0.0 , 1.0);
			float ContinentalMasks2284 = clampResult2089;
			float4 lerpResult1895 = lerp(BaseColor2300 , BaseAndWater2266 , ContinentalMasks2284);
			float3 desaturateInitialColor2417 = lerpResult1895.rgb;
			float desaturateDot2417 = dot(desaturateInitialColor2417, float3(0.299, 0.587, 0.114));
			float3 desaturateVar2417 = lerp(desaturateInitialColor2417, desaturateDot2417.xxx, 0.3);
			float2 appendResult2178 = (float2(_ShadowsXOffset , _ShadowsYOffset));
			float2 uv0455 = i.ase_texcoord.xy * float2(1,1) + appendResult2178;
			float temp_output_161_0 = (_CloudSpeed / 80.0);
			float4 appendResult453 = (float4(temp_output_161_0 , 0.0 , 0.0 , 0.0));
			float4 UVcloudShadows2246 = (float4(uv0455, 0.0 , 0.0) + (appendResult453 * _Time.x));
			float4 tex2DNode442 = tex2Dlod(_CloudsTexture, float4(UVcloudShadows2246.xy, 0, _ShadowsSharpness));
			float temp_output_2422_0 = ((tex2DNode442.b + tex2DNode442.b) * 5.0);
			float CloudsAlpha2253 = _ColorA.a;
			float clampResult2147 = clamp((((_EnableClouds) ? (1.0) : (0.0)) * temp_output_2422_0 * CloudsAlpha2253) , 0.0 , 1.0);
			float CloudsShadows2248 = clampResult2147;
			float2 uv_PolarMask = i.ase_texcoord.xy * _PolarMask_ST.xy + _PolarMask_ST.zw;
			float4 PolarMask2271 = tex2D(_PolarMask, uv_PolarMask);
			float4 lerpResult1816 = lerp(float4(desaturateVar2417 , 0.0) , _ShadowColorA , ((CloudsShadows2248 * PolarMask2271) * _ShadowColorA.a));
			float4 CloudsColor2252 = _ColorA;
			float2 uv032 = i.ase_texcoord.xy * float2(1,1) + float2(0,0);
			float4 appendResult41 = (float4(temp_output_161_0 , 0.0 , 0.0 , 0.0));
			float4 UVClouds2243 = (float4(uv032, 0.0 , 0.0) + (appendResult41 * _Time.x));
			float lerpResult1886 = lerp(tex2D(_CloudsTexture, UVClouds2243.xy).g , _EnumFloat , 0.0);
			float saferPower2060 = max(lerpResult1886 , 0.0001);
			float Clouds2262 = ((0.0 + (pow(saferPower2060 , 0.5) - 0.0) * (CloudsAlpha2253 - 0.0) / (1.0 - 0.0)) * ((_EnableClouds) ? (1.0) : (0.0)));
			float4 lerpResult66 = lerp(lerpResult1816 , (0.5 * CloudsColor2252) , (PolarMask2271 * Clouds2262));
			float4 AmbientColor2337 = _IlluminationAmbient;
			float4 color2445 = IsGammaSpace() ? float4(0.5294118,0.2701871,0.2038235,0) : float4(0.2422812,0.05933543,0.0343086,0);
			float2 uv02073 = i.ase_texcoord.xy * float2(1,1) + float2(0,0);
			float3 FlatNormal2287 = float3(0,0,1);
			float3 lerpResult2094 = lerp(UnpackScaleNormal(tex2D(_Normals, uv02073), ((0.0 + (_NormalsIntensity - 0.0) * (1.0 - 0.0) / (2.0 - 0.0)) * 0.25)) , FlatNormal2287 , ContinentalMasks2284);
			float clampResult535 = clamp((3.0 * Clouds2262) , 0.0 , 1.0);
			float CloudsOcclusion2258 = (1.0 - clampResult535);
			float3 lerpResult2093 = lerp(UnpackScaleNormal(tex2Dlod(_CloudsNormals, float4(UVClouds2243.xy, 0, _ReliefSmoothness)), (_ReliefIntensity * CloudsAlpha2253)) , lerpResult2094 , CloudsOcclusion2258);
			float3 Normals2236 = lerpResult2093;
			float3 ase_worldTangent = i.ase_texcoord1.xyz;
			float3 ase_worldNormal = i.ase_texcoord2.xyz;
			float3 ase_worldBitangent = i.ase_texcoord3.xyz;
			float3 tanToWorld0 = float3(ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x);
			float3 tanToWorld1 = float3(ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y);
			float3 tanToWorld2 = float3(ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z);
			float3 tanNormal246 = Normals2236;
			float3 worldNormal246 = normalize(float3(dot(tanToWorld0,tanNormal246), dot(tanToWorld1,tanNormal246), dot(tanToWorld2,tanNormal246)));
			float3 normalizeResult1073 = normalize(_LightSource);
			float3 LightSourceVector2314 = (normalizeResult1073 / 1.0);
			float dotResult247 = dot(worldNormal246 , LightSourceVector2314);
			float smoothstepResult2359 = smoothstep(0.0 , 1.0 , (dotResult247 + 0.5));
			float BaselLightMask2332 = smoothstepResult2359;
			float temp_output_380_0 = pow(BaselLightMask2332 , _IlluminationSmoothness);
			float clampResult2452 = clamp((((temp_output_380_0 + -0.5) * (1.0 - BaselLightMask2332)) * 10.0) , 0.0 , 1.0);
			float4 lerpResult2450 = lerp(AmbientColor2337 , color2445 , clampResult2452);
			float4 temp_cast_7 = (temp_output_380_0).xxxx;
			float4 lerpResult2409 = lerp(lerpResult2450 , temp_cast_7 , temp_output_380_0);
			float4 NightDayMask2292 = lerpResult2409;
			float4 temp_cast_8 = (0.0).xxxx;
			float2 temp_cast_9 = (_CitiesDetail).xx;
			float2 uv0175 = i.ase_texcoord.xy * temp_cast_9 + float2(0,0);
			float2 uv02431 = i.ase_texcoord.xy * float2(1,1) + float2(0,0);
			float clampResult1926 = clamp(ContinentalMasks2284 , 0.0 , 1.0);
			float3 desaturateInitialColor2410 = (1.0 - (NightDayMask2292 * 5.0)).rgb;
			float desaturateDot2410 = dot(desaturateInitialColor2410, float3(0.299, 0.587, 0.114));
			float3 desaturateVar2410 = lerp(desaturateInitialColor2410, desaturateDot2410.xxx, 1.0);
			float3 clampResult1716 = clamp(desaturateVar2410 , float3(0,0,0) , float3(1,1,1));
			float3 ase_worldPos = i.ase_texcoord4.xyz;
			float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
			ase_worldViewDir = normalize(ase_worldViewDir);
			float dotResult1665 = dot(ase_worldViewDir , ase_worldNormal);
			float FresnelMask2228 = dotResult1665;
			float saferPower2161 = max(FresnelMask2228 , 0.0001);
			float4 Cities2297 = ((_EnableCities) ? (((float4((((((tex2D(_CitiesTexture, uv0175).r * (1.0 - tex2D(_CitiesTexture, uv02431).a)) * (1.0 - clampResult1926)) * clampResult1716) * pow(saferPower2161 , 4.0)) * CloudsOcclusion2258) , 0.0) * _Citiescolor) * 1.0)) : (temp_cast_8));
			float4 color1829 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 normalizedWorldNormal = normalize(ase_worldNormal);
			float3 normalizeResult2313 = normalize((ase_worldViewDir + LightSourceVector2314));
			float3 SpecularDir2317 = normalizeResult2313;
			float3 saferPower2411 = max(SpecularDir2317 , 0.0001);
			float fresnelNdotV9 = dot(normalize(normalizedWorldNormal), ase_worldViewDir);
			float fresnelNode9 = (0.0 + 1.0 * pow(max(1.0 - fresnelNdotV9 , 0.0001), ((1.0 - (pow(saferPower2411 , 3.0) + -1.0)) + _InteriorSize).x));
			float3 temp_cast_13 = (fresnelNode9).xxx;
			float3 temp_cast_14 = (fresnelNode9).xxx;
			float3 linearToGamma2139 = LinearToGammaSpace(temp_cast_14);
			float4 BaseColorAtmospheres2278 = _AtmosphereColor;
			float dotResult1708 = dot(LightSourceVector2314 , normalizedWorldNormal);
			float smoothstepResult2379 = smoothstep(-0.4 , 1.0 , dotResult1708);
			float AtmosphereLightMask2225 = smoothstepResult2379;
			float clampResult1769 = clamp(AtmosphereLightMask2225 , 0.0 , 1.0);
			float saferPower1768 = max(clampResult1769 , 0.0001);
			float smoothstepResult1594 = smoothstep(0.0 , 1.0 , pow(saferPower1768 , 1.5));
			float4 clampResult702 = clamp(((float4(((linearToGamma2139 * (_InteriorIntensity + (1.0 - (0.0 + (_InteriorSize - -2.0) * (1.0 - 0.0) / (10.0 - -2.0))))) * _InteriorIntensity) , 0.0) * BaseColorAtmospheres2278) * smoothstepResult1594) , float4(0,0,0,0) , float4(1,1,1,0));
			float3 gammaToLinear2462 = GammaToLinearSpace(((_EnableAtmosphere) ? (clampResult702) : (color1829)).rgb);
			float3 SubAtmosphere2241 = gammaToLinear2462;
			float4 blendOpSrc2361 = ((lerpResult66 * NightDayMask2292) + (Cities2297 * PolarMask2271));
			float4 blendOpDest2361 = float4(SubAtmosphere2241 , 0.0);
			float dotResult1867 = dot(ase_worldNormal , SpecularDir2317);
			float clampResult2045 = clamp(dotResult1867 , 0.0 , 1.0);
			float saferPower2438 = max(clampResult2045 , 0.0001);
			float temp_output_2438_0 = pow(saferPower2438 , 2.0);
			ase_worldViewDir = Unity_SafeNormalize(ase_worldViewDir);
			float dotResult1570 = dot(LightSourceVector2314 , ase_worldViewDir);
			float ViewDotLight2231 = dotResult1570;
			float clampResult1903 = clamp((ViewDotLight2231 + 0.1) , 0.0 , 1.0);
			float lerpResult1901 = lerp(200.0 , 2000.0 , clampResult1903);
			float3 temp_cast_19 = ((pow(temp_output_2438_0 , (lerpResult1901 * (0.0 + (0.5 - 0.0) * (1.0 - 0.0) / (30.0 - 0.0)))) * 0.5)).xxx;
			float3 temp_cast_20 = ((pow(temp_output_2438_0 , (lerpResult1901 * (0.0 + (0.5 - 0.0) * (1.0 - 0.0) / (30.0 - 0.0)))) * 0.5)).xxx;
			float3 gammaToLinear2113 = GammaToLinearSpace(temp_cast_20);
			float clampResult1906 = clamp(ViewDotLight2231 , 0.0 , 1.0);
			float lerpResult2466 = lerp(0.25 , _SpecularIntensity , clampResult1906);
			float4 temp_output_2155_0 = (((_EnableWater) ? (tex2D(_NecessaryWaterMask, uv_NecessaryWaterMask82).b) : (0.0)) * (((float4(gammaToLinear2113 , 0.0) * (temp_output_2438_0 * WaterColor2302)) * CloudsOcclusion2258) * (lerpResult2466 * 100.0)));
			float4 Specular2319 = temp_output_2155_0;
			float4 lerpResult2525 = lerp(((1.0 - (1.0 - blendOpSrc2361) * (1.0 - blendOpDest2361)) + (Specular2319 * PolarMask2271)) , _SkyblendA , _SkyblendA.a);
			float4 SecondPassInput2324 = (lerpResult2525 * _IlluminationBoost);

			finalColor = SecondPassInput2324;
			return finalColor;
		}
		ENDCG
	}
	}
		CustomEditor "PlanetXEditor"
}
/*ASEBEGIN
Version=17700
-1673;210;1666;974;10469.1;10917.35;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;122;-12659.65,-7697.097;Inherit;False;1312.706;1020.046;Cloud movement;17;2246;456;454;455;453;2178;34;33;41;42;160;564;161;563;40;32;2243;Clouds UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;563;-12622.42,-7662.021;Inherit;False;201;166;Material Property;1;28;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-12625.33,-7475.477;Float;False;Constant;_modifier;modifier;18;0;Create;True;0;0;False;0;80;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-12597.17,-7606.665;Float;False;Property;_CloudSpeed;Cloud Speed;8;0;Create;True;0;0;False;0;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-12640.96,-7244.907;Float;False;Constant;_Verticalspeed0;Vertical speed (0);5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;161;-12394.13,-7485.896;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-12228.66,-7475.644;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TimeNode;33;-12243.04,-7247.981;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-12003.43,-7474.401;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;208;-15157.7,-7744.09;Inherit;False;2434.595;1132.719;Clouds;5;466;2264;2270;129;526;Clouds Color + Shadows;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-12020.4,-7603.521;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-11723.8,-7506.605;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;2270;-15144.15,-7692.896;Inherit;False;2385.68;386.8506;Clouds Color;5;2262;2060;596;1964;2257;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;596;-15132.18,-7651.999;Inherit;False;547;306;Material Property;2;26;2244;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2310;-16249.37,-8555.08;Inherit;False;714.9688;1606.319;Comment;5;557;594;1943;2251;2339;Base Colors;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2243;-11563.59,-7508.277;Float;False;UVClouds;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;2244;-15101.84,-7581.126;Inherit;False;2243;UVClouds;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;1964;-14541.58,-7653.202;Inherit;False;412;266;Variable to write last cloud choice;3;1886;1888;1887;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2251;-16213.03,-7818.521;Inherit;False;594.042;308.5696;Material Property;3;2252;2253;67;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1888;-14524.72,-7465.979;Float;False;Constant;_Excludevariable;Exclude variable;34;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;67;-16195.95,-7747.401;Float;False;Property;_ColorA;Color + A;7;1;[HDR];Create;True;0;0;False;0;4.541205,4.541205,4.541205,0.3607843;4.721922,4.721922,4.721922,0.3647059;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-14911.07,-7592.108;Inherit;True;Property;_CloudsTexture;CloudsTexture;5;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1887;-14517.54,-7599.963;Float;False;Property;_EnumFloat;_EnumFloat;24;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1886;-14309.58,-7582.202;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;526;-13942.73,-7296.519;Inherit;False;397.6903;251.6304;Clouds enabling. ;3;1838;1837;475;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2253;-15875.98,-7637.017;Float;False;CloudsAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2264;-13509.92,-7670.126;Inherit;False;525.9521;1003.333;Transparency;4;2148;2068;2147;1936;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1838;-13918.53,-7150.852;Float;False;Constant;_Float9;Float 9;31;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2257;-13914.69,-7425.186;Inherit;False;2253;CloudsAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;2060;-13999.54,-7581.726;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1837;-13927.16,-7245.747;Float;False;Constant;_Float0;Float 0;31;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;475;-13764.17,-7220.81;Float;False;Property;_EnableClouds;Enable Clouds;1;0;Create;True;0;0;False;1;;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;2068;-13383.22,-7598.541;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1891;-15151.63,-5269.735;Inherit;False;3397.084;977.5628;Comment;19;2319;2158;2155;2137;83;2260;1900;2309;2113;1957;2101;1958;1955;2308;1952;1954;1929;1973;583;Water Mask + Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;583;-13233.97,-4601.869;Inherit;False;414.3584;267.2147;Material Property;1;82;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2148;-13164.97,-7520.262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1973;-12588.9,-4487.614;Inherit;False;796.1543;170.5496;Sharp Coasts mask;4;2284;2089;1924;1925;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2262;-12973.67,-7519.154;Float;False;Clouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;129;-15117.68,-7295.567;Inherit;False;1153.539;244.7014; (For Specular / Cities / Normals);6;2258;2265;81;535;533;534;Clouds occlusion;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1942;-11463.73,-5648.772;Inherit;False;2185.236;1333.884;Normals;5;2420;2346;1940;2291;2283;Normals maps;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;82;-13220.83,-4544.811;Inherit;True;Property;_NecessaryWaterMask;Necessary Water Mask;4;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1925;-12575.9,-4411.754;Float;False;Constant;_Float4;Float 4;34;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;534;-15097.82,-7231.459;Float;False;Constant;_CloudMasksharpening;Cloud Mask sharpening;26;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2283;-11397.4,-5054.66;Inherit;False;1390.077;633.2299;BaseNormals;10;2073;2286;2289;2261;1918;2163;2157;2164;1919;2426;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;1929;-12807.19,-4565.778;Float;False;Property;_EnableWater;Enable Water;29;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2265;-15074.56,-7139.667;Inherit;False;2262;Clouds;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2291;-11399.54,-5601.941;Inherit;False;554.3193;213;Flat Normals;2;2287;2087;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;533;-14803.2,-7201.568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1919;-11368.36,-4897.312;Float;False;Property;_NormalsIntensity;Normals Intensity;28;0;Create;True;0;0;False;0;1;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1924;-12416.01,-4444.809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2164;-11080.67,-4718.828;Float;False;Constant;_Float27;Float 27;34;0;Create;True;0;0;False;0;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;2087;-11375.8,-5552.197;Float;False;Constant;_FlatNormals;Flat Normals;35;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;1940;-11398.71,-5373.756;Inherit;False;1002.717;297;Clouds Normals;5;2162;1932;2245;2254;2453;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;2089;-12222.1,-4441.783;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;2157;-11064.67,-4897.828;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;535;-14631.04,-7198.73;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1475;-17435.61,-9896.675;Inherit;False;1011.591;371.1455;Light Source Vector from script;5;2314;1074;1075;1073;1977;Light Source Vector;1,0.6068678,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1932;-11357.3,-5294.734;Float;False;Property;_ReliefIntensity;ReliefIntensity;35;0;Create;True;0;0;False;0;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2073;-10869.85,-5010.153;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2163;-10828.67,-4797.828;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2287;-11163.49,-5552.422;Float;False;FlatNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2284;-12046.27,-4447.217;Float;False;ContinentalMasks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2254;-11363.11,-5179.555;Inherit;False;2253;CloudsAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;-14454.61,-7195.697;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2162;-11131.05,-5255.014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2258;-14215.69,-7201.469;Float;False;CloudsOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2426;-10319.39,-4995.889;Inherit;False;234;206;Makes Water flat ;1;2094;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2420;-10792.71,-5343.756;Inherit;False;370;280;loud;1;1930;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1918;-10623.05,-4951.156;Inherit;True;Property;_Normals;Normals;27;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2286;-10593.87,-4559.231;Inherit;False;2284;ContinentalMasks;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2245;-10977.71,-5303.756;Inherit;False;2243;UVClouds;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;2453;-11133.94,-5157.938;Float;False;Property;_ReliefSmoothness;Relief Smoothness;37;0;Create;True;0;0;False;0;2;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1977;-17402.5,-9831.087;Inherit;False;304;234;Input is set via LightSource.cs;1;1072;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2289;-10555.45,-4686.939;Inherit;False;2287;FlatNormal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;2346;-10376,-5377.942;Inherit;False;982.0687;303.3954;Merges + Polar Mask;2;2236;2093;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;1072;-17351.5,-9770.087;Float;False;Property;_LightSource;_LightSource;21;0;Create;True;0;0;False;0;1,0,0;0,-100,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;2261;-10248.2,-5047.321;Inherit;False;2258;CloudsOcclusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2094;-10269.39,-4945.889;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1930;-10741.71,-5293.756;Inherit;True;Property;_CloudsNormals;Clouds Normals;30;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1075;-17054.77,-9692.937;Float;False;Constant;_Float2;Float 2;36;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2093;-9982.032,-5312.667;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1711;-17417.55,-9037.847;Inherit;False;1036.854;2187.761;Comment;7;280;1710;1701;2316;1700;2336;2428;Dir Masks;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;1073;-17030,-9833.597;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2236;-9622.563,-5280.463;Float;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;280;-17400.83,-8990.688;Inherit;False;974.2715;297.7039;Mask Bewteen LightSource and Object;5;247;2329;246;2237;2429;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1074;-16838.9,-9716.261;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2237;-17393.88,-8949.194;Inherit;False;2236;Normals;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2314;-16674.91,-9774.835;Float;False;LightSourceVector;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;246;-17212.05,-8947.399;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;2329;-17386.98,-8790.839;Inherit;False;2314;LightSourceVector;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;247;-17010.46,-8917.536;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2429;-16827.41,-8962.025;Inherit;False;389.0801;265.1631;Softenning controls;4;2332;2359;2408;2371;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2408;-16818.41,-8785.862;Float;False;Constant;_Float10;Float 10;39;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2371;-16803.83,-8915.54;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2359;-16629.33,-8922.025;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;389;-17421.32,-6545.691;Inherit;False;1900.826;620.0812;Illumination Control;6;2292;2334;2335;1988;556;338;Daylight Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2332;-16514.84,-8789.045;Float;False;BaselLightMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;-17214.54,-6242.514;Float;False;Property;_IlluminationSmoothness;Illumination Smoothness;16;0;Create;True;0;0;False;0;4;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1988;-17088.94,-6475.494;Inherit;False;373.0332;285.4538;Illumination transition sharpness;1;380;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2334;-17395.17,-6474.969;Inherit;True;2332;BaselLightMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;380;-16995.78,-6432.195;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2443;-17110.28,-5845.512;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2339;-16199.88,-7205.841;Inherit;False;579;239;Material Property;2;2337;1477;;0,1,0.3426006,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;2449;-17331.2,-5788.58;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2448;-16836.93,-5861.521;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1477;-16165.81,-7155.016;Float;False;Property;_IlluminationAmbient;Illumination Ambient;20;0;Create;True;0;0;False;0;0.09019608,0.06666667,0.1490196,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;2316;-17382.81,-7516.515;Inherit;False;877.8633;355.5818;Specular Dir;5;2317;2313;2312;2315;2311;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2451;-16596.94,-5836.064;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2311;-17353.4,-7461.314;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;2315;-17361.41,-7292.434;Inherit;False;2314;LightSourceVector;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2337;-15868.05,-7150.864;Float;False;AmbientColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;556;-16677.4,-6483.576;Inherit;False;892.7568;494.9407;Illumination Ambient;4;571;2427;2338;2450;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;564;-12642.81,-6952.103;Inherit;False;312.4492;248.2393;Material Property;2;2179;468;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;468;-12614.55,-6902.574;Float;False;Property;_ShadowsXOffset;Shadows X Offset;10;0;Create;True;0;0;False;0;-0.005;-0.007;-0.02;0.02;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2312;-17081.63,-7427.907;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2179;-12610.02,-6797.119;Float;False;Property;_ShadowsYOffset;Shadows Y Offset;9;0;Create;True;0;0;False;0;-0.005;-0.0139;-0.02;0.02;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2338;-16566.86,-6181.972;Inherit;False;2337;AmbientColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2445;-16585.96,-6074.917;Float;False;Constant;_EvenigColor;EvenigColor;38;0;Create;True;0;0;False;0;0.5294118,0.2701871,0.2038235,0;0.531,0.3682662,0.234171,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;2452;-16291.06,-5838.896;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1700;-17388.2,-7897.825;Inherit;False;891.5458;346.1274;Angle Between Light Source and Camera ;4;2231;1570;1569;2327;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;453;-12240.06,-7003.085;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;2427;-16063.34,-6442.896;Inherit;False;256;212;Ambient VS base darkness;1;2409;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;2178;-12240.52,-6822.945;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;2313;-16948.69,-7425.201;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;2450;-16181.21,-6138.076;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2409;-15994.34,-6406.896;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2317;-16765.64,-7431.273;Float;False;SpecularDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2327;-17364.58,-7845.761;Inherit;False;2314;LightSourceVector;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;124;-15131.68,-8579.566;Inherit;False;2822.225;602.326;Sub atmosphere;18;601;1829;702;555;1975;1622;1976;948;1621;13;2227;2279;2419;2139;2387;2412;2413;2430;Sub Atmosphere ;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;128;-15151.59,-6421.425;Inherit;False;3420.514;837.4136;Cities in the dark;15;2297;554;1948;1947;2064;175;1944;245;1946;188;1945;2424;2431;2432;2439;Cities;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1569;-17340.49,-7723.034;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;455;-12054.79,-6822.338;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;454;-11965.82,-7000.063;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;594;-16241.98,-8502.446;Inherit;False;691.3867;341.1844;Material Property;4;2415;2416;61;2300;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;1570;-17071.66,-7823.651;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;188;-13761.65,-6365.68;Inherit;False;231.6719;716.6461;No Cities in day light;7;1763;728;2294;707;1716;689;2410;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1945;-15147.04,-6364.012;Inherit;False;315;131;Material Property;1;1841;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2292;-15738.65,-6436.248;Float;False;NightDayMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;456;-11747.3,-6813.399;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;2387;-15112.39,-8477.703;Inherit;False;2317;SpecularDir;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;466;-15132.58,-7029.313;Inherit;False;2396.097;388.1884;Cloud Shadows;8;2248;442;2247;2058;561;2349;2350;2464;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1954;-15117.96,-4870.455;Inherit;False;778.3203;529.9019;Glossiness;7;1879;1882;1883;1902;1857;1901;1953;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1975;-15110.6,-8527.225;Inherit;False;788.6973;302.0889;Reduce size if zenith;5;2392;2411;2393;2389;2388;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1763;-13746.71,-5831.856;Float;False;Constant;_SharpenNightMask;Sharpen Night Mask;32;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2392;-14938.67,-8375.231;Float;False;Constant;_Float17;Float 17;37;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;245;-14023.38,-6368.506;Inherit;False;238.1333;725.5773;No cities on water;4;1842;1927;1926;2295;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2231;-16796.4,-7797.805;Float;False;ViewDotLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1701;-17389.55,-8327.575;Inherit;False;904.2393;398.7203;Hand made fresnel;4;2228;1665;1673;1668;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1943;-16205.7,-8143.584;Inherit;False;616.2021;280;Material Property;3;2302;2306;1894;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1946;-14822.56,-6096.485;Inherit;False;343.6299;273.4307;Alpha Mask to diluate obvious tiling;1;2423;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1841;-15123.36,-6316.136;Float;False;Property;_CitiesDetail;Cities Detail;23;0;Create;True;0;0;False;0;4;3.12;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2431;-15077.36,-6045.402;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;2411;-14924.6,-8485.695;Inherit;False;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;3;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1953;-15106.5,-4558.052;Inherit;False;525;205;Soften glossiness if not Zenith;4;2235;2151;2150;1903;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2294;-13745.83,-5741.679;Inherit;False;2292;NightDayMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;61;-16231.34,-8457.444;Inherit;True;Property;_ColorTexture;Color Texture;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;561;-15109.5,-6857.829;Inherit;False;298;131;Material Property;1;469;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1710;-17394.17,-8680.757;Inherit;False;910.5537;332.3206;Custom mask for atmohsphere;6;2225;1708;1709;2328;2379;2380;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2246;-11594.06,-6792.14;Float;False;UVcloudShadows;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;2416;-15903.64,-8331.59;Float;False;Property;_BaseColormodifier;Base Color modifier;32;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;469;-15087.66,-6813.576;Float;False;Property;_ShadowsSharpness;Shadows Sharpness;11;0;Create;True;0;0;False;0;2.5;3.71;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2415;-15900.95,-8450.578;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;555;-15025.72,-8193.22;Inherit;False;361;165;Material Property;1;12;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2295;-14012.27,-5738.575;Inherit;False;2284;ContinentalMasks;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1709;-17327.16,-8507.39;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;1944;-14560.91,-6376.494;Inherit;False;445;253;Material Property;1;45;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2235;-15099.31,-4510.691;Inherit;False;2231;ViewDotLight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2247;-15104.1,-6957.985;Inherit;False;2246;UVcloudShadows;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;2423;-14779.61,-6038.303;Inherit;True;Property;_Cities;Cities;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Instance;45;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;2428;-16974.45,-8642.517;Inherit;False;245;297.0039;Mask Softening;1;2381;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2328;-17377.47,-8607.233;Inherit;False;2314;LightSourceVector;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1894;-16184.95,-8079.943;Float;False;Property;_WaterColor;Water Color;25;0;Create;True;0;0;False;0;0.282353,0.4431373,0.5176471,0;0.1845441,0.2316618,0.267,0.2392157;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;175;-14796.34,-6333.112;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2151;-15089.97,-4436.149;Float;False;Constant;_Float26;Float 26;34;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;728;-13709.54,-5929.314;Inherit;False;2;2;0;COLOR;1,0,0,0;False;1;FLOAT;20;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1952;-15118.53,-5217.89;Inherit;False;767.3174;332.6244;Specular Vectors (ViewDir + LightDir . Normals);6;2045;2318;1867;1865;2438;2437;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;1673;-17346.7,-8090.409;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;2393;-14766.78,-8482.632;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1668;-17355.63,-8273.235;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;2150;-14896.97,-4477.149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2308;-12878.22,-5220.577;Inherit;False;1084.347;465.8962;BaseColor + Water Color / Transparency;7;2307;2266;2120;2304;2121;2099;2303;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1976;-14309.08,-8542.838;Inherit;False;435;322;Main input for Sub atmosphere;2;9;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-14999.31,-8139.044;Float;False;Property;_InteriorSize;Interior Size;15;0;Create;True;0;0;False;0;0.3;0.83;-2;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2318;-15092.33,-5013.957;Inherit;False;2317;SpecularDir;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;45;-14528.54,-6325.884;Inherit;True;Property;_CitiesTexture;Cities Texture;6;0;Create;False;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;2389;-14626.61,-8480.714;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;2058;-14320.49,-6951.143;Inherit;False;232.7578;211.6535;Shadows boost;2;2422;2425;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2380;-16946.22,-8475.353;Float;False;Constant;_Float13;Float 13;38;0;Create;True;0;0;False;0;-0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1865;-15098.05,-5179.687;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;2302;-15887.31,-8086.441;Float;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;707;-13721.23,-6003.631;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1926;-13975.77,-5954.298;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1708;-17083.06,-8583.538;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;442;-14774.31,-6946.222;Inherit;True;Property;_CloudsTexture2;Clouds Texture2;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Instance;26;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;2432;-14430.47,-5916.303;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1665;-17070.16,-8200.806;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2300;-15765.75,-8449.721;Float;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2381;-16942.03,-8401.513;Float;False;Constant;_Float14;Float 14;39;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2464;-14450.24,-6914.023;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1867;-14864.15,-5128.149;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2064;-13514.57,-6362.318;Inherit;False;231.8281;706.8076;No Cities on edge ;3;2161;2062;2230;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1902;-15074.67,-4823.534;Float;False;Constant;_2;2;33;0;Create;True;0;0;False;0;200;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2379;-16927.45,-8604.517;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2303;-12865.61,-5165.323;Inherit;False;2300;BaseColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2388;-14457.68,-8487.395;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2425;-14273.91,-6810.929;Float;False;Constant;_Float3;Float 3;40;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;19;-14289.4,-8501.213;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;2413;-14544.24,-8181.021;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-2;False;2;FLOAT;10;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2306;-15894.45,-7978.801;Float;False;WaterTransparency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1621;-14199.7,-8159.607;Inherit;False;361;165;Material Property;1;949;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;1927;-13981.92,-6118.956;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1903;-14752.5,-4480.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1857;-15069.58,-4739.847;Float;False;Constant;_SpecularSharpness2;Specular Sharpness2;31;0;Create;True;0;0;False;0;2000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1879;-15069.85,-4644.163;Float;False;Constant;_SpecularSharpness;Specular Sharpness;24;0;Create;True;0;0;False;0;0.5;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2228;-16765.21,-8201.188;Float;False;FresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;2410;-13722.36,-6105.958;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2304;-12857.67,-4947.767;Inherit;False;2302;WaterColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2424;-14209.19,-6208.755;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;949;-14151.7,-8095.608;Float;False;Property;_InteriorIntensity;Interior Intensity;19;0;Create;True;0;0;False;0;0.65;0.57;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;2045;-14626.69,-5110.487;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;9;-14100.27,-8491.563;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1901;-14644.41,-4830.865;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2422;-14256.45,-6914.651;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1882;-14557.44,-4649.357;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;30;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1842;-13968.72,-6305.434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2225;-16722.84,-8607.304;Float;False;AtmosphereLightMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1716;-13703.82,-6226.714;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2230;-13497.68,-5747.744;Inherit;False;2228;FresnelMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;557;-16209.13,-7467.671;Inherit;False;579;239;Material Property;2;15;2278;;0,1,0.3426006,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;2099;-12627.29,-5077.791;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2430;-13815.38,-8303.486;Inherit;False;204;183;Binds size to intensity;1;2414;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;2412;-14349.64,-8196.383;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2307;-12623.2,-4879.747;Inherit;False;2306;WaterTransparency;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1622;-13284.65,-8544.76;Inherit;False;305.6674;534.3516;Daylight Mask controls;4;1769;1334;1594;1768;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2414;-13765.38,-8253.486;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1883;-14458.08,-4819.057;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2336;-17377.64,-7147.769;Inherit;False;868.9688;278.249;Polar Mask;2;2167;2271;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;2161;-13469.91,-6048.259;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2227;-13547.61,-8132.695;Inherit;False;2225;AtmosphereLightMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearToGammaNode;2139;-13812.6,-8424.61;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1936;-13405.9,-6918.841;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1947;-13265.47,-6369.133;Inherit;False;231.6289;705.7809;No Cities under clouds;2;1845;2259;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1948;-13006.16,-6354.479;Inherit;False;651.2393;391.6387;Cities Color and boost;4;1789;1790;46;558;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;2438;-14459.41,-5092.103;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1958;-14300.38,-4859.711;Inherit;False;997.3287;511.567;Intensity;2;1960;1959;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;15;-16165.5,-7416.567;Float;False;Property;_AtmosphereColor;Atmosphere Color;14;1;[HDR];Create;True;0;0;False;0;0.3764706,1.027451,1.498039,0;0.5114095,1.597196,2.029403,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1955;-14307.02,-5219.537;Inherit;False;196.7705;218.352;Merge Glossiness + Specular;1;1869;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;689;-13692.61,-6316.513;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;2121;-12374.57,-5150.844;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1769;-13215.39,-8142.931;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2062;-13466.75,-6316.605;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;1869;-14286.31,-5113.259;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2120;-12216.1,-4971.718;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;2147;-13211.98,-6919.149;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2167;-17315.21,-7096.127;Inherit;True;Property;_PolarMask;Polar Mask;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2278;-15888.48,-7387.636;Float;False;BaseColorAtmospheres;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;948;-13580.95,-8354.701;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1959;-14296.15,-4813.011;Inherit;False;696.2002;352.2983;Intensity = 1 only in Zenith;5;1906;2234;1896;2466;2467;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1982;-15134.72,-10903.04;Inherit;False;5191.454;670.9656;Comment;7;2326;467;1990;138;1980;2454;2522;Second Shader Pass Outputs merges;1,0.1275665,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2101;-14073.81,-5216.334;Inherit;False;292.6709;213.1317;No loss of intensity if sharpnened;1;1860;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;558;-12993.31,-6217.246;Inherit;False;255;228.5527;Material Property;1;47;;0,1,0.345098,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2259;-13252.19,-5748.619;Inherit;False;2258;CloudsOcclusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1845;-13207.29,-6305.539;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2234;-14247.19,-4557.698;Inherit;False;2231;ViewDotLight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1860;-13998.56,-5153.041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2271;-16909.04,-7093.964;Float;False;PolarMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2279;-13849.34,-8530.383;Inherit;False;2278;BaseColorAtmospheres;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;1768;-13204.38,-8259.369;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2248;-12968.14,-6834.092;Float;False;CloudsShadows;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1957;-13480.25,-5214.31;Inherit;False;234.1953;212.1979;Include Water Color;1;2135;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1980;-15100.64,-10812.19;Inherit;False;689.4355;382.7268; Water + Base;5;2301;1895;2267;2322;2417;;1,0.08972871,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2309;-14148.75,-4958.148;Inherit;False;2302;WaterColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2266;-12016.79,-4973.039;Float;False;BaseAndWater;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;467;-14357.5,-10810.85;Inherit;False;614.9385;392.8515;Cloud Shadows + Base ;5;1816;2249;2433;2455;2463;;1,0.08789868,0,1;0;0
Node;AmplifyShaderEditor.ColorNode;47;-12977.81,-6172.349;Float;False;Property;_Citiescolor;Cities color;13;1;[HDR];Create;True;0;0;False;0;7.906699,2.649365,1.200494,0;29.50885,18.53959,10.96926,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2419;-13479.72,-8260.185;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1594;-13234.67,-8393.112;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1906;-13983.59,-4555.344;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1896;-14186.95,-4748.272;Float;False;Property;_SpecularIntensity;Specular Intensity;26;0;Create;True;0;0;False;0;1;0.455;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2301;-15063.49,-10757.41;Inherit;False;2300;BaseColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2467;-14092.1,-4673.351;Float;False;Constant;_Float1;Float 1;40;0;Create;True;0;0;False;0;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;554;-12326.31,-6357.611;Inherit;False;254.9438;307.1033;Cities Toggle;2;492;493;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-12682.56,-6300.57;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2322;-15078.69,-10543.6;Inherit;False;2284;ContinentalMasks;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2267;-15067.47,-10647.88;Inherit;False;2266;BaseAndWater;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GammaToLinearNode;2113;-13724.47,-5176.049;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1790;-12704.43,-6117.967;Float;False;Constant;_Potentialboost;Potential boost;32;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2135;-13417.5,-5126.975;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1960;-13556.48,-4812.011;Inherit;False;225.5615;349.6675;Artificial boost;2;1911;1890;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2454;-14328.08,-10404.92;Inherit;False;2271;PolarMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2249;-14371.55,-10523.94;Inherit;False;2248;CloudsShadows;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-13421.31,-8531.129;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2466;-13750.1,-4659.351;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1890;-13540.09,-4640.237;Float;False;Constant;_Float16;Float 16;35;0;Create;True;0;0;False;0;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2433;-14339.15,-10707.98;Float;False;Property;_ShadowColorA;Shadow Color + A;33;0;Create;True;0;0;False;0;0.09803922,0.2313726,0.4117647,1;0,0.08400001,0.252,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1900;-13201.38,-5179.973;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1334;-13198.35,-8510.665;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1895;-14833.31,-10683.04;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2252;-15880.19,-7742.705;Float;False;CloudsColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;138;-13709.75,-10813.52;Inherit;False;710.8407;479.5965;Main Clouds + previous;7;2273;66;2168;2263;2144;2255;2145;;1,0.05270513,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2455;-14114.08,-10524.92;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;493;-12257.13,-6161.739;Float;False;Constant;_Float7;Float 7;27;0;Create;True;0;0;False;0;0;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1789;-12512.46,-6300.087;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2260;-13449.33,-4962.337;Inherit;False;2258;CloudsOcclusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2273;-13659.32,-10527.43;Inherit;False;2271;PolarMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2263;-13657.18,-10434.99;Inherit;False;2262;Clouds;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;702;-12793.88,-8475.345;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-13032.17,-5074.892;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;492;-12282.92,-6295.417;Float;False;Property;_EnableCities;Enable Cities;12;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2255;-13664.49,-10616.29;Inherit;False;2252;CloudsColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1829;-12805.7,-8289.4;Float;False;Constant;_Color4;Color 4;31;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;2417;-14602.05,-10770.71;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.3;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2145;-13627.62,-10705.95;Float;False;Constant;_Float25;Float 25;34;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1990;-12929.01,-10819.39;Inherit;False;2229.833;494.3665;Custom Masks;7;2323;1951;1950;390;2458;2460;2523;;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2463;-13974.28,-10628.41;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1911;-13471.57,-4774.653;Inherit;False;2;2;0;FLOAT;6;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;390;-12897.85,-10777.72;Inherit;False;501.6515;352.6001;Color result + Daylight  mask;2;673;2293;;1,0.1204694,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2144;-13425.56,-10669.58;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2168;-13382.13,-10462.25;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1950;-12379.61,-10771.61;Inherit;False;401.837;339.1981;+ Cities with custom mask;3;1713;2298;2457;;1,0,0.02689171,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2137;-12808.71,-4759.931;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;601;-12530.9,-8427.839;Float;False;Property;_EnableAtmosphere;Enable Atmosphere;22;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1816;-13956.95,-10771.01;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2297;-12035.06,-6299.368;Float;False;Cities;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2155;-12553.18,-4731.939;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2293;-12835.62,-10489.77;Inherit;False;2292;NightDayMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;66;-13179.85,-10772.38;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2458;-12383.01,-10489.3;Inherit;False;2271;PolarMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2298;-12376.01,-10592.23;Inherit;False;2297;Cities;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GammaToLinearNode;2462;-12215.54,-8546.258;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2241;-12201.35,-8410.255;Float;False;SubAtmosphere;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2319;-12065.26,-4736.195;Float;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2457;-12151.01,-10543.3;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;673;-12629.47,-10739.24;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2323;-11502.63,-10769.5;Inherit;False;623.6577;353.3621;+ Specular with custom mask;3;2131;2320;2459;;1,0,0.02568626,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1951;-11950.44,-10766.55;Inherit;False;422.5713;332.9393;+ Sub atmosphere with custom mask;2;2361;2242;;1,0,0.02568626,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2460;-11531.7,-10493.38;Inherit;False;2271;PolarMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2242;-11946.76,-10520.51;Inherit;False;2241;SubAtmosphere;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2320;-11509.11,-10610.07;Inherit;False;2319;Specular;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1713;-12138.03,-10742.29;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;2361;-11748.92,-10710.39;Inherit;False;Screen;False;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2459;-11357.7,-10589.38;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2131;-11198.59,-10706.4;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2526;-10940.75,-11075.03;Inherit;False;Property;_SkyblendA;Sky blend (A);39;0;Create;True;0;0;False;0;0.5529412,0.6845676,0.7843137,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1246;-15134.25,-10012.06;Inherit;False;3207.77;1197.935;Atmosphere Emissive + Vertex Offset;7;2221;2222;1250;1252;1585;2434;2435;Atmosphere ;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2523;-10883.44,-10521.39;Inherit;False;Property;_IlluminationBoost;Illumination Boost;38;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2525;-10602.75,-11027.03;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1585;-15073.46,-9427.041;Inherit;False;1530.697;503.61;Fine tuning of Dir mask;1;1617;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2326;-10513.22,-10756.84;Inherit;False;359.2549;335.6558;Comment;1;2324;Second shader pass Input;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1252;-15094.43,-9961.995;Inherit;False;2693.273;464.8405;Atmosphere Controls ;18;1267;1269;1268;1460;1529;1661;1667;1274;1262;1273;1663;1280;1664;1666;1702;1703;2229;2280;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2522;-10657.44,-10671.39;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2335;-17049.29,-6132.756;Inherit;False;288;160;In Case of needed;1;1718;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1617;-15062.59,-9365.307;Inherit;False;1495.317;370.623;Mask controls for Atmosphere;10;1470;1469;1467;1723;2226;2233;2395;2394;2397;2398;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1702;-15082.97,-9692.757;Inherit;False;346;136;Material Property;1;1259;;0,1,0.3411765,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2324;-10425.13,-10700.69;Float;False;SecondPassInput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1983;-9687.83,-10597.12;Inherit;False;746.2273;389.1991;Comment;2;2325;2528;Second shader pass output;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;571;-16662.43,-6355.427;Inherit;False;301.9512;136;Material Property;1;476;;0,1,0.3411765,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1703;-14222.88,-9686.037;Inherit;False;346;136;Material Property;1;1272;;0,1,0.3411765,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1250;-12941.57,-9434.355;Inherit;False;554.1529;385.2613;Vertex offset;4;1514;1510;1528;1506;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2222;-12327.91,-9307.317;Float;False;AtmosphereSize;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2325;-9586.177,-10409.79;Inherit;False;2324;SecondPassInput;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1259;-15076.06,-9648.552;Float;False;Property;_ExteriorSize;Exterior Size;18;0;Create;True;0;0;False;0;0.3;0.827;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1529;-14674.25,-9761.331;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3;False;4;FLOAT;3.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;476;-16638.29,-6306.357;Float;False;Property;_IlluminationAmbientold;Illumination Ambient old;17;0;Create;True;0;0;False;0;0.25;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2349;-14028.13,-6786.979;Float;False;Property;_ShadowsIntensity;Shadows Intensity;31;0;Create;True;0;0;False;0;0.6;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1663;-14715.11,-9893.468;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;4.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1667;-14443.25,-9895.241;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1272;-14167.38,-9635.589;Float;False;Property;_ExteriorIntensity;Exterior Intensity;2;0;Create;True;0;0;False;0;0.25;0.606;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1723;-14601.13,-9325.754;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;1510;-12713.83,-9254.736;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2437;-14752.24,-4919.257;Float;False;Property;_SpecularSize;Specular Size;34;0;Create;True;0;0;False;0;1;1.2;0.1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1460;-13372.92,-9748.858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GammaToLinearNode;2435;-12410.17,-9840.402;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;1528;-12890.58,-9379.737;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearToGammaNode;2434;-12408.17,-9663.402;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2398;-14580.22,-9149.671;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2439;-15065.88,-6202.104;Float;False;Property;_CitiesSharpness;Cities Sharpness;36;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2229;-15067.76,-9781.079;Inherit;False;2228;FresnelMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2397;-14370.07,-9098.456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearToGammaNode;2461;-12219.54,-8664.258;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1470;-14265.56,-9301.319;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1262;-13800.3,-9909.157;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1467;-14010.16,-9306.373;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1514;-12579.77,-9338.986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2226;-14991.09,-9076.862;Inherit;False;2225;AtmosphereLightMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;1267;-12673.65,-9762.638;Float;False;Property;_EnableAtmosphere;Enable Atmosphere;22;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2394;-14166.38,-9155.127;Float;False;Constant;_Float15;Float 15;38;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2233;-14989.27,-9302.414;Inherit;False;2231;ViewDotLight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1273;-14032.72,-9914.423;Float;False;Constant;_Color2;Color 2;39;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2395;-14175.38,-9069.126;Float;False;Constant;_Float18;Float 18;39;0;Create;True;0;0;False;0;20;16.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2221;-12196.95,-9759.704;Float;False;AtmosphereColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1269;-12883.79,-9929.286;Float;False;Constant;_Color0;Color 0;39;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GammaToLinearNode;1718;-16999.29,-6082.756;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1664;-14201.67,-9875.524;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1268;-12867.23,-9742.53;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;2158;-12320.95,-4632.946;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2280;-13362.26,-9891.03;Inherit;False;2278;BaseColorAtmospheres;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;1469;-13780.65,-9307.252;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;1661;-15058.67,-9885.161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1506;-12900.8,-9197.917;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;1666;-14907.59,-9885.247;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1280;-13061.77,-9770.036;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GammaToLinearNode;1274;-13623.5,-9887.753;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2350;-13686,-6831;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2528;-9214.122,-10416.51;Float;False;True;-1;2;PlanetXEditor;100;1;PlanetCrust;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;161;0;28;0
WireConnection;161;1;160;0
WireConnection;41;0;161;0
WireConnection;41;1;42;0
WireConnection;34;0;41;0
WireConnection;34;1;33;1
WireConnection;40;0;32;0
WireConnection;40;1;34;0
WireConnection;2243;0;40;0
WireConnection;26;1;2244;0
WireConnection;1886;0;26;2
WireConnection;1886;1;1887;0
WireConnection;1886;2;1888;0
WireConnection;2253;0;67;4
WireConnection;2060;0;1886;0
WireConnection;475;0;1837;0
WireConnection;475;1;1838;0
WireConnection;2068;0;2060;0
WireConnection;2068;4;2257;0
WireConnection;2148;0;2068;0
WireConnection;2148;1;475;0
WireConnection;2262;0;2148;0
WireConnection;1929;1;82;3
WireConnection;533;0;534;0
WireConnection;533;1;2265;0
WireConnection;1924;0;1929;0
WireConnection;1924;1;1925;0
WireConnection;2089;0;1924;0
WireConnection;2157;0;1919;0
WireConnection;535;0;533;0
WireConnection;2163;0;2157;0
WireConnection;2163;1;2164;0
WireConnection;2287;0;2087;0
WireConnection;2284;0;2089;0
WireConnection;81;0;535;0
WireConnection;2162;0;1932;0
WireConnection;2162;1;2254;0
WireConnection;2258;0;81;0
WireConnection;1918;1;2073;0
WireConnection;1918;5;2163;0
WireConnection;2094;0;1918;0
WireConnection;2094;1;2289;0
WireConnection;2094;2;2286;0
WireConnection;1930;1;2245;0
WireConnection;1930;2;2453;0
WireConnection;1930;5;2162;0
WireConnection;2093;0;1930;0
WireConnection;2093;1;2094;0
WireConnection;2093;2;2261;0
WireConnection;1073;0;1072;0
WireConnection;2236;0;2093;0
WireConnection;1074;0;1073;0
WireConnection;1074;1;1075;0
WireConnection;2314;0;1074;0
WireConnection;246;0;2237;0
WireConnection;247;0;246;0
WireConnection;247;1;2329;0
WireConnection;2371;0;247;0
WireConnection;2359;0;2371;0
WireConnection;2359;2;2408;0
WireConnection;2332;0;2359;0
WireConnection;380;0;2334;0
WireConnection;380;1;338;0
WireConnection;2443;0;380;0
WireConnection;2449;0;2334;0
WireConnection;2448;0;2443;0
WireConnection;2448;1;2449;0
WireConnection;2451;0;2448;0
WireConnection;2337;0;1477;0
WireConnection;2312;0;2311;0
WireConnection;2312;1;2315;0
WireConnection;2452;0;2451;0
WireConnection;453;0;161;0
WireConnection;453;1;42;0
WireConnection;2178;0;468;0
WireConnection;2178;1;2179;0
WireConnection;2313;0;2312;0
WireConnection;2450;0;2338;0
WireConnection;2450;1;2445;0
WireConnection;2450;2;2452;0
WireConnection;2409;0;2450;0
WireConnection;2409;1;380;0
WireConnection;2409;2;380;0
WireConnection;2317;0;2313;0
WireConnection;455;1;2178;0
WireConnection;454;0;453;0
WireConnection;454;1;33;1
WireConnection;1570;0;2327;0
WireConnection;1570;1;1569;0
WireConnection;2292;0;2409;0
WireConnection;456;0;455;0
WireConnection;456;1;454;0
WireConnection;2231;0;1570;0
WireConnection;2411;0;2387;0
WireConnection;2246;0;456;0
WireConnection;2415;0;61;0
WireConnection;2415;1;2416;0
WireConnection;2423;1;2431;0
WireConnection;175;0;1841;0
WireConnection;728;0;2294;0
WireConnection;728;1;1763;0
WireConnection;2393;0;2411;0
WireConnection;2393;1;2392;0
WireConnection;2150;0;2235;0
WireConnection;2150;1;2151;0
WireConnection;45;1;175;0
WireConnection;2389;0;2393;0
WireConnection;2302;0;1894;0
WireConnection;707;0;728;0
WireConnection;1926;0;2295;0
WireConnection;1708;0;2328;0
WireConnection;1708;1;1709;0
WireConnection;442;1;2247;0
WireConnection;442;2;469;0
WireConnection;2432;0;2423;4
WireConnection;1665;0;1668;0
WireConnection;1665;1;1673;0
WireConnection;2300;0;2415;0
WireConnection;2464;0;442;3
WireConnection;2464;1;442;3
WireConnection;1867;0;1865;0
WireConnection;1867;1;2318;0
WireConnection;2379;0;1708;0
WireConnection;2379;1;2380;0
WireConnection;2379;2;2381;0
WireConnection;2388;0;2389;0
WireConnection;2388;1;12;0
WireConnection;2413;0;12;0
WireConnection;2306;0;1894;4
WireConnection;1927;0;1926;0
WireConnection;1903;0;2150;0
WireConnection;2228;0;1665;0
WireConnection;2410;0;707;0
WireConnection;2424;0;45;1
WireConnection;2424;1;2432;0
WireConnection;2045;0;1867;0
WireConnection;9;0;19;0
WireConnection;9;3;2388;0
WireConnection;1901;0;1902;0
WireConnection;1901;1;1857;0
WireConnection;1901;2;1903;0
WireConnection;2422;0;2464;0
WireConnection;2422;1;2425;0
WireConnection;1882;0;1879;0
WireConnection;1842;0;2424;0
WireConnection;1842;1;1927;0
WireConnection;2225;0;2379;0
WireConnection;1716;0;2410;0
WireConnection;2099;0;2303;0
WireConnection;2099;1;2304;0
WireConnection;2412;0;2413;0
WireConnection;2414;0;949;0
WireConnection;2414;1;2412;0
WireConnection;1883;0;1901;0
WireConnection;1883;1;1882;0
WireConnection;2161;0;2230;0
WireConnection;2139;0;9;0
WireConnection;1936;0;475;0
WireConnection;1936;1;2422;0
WireConnection;1936;2;2257;0
WireConnection;2438;0;2045;0
WireConnection;689;0;1842;0
WireConnection;689;1;1716;0
WireConnection;2121;0;2303;0
WireConnection;2121;1;2099;0
WireConnection;2121;2;2307;0
WireConnection;1769;0;2227;0
WireConnection;2062;0;689;0
WireConnection;2062;1;2161;0
WireConnection;1869;0;2438;0
WireConnection;1869;1;1883;0
WireConnection;2120;0;2121;0
WireConnection;2120;1;2304;0
WireConnection;2120;2;2307;0
WireConnection;2147;0;1936;0
WireConnection;2278;0;15;0
WireConnection;948;0;2139;0
WireConnection;948;1;2414;0
WireConnection;1845;0;2062;0
WireConnection;1845;1;2259;0
WireConnection;1860;0;1869;0
WireConnection;1860;1;1879;0
WireConnection;2271;0;2167;0
WireConnection;1768;0;1769;0
WireConnection;2248;0;2147;0
WireConnection;2266;0;2120;0
WireConnection;2419;0;948;0
WireConnection;2419;1;949;0
WireConnection;1594;0;1768;0
WireConnection;1906;0;2234;0
WireConnection;46;0;1845;0
WireConnection;46;1;47;0
WireConnection;2113;0;1860;0
WireConnection;2135;0;2438;0
WireConnection;2135;1;2309;0
WireConnection;13;0;2419;0
WireConnection;13;1;2279;0
WireConnection;2466;0;2467;0
WireConnection;2466;1;1896;0
WireConnection;2466;2;1906;0
WireConnection;1900;0;2113;0
WireConnection;1900;1;2135;0
WireConnection;1334;0;13;0
WireConnection;1334;1;1594;0
WireConnection;1895;0;2301;0
WireConnection;1895;1;2267;0
WireConnection;1895;2;2322;0
WireConnection;2252;0;67;0
WireConnection;2455;0;2249;0
WireConnection;2455;1;2454;0
WireConnection;1789;0;46;0
WireConnection;1789;1;1790;0
WireConnection;702;0;1334;0
WireConnection;83;0;1900;0
WireConnection;83;1;2260;0
WireConnection;492;0;493;0
WireConnection;492;1;1789;0
WireConnection;2417;0;1895;0
WireConnection;2463;0;2455;0
WireConnection;2463;1;2433;4
WireConnection;1911;0;2466;0
WireConnection;1911;1;1890;0
WireConnection;2144;0;2145;0
WireConnection;2144;1;2255;0
WireConnection;2168;0;2273;0
WireConnection;2168;1;2263;0
WireConnection;2137;0;83;0
WireConnection;2137;1;1911;0
WireConnection;601;0;1829;0
WireConnection;601;1;702;0
WireConnection;1816;0;2417;0
WireConnection;1816;1;2433;0
WireConnection;1816;2;2463;0
WireConnection;2297;0;492;0
WireConnection;2155;0;1929;0
WireConnection;2155;1;2137;0
WireConnection;66;0;1816;0
WireConnection;66;1;2144;0
WireConnection;66;2;2168;0
WireConnection;2462;0;601;0
WireConnection;2241;0;2462;0
WireConnection;2319;0;2155;0
WireConnection;2457;0;2298;0
WireConnection;2457;1;2458;0
WireConnection;673;0;66;0
WireConnection;673;1;2293;0
WireConnection;1713;0;673;0
WireConnection;1713;1;2457;0
WireConnection;2361;0;1713;0
WireConnection;2361;1;2242;0
WireConnection;2459;0;2320;0
WireConnection;2459;1;2460;0
WireConnection;2131;0;2361;0
WireConnection;2131;1;2459;0
WireConnection;2525;0;2131;0
WireConnection;2525;1;2526;0
WireConnection;2525;2;2526;4
WireConnection;2522;0;2525;0
WireConnection;2522;1;2523;0
WireConnection;2324;0;2522;0
WireConnection;2222;0;1514;0
WireConnection;1529;0;1259;0
WireConnection;1663;0;1666;0
WireConnection;1663;1;1529;0
WireConnection;1667;0;1663;0
WireConnection;1723;0;2233;0
WireConnection;1510;0;1506;0
WireConnection;1460;0;1469;0
WireConnection;1460;1;1274;0
WireConnection;2435;0;1267;0
WireConnection;1528;0;1259;0
WireConnection;2434;0;1267;0
WireConnection;2398;0;2233;0
WireConnection;2397;0;2398;0
WireConnection;2397;1;2226;0
WireConnection;1470;0;1723;0
WireConnection;1470;1;2397;0
WireConnection;1262;0;1273;0
WireConnection;1262;1;1664;0
WireConnection;1262;2;1272;0
WireConnection;1467;0;1470;0
WireConnection;1467;1;2394;0
WireConnection;1467;2;2395;0
WireConnection;1514;0;1528;0
WireConnection;1514;1;1510;0
WireConnection;1267;0;1269;0
WireConnection;1267;1;1268;0
WireConnection;2221;0;1267;0
WireConnection;1664;0;1667;0
WireConnection;1268;0;1280;0
WireConnection;2158;0;2155;0
WireConnection;1469;0;1467;0
WireConnection;1661;0;2229;0
WireConnection;1666;0;1661;0
WireConnection;1280;0;2280;0
WireConnection;1280;1;1460;0
WireConnection;1274;0;1262;0
WireConnection;2350;0;2422;0
WireConnection;2350;1;2349;0
WireConnection;2528;0;2325;0
ASEEND*/
//CHKSM=62D676E53912C9D53AC24EC0FD1DBA6015C4E34A