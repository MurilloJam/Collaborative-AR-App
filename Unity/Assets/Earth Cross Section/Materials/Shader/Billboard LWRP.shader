// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X
Shader "Billboard"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_ColorInfos("Color ", Color) = (1,1,1,0)
		_Size("Size", Range(-1 , 1)) = 0
		[HideInInspector] _texcoord("", 2D) = "white" {}
	}

		SubShader
	{
		LOD 0

		Tags { "RenderPipeline" = "LightweightPipeline" "RenderType" = "Transparent" "Queue" = "Transparent" }
		Cull Off
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL

		Pass
		{
			Tags { "LightMode" = "LightweightForward" }
			Name "Base"

			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_SRP_VERSION 40100

		// Required to compile gles 2.0 with standard srp library
		#pragma prefer_hlslcc gles
		#pragma exclude_renderers d3d11_9x

		// -------------------------------------
		// Lightweight Pipeline keywords
		#pragma shader_feature _SAMPLE_GI

		// -------------------------------------
		// Unity defined keywords
		#pragma multi_compile_fog

		//--------------------------------------
		// GPU Instancing
		#pragma multi_compile_instancing

		#pragma vertex vert
		#pragma fragment frag

		// Lighting include is needed because of GI
		#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
		#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
		#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
		#include "Packages/com.unity.render-pipelines.lightweight/Shaders/UnlitInput.hlsl"

		sampler2D _Texture;
		CBUFFER_START(UnityPerMaterial)
		float _Size;
		float4 _ColorInfos;
		float4 _Texture_ST;
		CBUFFER_END

		struct GraphVertexInput
		{
			float4 vertex : POSITION;
			float4 ase_normal : NORMAL;
			float4 ase_texcoord : TEXCOORD0;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct GraphVertexOutput
		{
			float4 position : POSITION;
			float4 ase_texcoord : TEXCOORD0;
			UNITY_VERTEX_INPUT_INSTANCE_ID
			UNITY_VERTEX_OUTPUT_STEREO
		};

		GraphVertexOutput vert(GraphVertexInput v)
		{
			GraphVertexOutput o = (GraphVertexOutput)0;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_TRANSFER_INSTANCE_ID(v, o);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
			float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
			float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
			float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
			v.ase_normal.xyz = normalize(mul(float4(v.ase_normal.xyz , 0), rotationCamMatrix)).xyz;
			v.vertex.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
			v.vertex.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
			v.vertex.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
			v.vertex = mul(v.vertex, rotationCamMatrix);
			v.vertex.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
			//Need to nullify rotation inserted by generated surface shader;
			v.vertex = mul(GetWorldToObjectMatrix(), v.vertex);
			o.ase_texcoord.xy = v.ase_texcoord.xy;

			//setting value to unused interpolator channels and avoid initialization warnings
			o.ase_texcoord.zw = 0;
			float3 vertexValue = (((v.vertex.xyz + 0) * _Size) + float3(0,0.3,0));
			#ifdef ASE_ABSOLUTE_VERTEX_POS
			v.vertex.xyz = vertexValue;
			#else
			v.vertex.xyz += vertexValue;
			#endif

			v.ase_normal = v.ase_normal;
			o.position = TransformObjectToHClip(v.vertex.xyz);
			return o;
		}

		half4 frag(GraphVertexOutput IN) : SV_Target
		{
			UNITY_SETUP_INSTANCE_ID(IN);
			float2 uv_Texture = IN.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
			float4 tex2DNode3 = tex2D(_Texture, uv_Texture);
			float4 blendOpSrc7 = _ColorInfos;
			float4 blendOpDest7 = tex2DNode3;

			float3 Color = (saturate(((blendOpDest7 > 0.5) ? (1.0 - 2.0 * (1.0 - blendOpDest7) * (1.0 - blendOpSrc7)) : (2.0 * blendOpDest7 * blendOpSrc7)))).rgb;
			float Alpha = tex2DNode3.a;
			float AlphaClipThreshold = 0;
	 #if _ALPHATEST_ON
			clip(Alpha - AlphaClipThreshold);
	#endif
			return half4(Color, Alpha);
		}
		ENDHLSL
	}

	Pass
	{
		Name "ShadowCaster"
		Tags { "LightMode" = "ShadowCaster" }
		ZWrite On
		ColorMask 0

		HLSLPROGRAM
		#define _RECEIVE_SHADOWS_OFF 1
		#define ASE_SRP_VERSION 40100

			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			//--------------------------------------
			// GPU Instancing
			#pragma multi_compile_instancing

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment

			#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			sampler2D _Texture;
			CBUFFER_START(UnityPerMaterial)
			float _Size;
			float4 _ColorInfos;
			float4 _Texture_ST;
			CBUFFER_END

			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float4 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			// x: global clip space bias, y: normal world space bias
			float4 _ShadowBias;
			float3 _LightDirection;

			VertexOutput ShadowPassVertex(GraphVertexInput v)
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				//Calculate new billboard vertex position and normal;
				float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
				float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
				float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
				float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
				v.ase_normal.xyz = normalize(mul(float4(v.ase_normal.xyz , 0), rotationCamMatrix)).xyz;
				v.vertex.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
				v.vertex.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
				v.vertex.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
				v.vertex = mul(v.vertex, rotationCamMatrix);
				v.vertex.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
				//Need to nullify rotation inserted by generated surface shader;
				v.vertex = mul(GetWorldToObjectMatrix(), v.vertex);
				o.ase_texcoord.xy = v.ase_texcoord.xy;

				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue = (((v.vertex.xyz + 0) * _Size) + float3(0,0.3,0));
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal.xyz);

				float invNdotL = 1.0 - saturate(dot(_LightDirection, normalWS));
				float scale = invNdotL * _ShadowBias.y;

				// normal bias is negative since we want to apply an inset normal offset
				positionWS = _LightDirection * _ShadowBias.xxx + positionWS;
				positionWS = normalWS * scale.xxx + positionWS;
				float4 clipPos = TransformWorldToHClip(positionWS);

				// _ShadowBias.x sign depens on if platform has reversed z buffer
				//clipPos.z += _ShadowBias.x;

			#if UNITY_REVERSED_Z
				clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
			#else
				clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
			#endif
				o.clipPos = clipPos;

				return o;
			}

			half4 ShadowPassFragment(VertexOutput IN) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				float2 uv_Texture = IN.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
				float4 tex2DNode3 = tex2D(_Texture, uv_Texture);

				float Alpha = tex2DNode3.a;
				float AlphaClipThreshold = AlphaClipThreshold;
		 #if _ALPHATEST_ON
				clip(Alpha - AlphaClipThreshold);
		#endif
				return 0;
			}

			ENDHLSL
		}

		Pass
		{
			Name "DepthOnly"
			Tags { "LightMode" = "DepthOnly" }

			ZWrite On
			ZTest LEqual
			ColorMask 0

			HLSLPROGRAM
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_SRP_VERSION 40100

				// Required to compile gles 2.0 with standard srp library
				#pragma prefer_hlslcc gles
				#pragma exclude_renderers d3d11_9x
				#pragma target 2.0

				//--------------------------------------
				// GPU Instancing
				#pragma multi_compile_instancing

				#pragma vertex vert
				#pragma fragment frag

				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
				#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

				sampler2D _Texture;
				CBUFFER_START(UnityPerMaterial)
				float _Size;
				float4 _ColorInfos;
				float4 _Texture_ST;
				CBUFFER_END

				struct GraphVertexInput
				{
					float4 vertex : POSITION;
					float4 ase_normal : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct VertexOutput
				{
					float4 clipPos : SV_POSITION;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				VertexOutput vert(GraphVertexInput v)
				{
						VertexOutput o = (VertexOutput)0;
						UNITY_SETUP_INSTANCE_ID(v);
						UNITY_TRANSFER_INSTANCE_ID(v, o);
						UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
						//Calculate new billboard vertex position and normal;
						float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
						float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
						float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
						float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
						v.ase_normal.xyz = normalize(mul(float4(v.ase_normal.xyz , 0), rotationCamMatrix)).xyz;
						v.vertex.x *= length(GetObjectToWorldMatrix()._m00_m10_m20);
						v.vertex.y *= length(GetObjectToWorldMatrix()._m01_m11_m21);
						v.vertex.z *= length(GetObjectToWorldMatrix()._m02_m12_m22);
						v.vertex = mul(v.vertex, rotationCamMatrix);
						v.vertex.xyz += GetObjectToWorldMatrix()._m03_m13_m23;
						//Need to nullify rotation inserted by generated surface shader;
						v.vertex = mul(GetWorldToObjectMatrix(), v.vertex);
						o.ase_texcoord.xy = v.ase_texcoord.xy;

						//setting value to unused interpolator channels and avoid initialization warnings
						o.ase_texcoord.zw = 0;
						float3 vertexValue = (((v.vertex.xyz + 0) * _Size) + float3(0,0.3,0));
						#ifdef ASE_ABSOLUTE_VERTEX_POS
						v.vertex.xyz = vertexValue;
						#else
						v.vertex.xyz += vertexValue;
						#endif
						v.ase_normal = v.ase_normal;
						o.clipPos = TransformObjectToHClip(v.vertex.xyz);
						return o;
				}

				half4 frag(VertexOutput IN) : SV_TARGET
				{
					UNITY_SETUP_INSTANCE_ID(IN);
					float2 uv_Texture = IN.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
					float4 tex2DNode3 = tex2D(_Texture, uv_Texture);

					float Alpha = tex2DNode3.a;
					float AlphaClipThreshold = AlphaClipThreshold;

			 #if _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
			#endif
					return 0;
				}
				ENDHLSL
			}
	}
		Fallback "Hidden/InternalErrorShader"
					CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
-1673;210;1666;974;1178;370.5;1;True;False
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
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;2;ASEMaterialInspector;0;1;New Amplify Shader;e2514bdcf5e5399499a9eb24d175b9db;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;ASEMaterialInspector;0;1;New Amplify Shader;e2514bdcf5e5399499a9eb24d175b9db;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=DepthOnly;True;0;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;332,56;Float;False;True;-1;2;ASEMaterialInspector;0;3;Billboard;e2514bdcf5e5399499a9eb24d175b9db;True;Base;0;0;Base;5;False;False;False;True;2;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;Hidden/InternalErrorShader;0;0;Standard;2;Vertex Position,InvertActionOnDeselection;1;Receive Shadows;0;0;3;True;True;True;False;;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;12;0;6;0
WireConnection;12;1;13;0
WireConnection;7;0;8;0
WireConnection;7;1;3;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;0;0;7;0
WireConnection;0;1;3;4
WireConnection;0;3;14;0
ASEEND*/
//CHKSM=111DF460E95A61D49D91FC7FE445B73897BE56D3