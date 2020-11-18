// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "s_Mutant"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		[HDR]_Tint1("Tint 1", Color) = (0,0,0,0)
		[HDR]_Tint2("Tint 2", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float4 _Tint1;
		uniform float4 _Tint2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTexture, uv_MainTexture );
			o.Albedo = tex2DNode1.rgb;
			float temp_output_23_0 = ( tex2DNode1.g - tex2DNode1.r );
			float temp_output_24_0 = ( tex2DNode1.b - tex2DNode1.r );
			float temp_output_28_0 = saturate( ( temp_output_23_0 + temp_output_24_0 ) );
			float4 blendOpSrc39 = ( temp_output_28_0 * _Tint1 );
			float4 blendOpDest39 = ( temp_output_28_0 * _Tint2 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult34 = lerp( float4( 0,0,0,0 ) , ( saturate( abs( blendOpSrc39 - blendOpDest39 ) )) , saturate( ( ase_vertex3Pos.y + 0.0 ) ));
			o.Emission = lerpResult34.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
2;333;1349;538;703.4589;-197.2932;1.909548;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-1209.773,168.644;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;False;0;-1;None;c987be1ee0ef6cd449b2b22e377d1308;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-657.7798,289.5929;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-660.4063,420.9695;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-280.6423,361.42;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-101.9272,359.1512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-125.5368,452.8047;Inherit;False;Property;_Tint2;Tint 2;3;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,4.541205,0.4041911,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-116.5588,697.6885;Inherit;False;Property;_Tint1;Tint 1;2;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,1.403922,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;32;-284.9393,891.8577;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;140.4304,588.281;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;113.3347,308.2826;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;7.160859,934.2112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;221.3558,934.3807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;39;317.5459,425.4832;Inherit;False;Difference;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;34;627.9612,408.7387;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;413.2106,144.0464;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;-1;None;bf00c8fccda396c4aac04e4ad4ac1a0d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;26;-470.6423,420.42;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;25;-446.7144,274.7321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;905.713,-24.19631;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;s_Mutant;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;1;2
WireConnection;23;1;1;1
WireConnection;24;0;1;3
WireConnection;24;1;1;1
WireConnection;27;0;23;0
WireConnection;27;1;24;0
WireConnection;28;0;27;0
WireConnection;30;0;28;0
WireConnection;30;1;31;0
WireConnection;37;0;28;0
WireConnection;37;1;38;0
WireConnection;35;0;32;2
WireConnection;36;0;35;0
WireConnection;39;0;30;0
WireConnection;39;1;37;0
WireConnection;34;1;39;0
WireConnection;34;2;36;0
WireConnection;26;0;24;0
WireConnection;25;0;23;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;34;0
ASEEND*/
//CHKSM=A1B25955BCD2FFF59585F199B2DA181A93FF8A28