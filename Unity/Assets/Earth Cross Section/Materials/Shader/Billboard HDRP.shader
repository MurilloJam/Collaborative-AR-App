// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X
Shader "Billboard HDRP"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_ColorInfos("Color ", Color) = (1,1,1,0)
		_Size("Size", Range(-1 , 1)) = 0
		[HideInInspector] _texcoord("", 2D) = "white" {}

		[HideInInspector]_EmissionColor("Emission Color", Color) = (1, 1, 1, 1)
		[HideInInspector]_RenderQueueType("Render Queue Type", Float) = 5
		[HideInInspector][ToggleUI]_AddPrecomputedVelocity("Add Precomputed Velocity", Float) = 0.0
		[HideInInspector]_ShadowMatteFilter("Shadow Matte Filter", Float) = 2.006836
		[HideInInspector]_StencilRef("Stencil Ref", Int) = 0
		[HideInInspector]_StencilWriteMask("StencilWrite Mask", Int) = 3
		[HideInInspector]_StencilRefDepth("StencilRefDepth", Int) = 0
		[HideInInspector]_StencilWriteMaskDepth("_StencilWriteMaskDepth", Int) = 32
		[HideInInspector]_StencilRefMV("_StencilRefMV", Int) = 128
		[HideInInspector]_StencilWriteMaskMV("_StencilWriteMaskMV", Int) = 128
		[HideInInspector]_StencilRefDistortionVec("_StencilRefDistortionVec", Int) = 64
		[HideInInspector]_StencilWriteMaskDistortionVec("_StencilWriteMaskDistortionVec", Int) = 64
		[HideInInspector]_StencilWriteMaskGBuffer("_StencilWriteMaskGBuffer", Int) = 3
		[HideInInspector]_StencilRefGBuffer("_StencilRefGBuffer", Int) = 2
		[HideInInspector]_ZTestGBuffer("_ZTestGBuffer", Int) = 4
		[HideInInspector][ToggleUI]_RequireSplitLighting("_RequireSplitLighting", Float) = 0
		[HideInInspector][ToggleUI]_ReceivesSSR("_ReceivesSSR", Float) = 0
		[HideInInspector]_SurfaceType("_SurfaceType", Float) = 1
		[HideInInspector]_BlendMode("_BlendMode", Float) = 0
		[HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
		[HideInInspector]_DstBlend("_DstBlend", Float) = 0
		[HideInInspector]_AlphaSrcBlend("Vec_AlphaSrcBlendtor1", Float) = 1
		[HideInInspector]_AlphaDstBlend("_AlphaDstBlend", Float) = 0
		[HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
		[HideInInspector]_CullMode("Cull Mode", Float) = 2
		[HideInInspector]_TransparentSortPriority("_TransparentSortPriority", Int) = 0
		[HideInInspector]_CullModeForward("_CullModeForward", Float) = 2
		[HideInInspector][Enum(Front, 1, Back, 2)]_TransparentCullMode("_TransparentCullMode", Float) = 2
		[HideInInspector]_ZTestDepthEqualForOpaque("_ZTestDepthEqualForOpaque", Int) = 4
		[HideInInspector][Enum(UnityEngine.Rendering.CompareFunction)]_ZTestTransparent("_ZTestTransparent", Float) = 4
		[HideInInspector][ToggleUI]_TransparentBackfaceEnable("_TransparentBackfaceEnable", Float) = 0
		[HideInInspector][ToggleUI]_AlphaCutoffEnable("_AlphaCutoffEnable", Float) = 0
		[HideInInspector]_AlphaCutoff("Alpha Cutoff", Range(0, 1)) = 0.5
		[HideInInspector][ToggleUI]_UseShadowThreshold("_UseShadowThreshold", Float) = 0
		[HideInInspector][ToggleUI]_DoubleSidedEnable("_DoubleSidedEnable", Float) = 0
		[HideInInspector][Enum(Flip, 0, Mirror, 1, None, 2)]_DoubleSidedNormalMode("_DoubleSidedNormalMode", Float) = 2
		[HideInInspector]_DoubleSidedConstants("_DoubleSidedConstants", Vector) = (1, 1, -1, 0)
	}

		SubShader
		{
			LOD 0

			Tags { "RenderPipeline" = "HDRenderPipeline" "RenderType" = "Transparent" "Queue" = "Transparent" }

			HLSLINCLUDE
			#pragma target 4.5
			#pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
			ENDHLSL

			Pass
			{
				Name "Forward Unlit"
				Tags { "LightMode" = "ForwardOnly" }

				Blend[_SrcBlend][_DstBlend] ,[_AlphaSrcBlend][_AlphaDstBlend]
				Cull[_CullMode]
				ZTest[_ZTestTransparent]
				ZWrite[_ZWrite]

				Stencil
				{
					Ref[_StencilRef]
					WriteMask[_StencilWriteMask]
					Comp Always
					Pass Replace
					Fail Keep
					ZFail Keep
				}

				HLSLPROGRAM

				#pragma multi_compile_instancing
				#define _ENABLE_FOG_ON_TRANSPARENT 1
				#define HAVE_MESH_MODIFICATION 1
				#define ASE_SRP_VERSION 60900

				#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
				#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

				#pragma vertex Vert
				#pragma fragment Frag

				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

				#define SHADERPASS SHADERPASS_FORWARD_UNLIT
				#pragma multi_compile _ DEBUG_DISPLAY

				#if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
					#define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
					#define HAS_LIGHTLOOP
					#define SHADOW_OPTIMIZE_REGISTER_USAGE 1

					#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
				#endif

				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

				struct VertexInput
				{
					float3 positionOS : POSITION;
					float4 normalOS : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct VertexOutput
				{
					float4 positionCS : SV_Position;
					float3 positionRWS : TEXCOORD0;
					float4 ase_texcoord1 : TEXCOORD1;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				CBUFFER_START(UnityPerMaterial)
				float _Size;
				float4 _ColorInfos;
				float4 _Texture_ST;
				float4 _EmissionColor;
				float _RenderQueueType;
				float _AddPrecomputedVelocity;
				float _ShadowMatteFilter;
				float _StencilRef;
				float _StencilWriteMask;
				float _StencilRefDepth;
				float _StencilWriteMaskDepth;
				float _StencilRefMV;
				float _StencilWriteMaskMV;
				float _StencilRefDistortionVec;
				float _StencilWriteMaskDistortionVec;
				float _StencilWriteMaskGBuffer;
				float _StencilRefGBuffer;
				float _ZTestGBuffer;
				float _RequireSplitLighting;
				float _ReceivesSSR;
				float _SurfaceType;
				float _BlendMode;
				float _SrcBlend;
				float _DstBlend;
				float _AlphaSrcBlend;
				float _AlphaDstBlend;
				float _ZWrite;
				float _CullMode;
				float _TransparentSortPriority;
				float _CullModeForward;
				float _TransparentCullMode;
				float _ZTestDepthEqualForOpaque;
				float _ZTestTransparent;
				float _TransparentBackfaceEnable;
				float _AlphaCutoffEnable;
				float _AlphaCutoff;
				float _UseShadowThreshold;
				float _DoubleSidedEnable;
				float _DoubleSidedNormalMode;
				float4 _DoubleSidedConstants;
				CBUFFER_END
				sampler2D _Texture;

				struct SurfaceDescription
				{
					float3 Color;
					float3 Emission;
					float4 ShadowTint;
					float Alpha;
					float AlphaClipThreshold;
				};

				void BuildSurfaceData(FragInputs fragInputs, SurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData)
				{
					ZERO_INITIALIZE(SurfaceData, surfaceData);
					surfaceData.color = surfaceDescription.Color;
				}

				void GetSurfaceAndBuiltinData(SurfaceDescription surfaceDescription , FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
				{
					#if _ALPHATEST_ON
					DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
					#endif
					BuildSurfaceData(fragInputs, surfaceDescription, V, surfaceData);

					#if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
						HDShadowContext shadowContext = InitShadowContext();
						float shadow;
						float3 shadow3;
						posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
						float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
						uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
						ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
						shadow = dot(shadow3, float3(1.0f / 3.0f, 1.0f / 3.0f, 1.0f / 3.0f));

						float4 shadowColor = (1 - shadow) * surfaceDescription.ShadowTint.rgba;
						float  localAlpha = saturate(shadowColor.a + surfaceDescription.Alpha);

						// Keep the nested lerp
						// With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
						// And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
						#ifdef _SURFACE_TYPE_TRANSPARENT
							surfaceData.color = lerp(shadowColor.rgb * surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
						#else
							surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
						#endif
						localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;

						surfaceDescription.Alpha = localAlpha;
					#endif

					ZERO_INITIALIZE(BuiltinData, builtinData);
					builtinData.opacity = surfaceDescription.Alpha;
					builtinData.emissiveColor = surfaceDescription.Emission;
				}

				VertexOutput Vert(VertexInput inputMesh)
				{
					VertexOutput o;
					UNITY_SETUP_INSTANCE_ID(inputMesh);
					UNITY_TRANSFER_INSTANCE_ID(inputMesh, o);

					//Calculate new billboard vertex position and normal;
					float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
					float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
					float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
					float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
					inputMesh.normalOS.xyz = normalize(mul(float4(inputMesh.normalOS.xyz , 0), rotationCamMatrix)).xyz;
					inputMesh.positionOS.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
					inputMesh.positionOS.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
					inputMesh.positionOS.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
					inputMesh.positionOS = mul(inputMesh.positionOS, rotationCamMatrix);
					inputMesh.positionOS.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
					//Need to nullify rotation inserted by generated surface shader;
					inputMesh.positionOS = mul(GetWorldToObjectMatrix(), inputMesh.positionOS);
					o.ase_texcoord1.xy = inputMesh.ase_texcoord.xy;

					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord1.zw = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = inputMesh.positionOS.xyz;
					#else
					float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = (((inputMesh.positionOS + 0) * _Size) + float3(0,0.3,0));
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					inputMesh.positionOS.xyz = vertexValue;
					#else
					inputMesh.positionOS.xyz += vertexValue;
					#endif

					inputMesh.normalOS = inputMesh.normalOS;

					float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
					o.positionCS = TransformWorldToHClip(positionRWS);
					o.positionRWS = positionRWS;
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					return o;
				}

				float4 Frag(VertexOutput packedInput) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(packedInput);
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
					FragInputs input;
					ZERO_INITIALIZE(FragInputs, input);
					input.tangentToWorld = k_identity3x3;
					input.positionSS = packedInput.positionCS;
					input.positionRWS = packedInput.positionRWS;

					PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

					float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

					SurfaceData surfaceData;
					BuiltinData builtinData;
					SurfaceDescription surfaceDescription = (SurfaceDescription)0;
					float2 uv_Texture = packedInput.ase_texcoord1.xy * _Texture_ST.xy + _Texture_ST.zw;
					float4 tex2DNode3 = tex2D(_Texture, uv_Texture);
					float4 blendOpSrc7 = _ColorInfos;
					float4 blendOpDest7 = tex2DNode3;

					surfaceDescription.Color = (saturate(((blendOpDest7 > 0.5) ? (1.0 - 2.0 * (1.0 - blendOpDest7) * (1.0 - blendOpSrc7)) : (2.0 * blendOpDest7 * blendOpSrc7)))).rgb;
					surfaceDescription.Emission = 0;
					surfaceDescription.Alpha = tex2DNode3.a;
					surfaceDescription.AlphaClipThreshold = 0.5;
					float2 Distortion = float2 (0, 0);
					float DistortionBlur = 0;

					GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

					BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);

					float4 outColor = ApplyBlendMode(bsdfData.color + builtinData.emissiveColor * GetCurrentExposureMultiplier(), builtinData.opacity);
					outColor = EvaluateAtmosphericScattering(posInput, V, outColor);

					#ifdef DEBUG_DISPLAY
					int bufferSize = int(_DebugViewMaterialArray[0]);
					for (int index = 1; index <= bufferSize; index++)
					{
						int indexMaterialProperty = int(_DebugViewMaterialArray[index]);
						if (indexMaterialProperty != 0)
						{
							float3 result = float3(1.0, 0.0, 1.0);
							bool needLinearToSRGB = false;

							GetPropertiesDataDebug(indexMaterialProperty, result, needLinearToSRGB);
							GetVaryingsDataDebug(indexMaterialProperty, input, result, needLinearToSRGB);
							GetBuiltinDataDebug(indexMaterialProperty, builtinData, result, needLinearToSRGB);
							GetSurfaceDataDebug(indexMaterialProperty, surfaceData, result, needLinearToSRGB);
							GetBSDFDataDebug(indexMaterialProperty, bsdfData, result, needLinearToSRGB);

							if (!needLinearToSRGB)
								result = SRGBToLinear(max(0, result));

							outColor = float4(result, 1.0);
						}
					}
					#endif

					return outColor;
				}

				ENDHLSL
			}

			Pass
			{
				Name "ShadowCaster"
				Tags { "LightMode" = "ShadowCaster" }

				Cull[_CullMode]
				ZWrite On
				ZClip[_ZClip]
				ColorMask 0

				HLSLPROGRAM

				#pragma multi_compile_instancing
				#define _ENABLE_FOG_ON_TRANSPARENT 1
				#define HAVE_MESH_MODIFICATION 1
				#define ASE_SRP_VERSION 60900

				#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
				#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

				#pragma vertex Vert
				#pragma fragment Frag

				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

				#define SHADERPASS SHADERPASS_SHADOWS

				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"

				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

				struct VertexInput
				{
					float3 positionOS : POSITION;
					float3 normalOS : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct VertexOutput
				{
					float4 positionCS : SV_Position;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				CBUFFER_START(UnityPerMaterial)
				float _Size;
				float4 _ColorInfos;
				float4 _Texture_ST;
				float4 _EmissionColor;
				float _RenderQueueType;
				float _AddPrecomputedVelocity;
				float _ShadowMatteFilter;
				float _StencilRef;
				float _StencilWriteMask;
				float _StencilRefDepth;
				float _StencilWriteMaskDepth;
				float _StencilRefMV;
				float _StencilWriteMaskMV;
				float _StencilRefDistortionVec;
				float _StencilWriteMaskDistortionVec;
				float _StencilWriteMaskGBuffer;
				float _StencilRefGBuffer;
				float _ZTestGBuffer;
				float _RequireSplitLighting;
				float _ReceivesSSR;
				float _SurfaceType;
				float _BlendMode;
				float _SrcBlend;
				float _DstBlend;
				float _AlphaSrcBlend;
				float _AlphaDstBlend;
				float _ZWrite;
				float _CullMode;
				float _TransparentSortPriority;
				float _CullModeForward;
				float _TransparentCullMode;
				float _ZTestDepthEqualForOpaque;
				float _ZTestTransparent;
				float _TransparentBackfaceEnable;
				float _AlphaCutoffEnable;
				float _AlphaCutoff;
				float _UseShadowThreshold;
				float _DoubleSidedEnable;
				float _DoubleSidedNormalMode;
				float4 _DoubleSidedConstants;
				CBUFFER_END
				sampler2D _Texture;

				struct SurfaceDescription
				{
					float Alpha;
					float AlphaClipThreshold;
				};

				void BuildSurfaceData(FragInputs fragInputs, SurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData)
				{
					ZERO_INITIALIZE(SurfaceData, surfaceData);
				}

				void GetSurfaceAndBuiltinData(SurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
				{
					#if _ALPHATEST_ON
					DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
					#endif

					BuildSurfaceData(fragInputs, surfaceDescription, V, surfaceData);
					ZERO_INITIALIZE(BuiltinData, builtinData);
					builtinData.opacity = surfaceDescription.Alpha;
				}

				VertexOutput Vert(VertexInput inputMesh)
				{
					VertexOutput o;

					UNITY_SETUP_INSTANCE_ID(inputMesh);
					UNITY_TRANSFER_INSTANCE_ID(inputMesh, o);

					//Calculate new billboard vertex position and normal;
					float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
					float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
					float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
					float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
					inputMesh.normalOS = normalize(mul(float4(inputMesh.normalOS , 0), rotationCamMatrix)).xyz;
					inputMesh.positionOS.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
					inputMesh.positionOS.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
					inputMesh.positionOS.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
					inputMesh.positionOS = mul(inputMesh.positionOS, rotationCamMatrix);
					inputMesh.positionOS.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
					//Need to nullify rotation inserted by generated surface shader;
					inputMesh.positionOS = mul(GetWorldToObjectMatrix(), inputMesh.positionOS);
					o.ase_texcoord.xy = inputMesh.ase_texcoord.xy;

					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.zw = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = inputMesh.positionOS.xyz;
					#else
					float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = (((inputMesh.positionOS + 0) * _Size) + float3(0,0.3,0));
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					inputMesh.positionOS.xyz = vertexValue;
					#else
					inputMesh.positionOS.xyz += vertexValue;
					#endif

					inputMesh.normalOS = inputMesh.normalOS;

					float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
					o.positionCS = TransformWorldToHClip(positionRWS);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					return o;
				}

				void Frag(VertexOutput packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
						#ifdef WRITE_MSAA_DEPTH
						, out float1 depthColor : SV_Target1
						#endif
						#elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#else
						, out float4 outColor : SV_Target0
						#endif

						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif

						)
				{
					UNITY_SETUP_INSTANCE_ID(packedInput);
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
					FragInputs input;
					ZERO_INITIALIZE(FragInputs, input);
					input.tangentToWorld = k_identity3x3;
					input.positionSS = packedInput.positionCS;       // input.positionCS is SV_Position

					// input.positionSS is SV_Position
					PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

					float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0

					SurfaceData surfaceData;
					BuiltinData builtinData;
					SurfaceDescription surfaceDescription = (SurfaceDescription)0;
					float2 uv_Texture = packedInput.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
					float4 tex2DNode3 = tex2D(_Texture, uv_Texture);

					surfaceDescription.Alpha = tex2DNode3.a;
					surfaceDescription.AlphaClipThreshold = 0;

					GetSurfaceAndBuiltinData(surfaceDescription,input, V, posInput, surfaceData, builtinData);

					#ifdef _DEPTHOFFSET_ON
					outputDepth = posInput.deviceDepth;
					#endif

					#ifdef WRITE_NORMAL_BUFFER
					EncodeIntoNormalBuffer(ConvertSurfaceDataToNormalData(surfaceData), posInput.positionSS, outNormalBuffer);
					#ifdef WRITE_MSAA_DEPTH
					depthColor = packedInput.positionCS.z;
					#endif
					#elif defined(WRITE_MSAA_DEPTH)
					outNormalBuffer = float4(0.0, 0.0, 0.0, 1.0);
					depthColor = packedInput.vmesh.positionCS.z;
					#elif defined(SCENESELECTIONPASS)
					outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
					#else
					outColor = float4(0.0, 0.0, 0.0, 0.0);
					#endif
				}

				ENDHLSL
			}

			Pass
			{
				Name "META"
				Tags { "LightMode" = "Meta" }

				Cull Off

				HLSLPROGRAM

				#pragma multi_compile_instancing
				#define _ENABLE_FOG_ON_TRANSPARENT 1
				#define HAVE_MESH_MODIFICATION 1
				#define ASE_SRP_VERSION 60900

				#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
				#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

				#pragma vertex Vert
				#pragma fragment Frag

				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

				#define SHADERPASS SHADERPASS_LIGHT_TRANSPORT

				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"

				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

				struct VertexInput
				{
					float3 positionOS : POSITION;
					float3 normalOS : NORMAL;
					float4 uv1 : TEXCOORD1;
					float4 uv2 : TEXCOORD2;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct VertexOutput
				{
					float4 positionCS : SV_Position;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				CBUFFER_START(UnityPerMaterial)
				float _Size;
				float4 _ColorInfos;
				float4 _Texture_ST;
				float4 _EmissionColor;
				float _RenderQueueType;
				float _AddPrecomputedVelocity;
				float _ShadowMatteFilter;
				float _StencilRef;
				float _StencilWriteMask;
				float _StencilRefDepth;
				float _StencilWriteMaskDepth;
				float _StencilRefMV;
				float _StencilWriteMaskMV;
				float _StencilRefDistortionVec;
				float _StencilWriteMaskDistortionVec;
				float _StencilWriteMaskGBuffer;
				float _StencilRefGBuffer;
				float _ZTestGBuffer;
				float _RequireSplitLighting;
				float _ReceivesSSR;
				float _SurfaceType;
				float _BlendMode;
				float _SrcBlend;
				float _DstBlend;
				float _AlphaSrcBlend;
				float _AlphaDstBlend;
				float _ZWrite;
				float _CullMode;
				float _TransparentSortPriority;
				float _CullModeForward;
				float _TransparentCullMode;
				float _ZTestDepthEqualForOpaque;
				float _ZTestTransparent;
				float _TransparentBackfaceEnable;
				float _AlphaCutoffEnable;
				float _AlphaCutoff;
				float _UseShadowThreshold;
				float _DoubleSidedEnable;
				float _DoubleSidedNormalMode;
				float4 _DoubleSidedConstants;
				CBUFFER_END

				CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaVertexControl;
				bool4 unity_MetaFragmentControl;
				CBUFFER_END

				float unity_OneOverOutputBoost;
				float unity_MaxOutputValue;
				sampler2D _Texture;

				struct SurfaceDescription
				{
					float3 Color;
					float3 Emission;
					float Alpha;
					float AlphaClipThreshold;
				};

				void BuildSurfaceData(FragInputs fragInputs, SurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData)
				{
					ZERO_INITIALIZE(SurfaceData, surfaceData);
					surfaceData.color = surfaceDescription.Color;
				}

				void GetSurfaceAndBuiltinData(SurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
				{
					#if _ALPHATEST_ON
					DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
					#endif

					BuildSurfaceData(fragInputs, surfaceDescription, V, surfaceData);
					ZERO_INITIALIZE(BuiltinData, builtinData);
					builtinData.opacity = surfaceDescription.Alpha;
					builtinData.emissiveColor = surfaceDescription.Emission;
					builtinData.distortion = float2(0.0, 0.0);
					builtinData.distortionBlur = 0.0;
				}

				VertexOutput Vert(VertexInput inputMesh)
				{
					VertexOutput o;

					UNITY_SETUP_INSTANCE_ID(inputMesh);
					UNITY_TRANSFER_INSTANCE_ID(inputMesh, o);

					//Calculate new billboard vertex position and normal;
					float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
					float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
					float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
					float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
					inputMesh.normalOS = normalize(mul(float4(inputMesh.normalOS , 0), rotationCamMatrix)).xyz;
					inputMesh.positionOS.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
					inputMesh.positionOS.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
					inputMesh.positionOS.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
					inputMesh.positionOS = mul(inputMesh.positionOS, rotationCamMatrix);
					inputMesh.positionOS.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
					//Need to nullify rotation inserted by generated surface shader;
					inputMesh.positionOS = mul(GetWorldToObjectMatrix(), inputMesh.positionOS);
					o.ase_texcoord.xy = inputMesh.ase_texcoord.xy;

					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.zw = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = inputMesh.positionOS.xyz;
					#else
					float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = (((inputMesh.positionOS + 0) * _Size) + float3(0,0.3,0));
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					inputMesh.positionOS.xyz = vertexValue;
					#else
					inputMesh.positionOS.xyz += vertexValue;
					#endif

					inputMesh.normalOS = inputMesh.normalOS;

					float2 uv = float2(0.0, 0.0);
					if (unity_MetaVertexControl.x)
					{
						uv = inputMesh.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					}
					else if (unity_MetaVertexControl.y)
					{
						uv = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					}

					o.positionCS = float4(uv * 2.0 - 1.0, inputMesh.positionOS.z > 0 ? 1.0e-4 : 0.0, 1.0);
					return o;
				}

				float4 Frag(VertexOutput packedInput) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(packedInput);
					FragInputs input;
					ZERO_INITIALIZE(FragInputs, input);
					input.tangentToWorld = k_identity3x3;
					input.positionSS = packedInput.positionCS;

					PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

					float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0

					SurfaceData surfaceData;
					BuiltinData builtinData;
					SurfaceDescription surfaceDescription = (SurfaceDescription)0;
					float2 uv_Texture = packedInput.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
					float4 tex2DNode3 = tex2D(_Texture, uv_Texture);
					float4 blendOpSrc7 = _ColorInfos;
					float4 blendOpDest7 = tex2DNode3;

					surfaceDescription.Color = (saturate(((blendOpDest7 > 0.5) ? (1.0 - 2.0 * (1.0 - blendOpDest7) * (1.0 - blendOpSrc7)) : (2.0 * blendOpDest7 * blendOpSrc7)))).rgb;
					surfaceDescription.Emission = 0;
					surfaceDescription.Alpha = tex2DNode3.a;
					surfaceDescription.AlphaClipThreshold = 0;

					GetSurfaceAndBuiltinData(surfaceDescription,input, V, posInput, surfaceData, builtinData);
					BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);
					LightTransportData lightTransportData = GetLightTransportData(surfaceData, builtinData, bsdfData);

					float4 res = float4(0.0, 0.0, 0.0, 1.0);
					if (unity_MetaFragmentControl.x)
					{
						res.rgb = clamp(pow(abs(lightTransportData.diffuseColor), saturate(unity_OneOverOutputBoost)), 0, unity_MaxOutputValue);
					}

					if (unity_MetaFragmentControl.y)
					{
						res.rgb = lightTransportData.emissiveColor;
					}

					return res;
				}

				ENDHLSL
			}

			Pass
			{
				Name "SceneSelectionPass"
				Tags { "LightMode" = "SceneSelectionPass" }

				Cull[_CullMode]
				ZWrite On

				ColorMask 0

				HLSLPROGRAM

				#pragma multi_compile_instancing
				#define _ENABLE_FOG_ON_TRANSPARENT 1
				#define HAVE_MESH_MODIFICATION 1
				#define ASE_SRP_VERSION 60900

				#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
				#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

				#pragma vertex Vert
				#pragma fragment Frag

				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

				#define SHADERPASS SHADERPASS_DEPTH_ONLY
				#define SCENESELECTIONPASS
				#pragma editor_sync_compilation

				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

				struct VertexInput
				{
					float3 positionOS : POSITION;
					float4 normalOS : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct VertexOutput
				{
					float4 positionCS : SV_Position;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				int _ObjectId;
				int _PassValue;

				CBUFFER_START(UnityPerMaterial)
				float _Size;
				float4 _ColorInfos;
				float4 _Texture_ST;
				float4 _EmissionColor;
				float _RenderQueueType;
				float _AddPrecomputedVelocity;
				float _ShadowMatteFilter;
				float _StencilRef;
				float _StencilWriteMask;
				float _StencilRefDepth;
				float _StencilWriteMaskDepth;
				float _StencilRefMV;
				float _StencilWriteMaskMV;
				float _StencilRefDistortionVec;
				float _StencilWriteMaskDistortionVec;
				float _StencilWriteMaskGBuffer;
				float _StencilRefGBuffer;
				float _ZTestGBuffer;
				float _RequireSplitLighting;
				float _ReceivesSSR;
				float _SurfaceType;
				float _BlendMode;
				float _SrcBlend;
				float _DstBlend;
				float _AlphaSrcBlend;
				float _AlphaDstBlend;
				float _ZWrite;
				float _CullMode;
				float _TransparentSortPriority;
				float _CullModeForward;
				float _TransparentCullMode;
				float _ZTestDepthEqualForOpaque;
				float _ZTestTransparent;
				float _TransparentBackfaceEnable;
				float _AlphaCutoffEnable;
				float _AlphaCutoff;
				float _UseShadowThreshold;
				float _DoubleSidedEnable;
				float _DoubleSidedNormalMode;
				float4 _DoubleSidedConstants;
				CBUFFER_END
				sampler2D _Texture;

				struct SurfaceDescription
				{
					float Alpha;
					float AlphaClipThreshold;
				};

				void BuildSurfaceData(FragInputs fragInputs, SurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData)
				{
					ZERO_INITIALIZE(SurfaceData, surfaceData);
				}

				void GetSurfaceAndBuiltinData(SurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
				{
					#if _ALPHATEST_ON
					DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
					#endif

					BuildSurfaceData(fragInputs, surfaceDescription, V, surfaceData);
					ZERO_INITIALIZE(BuiltinData, builtinData);
					builtinData.opacity = surfaceDescription.Alpha;
				}

				VertexOutput Vert(VertexInput inputMesh)
				{
					VertexOutput o;

					UNITY_SETUP_INSTANCE_ID(inputMesh);
					UNITY_TRANSFER_INSTANCE_ID(inputMesh, o);

					//Calculate new billboard vertex position and normal;
					float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
					float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
					float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
					float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
					inputMesh.normalOS.xyz = normalize(mul(float4(inputMesh.normalOS.xyz , 0), rotationCamMatrix)).xyz;
					inputMesh.positionOS.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
					inputMesh.positionOS.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
					inputMesh.positionOS.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
					inputMesh.positionOS = mul(inputMesh.positionOS, rotationCamMatrix);
					inputMesh.positionOS.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
					//Need to nullify rotation inserted by generated surface shader;
					inputMesh.positionOS = mul(GetWorldToObjectMatrix(), inputMesh.positionOS);
					o.ase_texcoord.xy = inputMesh.ase_texcoord.xy;

					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.zw = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = inputMesh.positionOS.xyz;
					#else
					float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = (((inputMesh.positionOS + 0) * _Size) + float3(0,0.3,0));
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					inputMesh.positionOS.xyz = vertexValue;
					#else
					inputMesh.positionOS.xyz += vertexValue;
					#endif

					inputMesh.normalOS = inputMesh.normalOS;

					float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
					o.positionCS = TransformWorldToHClip(positionRWS);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					return o;
				}

				void Frag(VertexOutput packedInput
						, out float4 outColor : SV_Target0
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif

						)
				{
					UNITY_SETUP_INSTANCE_ID(packedInput);
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
					FragInputs input;
					ZERO_INITIALIZE(FragInputs, input);
					input.tangentToWorld = k_identity3x3;
					input.positionSS = packedInput.positionCS;

					PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

					float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0

					SurfaceData surfaceData;
					BuiltinData builtinData;
					SurfaceDescription surfaceDescription = (SurfaceDescription)0;
					float2 uv_Texture = packedInput.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
					float4 tex2DNode3 = tex2D(_Texture, uv_Texture);

					surfaceDescription.Alpha = tex2DNode3.a;
					surfaceDescription.AlphaClipThreshold = 0;

					GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

					#ifdef _DEPTHOFFSET_ON
					outputDepth = posInput.deviceDepth;
					#endif

					outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
				}

				ENDHLSL
			}

			Pass
			{
				Name "DepthForwardOnly"
				Tags { "LightMode" = "DepthForwardOnly" }

				Cull[_CullMode]
				ZWrite On
				Stencil
				{
					Ref[_StencilRefDepth]
					WriteMask[_StencilWriteMaskDepth]
					Comp Always
					Pass Replace
					Fail Keep
					ZFail Keep
				}

				ColorMask 0 0

				HLSLPROGRAM

				#pragma multi_compile_instancing
				#define _ENABLE_FOG_ON_TRANSPARENT 1
				#define HAVE_MESH_MODIFICATION 1
				#define ASE_SRP_VERSION 60900

				#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
				#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

				#pragma vertex Vert
				#pragma fragment Frag

				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

				#define SHADERPASS SHADERPASS_DEPTH_ONLY
				#pragma multi_compile _ WRITE_MSAA_DEPTH

				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

				struct VertexInput
				{
					float3 positionOS : POSITION;
					float4 normalOS : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct VertexOutput
				{
					float4 positionCS : SV_Position;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				CBUFFER_START(UnityPerMaterial)
				float _Size;
				float4 _ColorInfos;
				float4 _Texture_ST;
				float4 _EmissionColor;
				float _RenderQueueType;
				float _AddPrecomputedVelocity;
				float _ShadowMatteFilter;
				float _StencilRef;
				float _StencilWriteMask;
				float _StencilRefDepth;
				float _StencilWriteMaskDepth;
				float _StencilRefMV;
				float _StencilWriteMaskMV;
				float _StencilRefDistortionVec;
				float _StencilWriteMaskDistortionVec;
				float _StencilWriteMaskGBuffer;
				float _StencilRefGBuffer;
				float _ZTestGBuffer;
				float _RequireSplitLighting;
				float _ReceivesSSR;
				float _SurfaceType;
				float _BlendMode;
				float _SrcBlend;
				float _DstBlend;
				float _AlphaSrcBlend;
				float _AlphaDstBlend;
				float _ZWrite;
				float _CullMode;
				float _TransparentSortPriority;
				float _CullModeForward;
				float _TransparentCullMode;
				float _ZTestDepthEqualForOpaque;
				float _ZTestTransparent;
				float _TransparentBackfaceEnable;
				float _AlphaCutoffEnable;
				float _AlphaCutoff;
				float _UseShadowThreshold;
				float _DoubleSidedEnable;
				float _DoubleSidedNormalMode;
				float4 _DoubleSidedConstants;
				CBUFFER_END
				sampler2D _Texture;

				struct SurfaceDescription
				{
					float Alpha;
					float AlphaClipThreshold;
				};

				void BuildSurfaceData(FragInputs fragInputs, SurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData)
				{
					ZERO_INITIALIZE(SurfaceData, surfaceData);
				}

				void GetSurfaceAndBuiltinData(SurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
				{
					#if _ALPHATEST_ON
					DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
					#endif

					BuildSurfaceData(fragInputs, surfaceDescription, V, surfaceData);
					ZERO_INITIALIZE(BuiltinData, builtinData);
					builtinData.opacity = surfaceDescription.Alpha;
				}

				VertexOutput Vert(VertexInput inputMesh)
				{
					VertexOutput o;

					UNITY_SETUP_INSTANCE_ID(inputMesh);
					UNITY_TRANSFER_INSTANCE_ID(inputMesh, o);

					//Calculate new billboard vertex position and normal;
					float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
					float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
					float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
					float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
					inputMesh.normalOS.xyz = normalize(mul(float4(inputMesh.normalOS.xyz , 0), rotationCamMatrix)).xyz;
					inputMesh.positionOS.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
					inputMesh.positionOS.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
					inputMesh.positionOS.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
					inputMesh.positionOS = mul(inputMesh.positionOS, rotationCamMatrix);
					inputMesh.positionOS.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
					//Need to nullify rotation inserted by generated surface shader;
					inputMesh.positionOS = mul(GetWorldToObjectMatrix(), inputMesh.positionOS);
					o.ase_texcoord.xy = inputMesh.ase_texcoord.xy;

					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.zw = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = inputMesh.positionOS.xyz;
					#else
					float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = (((inputMesh.positionOS + 0) * _Size) + float3(0,0.3,0));
					#ifdef ASE_ABSOLUTE_VERTEX_POS
					inputMesh.positionOS.xyz = vertexValue;
					#else
					inputMesh.positionOS.xyz += vertexValue;
					#endif

					inputMesh.normalOS = inputMesh.normalOS;

					float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
					o.positionCS = TransformWorldToHClip(positionRWS);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					return o;
				}

				void Frag(VertexOutput packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
						#ifdef WRITE_MSAA_DEPTH
						, out float1 depthColor : SV_Target1
						#endif
						#elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#else
						, out float4 outColor : SV_Target0
						#endif

						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif

						)
				{
					UNITY_SETUP_INSTANCE_ID(packedInput);
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
					FragInputs input;
					ZERO_INITIALIZE(FragInputs, input);
					input.tangentToWorld = k_identity3x3;
					input.positionSS = packedInput.positionCS;

					PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

					float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0

					SurfaceData surfaceData;
					BuiltinData builtinData;
					SurfaceDescription surfaceDescription = (SurfaceDescription)0;
					float2 uv_Texture = packedInput.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
					float4 tex2DNode3 = tex2D(_Texture, uv_Texture);

					surfaceDescription.Alpha = tex2DNode3.a;
					surfaceDescription.AlphaClipThreshold = 0;

					GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

					#ifdef _DEPTHOFFSET_ON
					outputDepth = posInput.deviceDepth;
					#endif

					#ifdef WRITE_NORMAL_BUFFER
					EncodeIntoNormalBuffer(ConvertSurfaceDataToNormalData(surfaceData), posInput.positionSS, outNormalBuffer);
					#ifdef WRITE_MSAA_DEPTH
					depthColor = packedInput.positionCS.z;
					#endif
					#elif defined(WRITE_MSAA_DEPTH)
					outNormalBuffer = float4(0.0, 0.0, 0.0, 1.0);
					depthColor = packedInput.positionCS.z;
					#elif defined(SCENESELECTIONPASS)
					outColor = float4(_ObjectId, _PassValue, 1.0, 1.0);
					#else
					outColor = float4(0.0, 0.0, 0.0, 0.0);
					#endif
				}

				ENDHLSL
			}

			Pass
			{
				Name "DistortionVectors"
				Tags { "LightMode" = "DistortionVectors" }

				Blend One One , One One
				BlendOp Add , Add

				Cull[_CullMode]
				ZTest LEqual
				ZWrite Off

				Stencil
				{
					Ref[_StencilRefDistortionVec]
					WriteMask[_StencilRefDistortionVec]
					Comp Always
					Pass Replace
					Fail Keep
					ZFail Keep
				}

				HLSLPROGRAM

				#pragma multi_compile_instancing
				#define _ENABLE_FOG_ON_TRANSPARENT 1
				#define HAVE_MESH_MODIFICATION 1
				#define ASE_SRP_VERSION 60900

				#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
				#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

				#pragma vertex Vert
				#pragma fragment Frag

					//#define UNITY_MATERIAL_LIT

					#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
					#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

					#define SHADERPASS SHADERPASS_DISTORTION

					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"

					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
					#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

					struct VertexInput
					{
						float3 positionOS : POSITION;
						float3 normalOS : NORMAL;
						float4 ase_texcoord : TEXCOORD0;
						UNITY_VERTEX_INPUT_INSTANCE_ID
					};

					struct VertexOutput
					{
						float4 positionCS : SV_Position;
						float4 ase_texcoord : TEXCOORD0;
						UNITY_VERTEX_INPUT_INSTANCE_ID
						UNITY_VERTEX_OUTPUT_STEREO
					};

					CBUFFER_START(UnityPerMaterial)
					float _Size;
					float4 _ColorInfos;
					float4 _Texture_ST;
					float4 _EmissionColor;
					float _RenderQueueType;
					float _AddPrecomputedVelocity;
					float _ShadowMatteFilter;
					float _StencilRef;
					float _StencilWriteMask;
					float _StencilRefDepth;
					float _StencilWriteMaskDepth;
					float _StencilRefMV;
					float _StencilWriteMaskMV;
					float _StencilRefDistortionVec;
					float _StencilWriteMaskDistortionVec;
					float _StencilWriteMaskGBuffer;
					float _StencilRefGBuffer;
					float _ZTestGBuffer;
					float _RequireSplitLighting;
					float _ReceivesSSR;
					float _SurfaceType;
					float _BlendMode;
					float _SrcBlend;
					float _DstBlend;
					float _AlphaSrcBlend;
					float _AlphaDstBlend;
					float _ZWrite;
					float _CullMode;
					float _TransparentSortPriority;
					float _CullModeForward;
					float _TransparentCullMode;
					float _ZTestDepthEqualForOpaque;
					float _ZTestTransparent;
					float _TransparentBackfaceEnable;
					float _AlphaCutoffEnable;
					float _AlphaCutoff;
					float _UseShadowThreshold;
					float _DoubleSidedEnable;
					float _DoubleSidedNormalMode;
					float4 _DoubleSidedConstants;
					CBUFFER_END
					sampler2D _Texture;

					struct DistortionSurfaceDescription
					{
						float Alpha;
						float AlphaClipThreshold;
						float2 Distortion;
						float DistortionBlur;
					};

					void BuildSurfaceData(FragInputs fragInputs, inout DistortionSurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData)
					{
						ZERO_INITIALIZE(SurfaceData, surfaceData);
					}

					void GetSurfaceAndBuiltinData(DistortionSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
					{
						#ifdef _ALPHATEST_ON
						DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
						#endif

						BuildSurfaceData(fragInputs, surfaceDescription, V, surfaceData);

						ZERO_INITIALIZE(BuiltinData, builtinData);
						builtinData.opacity = surfaceDescription.Alpha;
						builtinData.distortion = surfaceDescription.Distortion;
						builtinData.distortionBlur = surfaceDescription.DistortionBlur;
					}

					VertexOutput Vert(VertexInput inputMesh)
					{
						VertexOutput o;

						UNITY_SETUP_INSTANCE_ID(inputMesh);
						UNITY_TRANSFER_INSTANCE_ID(inputMesh, o);

						//Calculate new billboard vertex position and normal;
						float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
						float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
						float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
						float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
						inputMesh.normalOS = normalize(mul(float4(inputMesh.normalOS , 0), rotationCamMatrix)).xyz;
						inputMesh.positionOS.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
						inputMesh.positionOS.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
						inputMesh.positionOS.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
						inputMesh.positionOS = mul(inputMesh.positionOS, rotationCamMatrix);
						inputMesh.positionOS.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
						//Need to nullify rotation inserted by generated surface shader;
						inputMesh.positionOS = mul(GetWorldToObjectMatrix(), inputMesh.positionOS);
						o.ase_texcoord.xy = inputMesh.ase_texcoord.xy;

						//setting value to unused interpolator channels and avoid initialization warnings
						o.ase_texcoord.zw = 0;

						#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = inputMesh.positionOS.xyz;
						#else
						float3 defaultVertexValue = float3(0, 0, 0);
						#endif
						float3 vertexValue = (((inputMesh.positionOS + 0) * _Size) + float3(0,0.3,0));

						#ifdef ASE_ABSOLUTE_VERTEX_POS
						inputMesh.positionOS.xyz = vertexValue;
						#else
						inputMesh.positionOS.xyz += vertexValue;
						#endif

						inputMesh.normalOS = inputMesh.normalOS;
						float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);

						o.positionCS = TransformWorldToHClip(positionRWS);
						UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
						return o;
					}

					float4 Frag(VertexOutput packedInput) : SV_Target
					{
						UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
						UNITY_SETUP_INSTANCE_ID(packedInput);
						FragInputs input;
						ZERO_INITIALIZE(FragInputs, input);
						input.tangentToWorld = k_identity3x3;
						input.positionSS = packedInput.positionCS;

						PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
						float3 V = float3(1.0, 1.0, 1.0);
						SurfaceData surfaceData;
						BuiltinData builtinData;

						DistortionSurfaceDescription surfaceDescription = (DistortionSurfaceDescription)0;
						float2 uv_Texture = packedInput.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
						float4 tex2DNode3 = tex2D(_Texture, uv_Texture);

						surfaceDescription.Alpha = tex2DNode3.a;
						surfaceDescription.AlphaClipThreshold = 0.5;

						surfaceDescription.Distortion = float2 (0,0);
						surfaceDescription.DistortionBlur = 0;

						GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

						float4 outBuffer;
						EncodeDistortion(builtinData.distortion, builtinData.distortionBlur, true, outBuffer);
						return outBuffer;
					}
					ENDHLSL
				}
		}
			CustomEditor "UnityEditor.Experimental.Rendering.HDPipeline.HDLitGUI"
						Fallback "Hidden/InternalErrorShader"
}
/*ASEBEGIN
Version=17700
-1673;204;1666;981;983.97;376.1288;1.133736;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;5;-748,212.5;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BillboardNode;4;-724,402.5;Inherit;False;Spherical;True;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-394,224.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-403,396.5;Inherit;False;Property;_Size;Size;2;0;Create;True;0;0;False;0;0;-0.736;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-207,224.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;15;-152,450.5;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0,0.3,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;8;-360,-240.5;Inherit;False;Property;_ColorInfos;Color ;1;0;Create;False;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;7;-40,-124.5;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-432,-10.5;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;-1;None;e60eeaadcd8aa26428d8871e84202da7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;190,220.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;23;332,56;Float;False;False;-1;2;UnityEditor.Experimental.Rendering.HDPipeline.HDLitGUI;0;1;New Amplify Shader;7f5cb9c3ea6481f469fdd856555439ef;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-26;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;24;332,56;Float;False;False;-1;2;UnityEditor.Experimental.Rendering.HDPipeline.HDLitGUI;0;1;New Amplify Shader;7f5cb9c3ea6481f469fdd856555439ef;True;META;0;2;META;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;25;332,56;Float;False;False;-1;2;UnityEditor.Experimental.Rendering.HDPipeline.HDLitGUI;0;1;New Amplify Shader;7f5cb9c3ea6481f469fdd856555439ef;True;SceneSelectionPass;0;3;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-26;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=SceneSelectionPass;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;26;332,56;Float;False;False;-1;2;UnityEditor.Experimental.Rendering.HDPipeline.HDLitGUI;0;1;New Amplify Shader;7f5cb9c3ea6481f469fdd856555439ef;True;DepthForwardOnly;0;4;DepthForwardOnly;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-26;False;True;True;0;True;-8;255;False;-1;255;True;-9;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;False;False;True;1;LightMode=DepthForwardOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;27;332,56;Float;False;False;-1;2;UnityEditor.Experimental.Rendering.HDPipeline.HDLitGUI;0;1;New Amplify Shader;7f5cb9c3ea6481f469fdd856555439ef;True;DistortionVectors;0;5;DistortionVectors;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;True;1;False;-1;1;False;-1;False;True;0;True;-26;False;True;True;0;True;-12;255;False;-1;255;True;-12;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;False;True;1;LightMode=DistortionVectors;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;22;403.6868,202.2411;Float;False;True;-1;2;UnityEditor.Experimental.Rendering.HDPipeline.HDLitGUI;0;13;Billboard HDRP;7f5cb9c3ea6481f469fdd856555439ef;True;Forward Unlit;0;0;Forward Unlit;8;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;5;0;True;1;0;True;-21;0;True;-22;1;0;True;-23;0;True;-24;False;False;True;0;True;-26;False;True;True;0;True;-6;255;False;-1;255;True;-7;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;0;True;-25;True;0;True;-31;False;True;1;LightMode=ForwardOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;18;Surface Type;1;  Rendering Pass ;0;  Rendering Pass;1;  Blending Mode;0;  Receive Fog;1;  Distortion;0;    Distortion Mode;0;    Distortion Depth Test;1;  ZWrite;1;  Cull Mode;0;  Z Test;4;Double-Sided;0;Alpha Clipping;0;Add Precomputed Velocity;0;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;Vertex Position,InvertActionOnDeselection;1;0;6;True;True;True;True;True;True;False;;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;12;0;6;0
WireConnection;12;1;13;0
WireConnection;7;0;8;0
WireConnection;7;1;3;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;22;0;7;0
WireConnection;22;2;3;4
WireConnection;22;6;14;0
ASEEND*/
//CHKSM=7E045DBDE352B710349E687230A10A1249EE9549