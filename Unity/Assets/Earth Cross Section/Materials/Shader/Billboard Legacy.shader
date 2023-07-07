// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X
Shader "Billboard Legacy"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_ColorInfos("Color ", Color) = (1,1,1,0)
		_Size("Size", Range(-1 , 1)) = 0
		[HideInInspector] _texcoord("", 2D) = "white" {}
		[HideInInspector] __dirty("", Int) = 1
	}

		SubShader
		{
			Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
			Cull Off
			CGINCLUDE
			#include "UnityPBSLighting.cginc"
			#include "Lighting.cginc"
			#pragma target 3.0
			struct Input
			{
				float2 uv_texcoord;
			};

			uniform float _Size;
			uniform float4 _ColorInfos;
			uniform sampler2D _Texture;
			uniform float4 _Texture_ST;

			void vertexDataFunc(inout appdata_full v, out Input o)
			{
				UNITY_INITIALIZE_OUTPUT(Input, o);
				//Calculate new billboard vertex position and normal;
				float3 upCamVec = normalize(UNITY_MATRIX_V._m10_m11_m12);
				float3 forwardCamVec = -normalize(UNITY_MATRIX_V._m20_m21_m22);
				float3 rightCamVec = normalize(UNITY_MATRIX_V._m00_m01_m02);
				float4x4 rotationCamMatrix = float4x4(rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1);
				v.normal = normalize(mul(float4(v.normal , 0), rotationCamMatrix)).xyz;
				v.vertex.x *= length(unity_ObjectToWorld._m00_m10_m20);
				v.vertex.y *= length(unity_ObjectToWorld._m01_m11_m21);
				v.vertex.z *= length(unity_ObjectToWorld._m02_m12_m22);
				v.vertex = mul(v.vertex, rotationCamMatrix);
				v.vertex.xyz += unity_ObjectToWorld._m03_m13_m23;
				//Need to nullify rotation inserted by generated surface shader;
				v.vertex = mul(unity_WorldToObject, v.vertex);
				float3 ase_vertex3Pos = v.vertex.xyz;
				v.vertex.xyz += (((ase_vertex3Pos + 0) * _Size) + float3(0,0.3,0));
			}

			void surf(Input i , inout SurfaceOutputStandard o)
			{
				float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
				float4 tex2DNode3 = tex2D(_Texture, uv_Texture);
				float4 blendOpSrc7 = _ColorInfos;
				float4 blendOpDest7 = tex2DNode3;
				o.Emission = (saturate(((blendOpDest7 > 0.5) ? (1.0 - 2.0 * (1.0 - blendOpDest7) * (1.0 - blendOpSrc7)) : (2.0 * blendOpDest7 * blendOpSrc7)))).rgb;
				o.Alpha = tex2DNode3.a;
			}

			ENDCG
			CGPROGRAM
			#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc

			ENDCG
			Pass
			{
				Name "ShadowCaster"
				Tags{ "LightMode" = "ShadowCaster" }
				ZWrite On
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 3.0
				#pragma multi_compile_shadowcaster
				#pragma multi_compile UNITY_PASS_SHADOWCASTER
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#include "HLSLSupport.cginc"
				#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
					#define CAN_SKIP_VPOS
				#endif
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				sampler3D _DitherMaskLOD;
				struct v2f
				{
					V2F_SHADOW_CASTER;
					float2 customPack1 : TEXCOORD1;
					float3 worldPos : TEXCOORD2;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};
				v2f vert(appdata_full v)
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_OUTPUT(v2f, o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					Input customInputData;
					vertexDataFunc(v, customInputData);
					float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					half3 worldNormal = UnityObjectToWorldNormal(v.normal);
					o.customPack1.xy = customInputData.uv_texcoord;
					o.customPack1.xy = v.texcoord;
					o.worldPos = worldPos;
					TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
					return o;
				}
				half4 frag(v2f IN
				#if !defined( CAN_SKIP_VPOS )
				, UNITY_VPOS_TYPE vpos : VPOS
				#endif
				) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);
					Input surfIN;
					UNITY_INITIALIZE_OUTPUT(Input, surfIN);
					surfIN.uv_texcoord = IN.customPack1.xy;
					float3 worldPos = IN.worldPos;
					half3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
					SurfaceOutputStandard o;
					UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandard, o)
					surf(surfIN, o);
					#if defined( CAN_SKIP_VPOS )
					float2 vpos = IN.pos;
					#endif
					half alphaRef = tex3D(_DitherMaskLOD, float3(vpos.xy * 0.25, o.Alpha * 0.9375)).a;
					clip(alphaRef - 0.01);
					SHADOW_CASTER_FRAGMENT(IN)
				}
				ENDCG
			}
		}
			Fallback "Diffuse"
						CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
-1673;210;1666;974;975.5905;263.9024;1.013195;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;5;-748,212.5;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BillboardNode;4;-724,402.5;Inherit;False;Spherical;True;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-394,224.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-403,396.5;Inherit;False;Property;_Size;Size;2;0;Create;True;0;0;False;0;0;-0.736;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-207,224.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;15;-152,450.5;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0,0.3,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;8;-360,-240.5;Inherit;False;Property;_ColorInfos;Color ;1;0;Create;False;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-432,-10.5;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;-1;None;8a4fcc960cc8d60499f45a8ea8e3b7a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;7;-40,-124.5;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;190,220.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;18;458,24;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Billboard Legacy;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;12;0;6;0
WireConnection;12;1;13;0
WireConnection;7;0;8;0
WireConnection;7;1;3;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;18;2;7;0
WireConnection;18;9;3;4
WireConnection;18;11;14;0
ASEEND*/
//CHKSM=B7788FD4ECB225511569E115F304887E40D28D3D