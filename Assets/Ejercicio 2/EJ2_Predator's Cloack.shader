// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Predators Cloack"
{
	Properties
	{
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Cubemap("Cubemap", CUBE) = "white" {}
		_PatternTexture("Pattern Texture", 2D) = "white" {}
		_ActiveInvisibility("Active Invisibility", Range( 0 , 1)) = 0
		_Float9("Float 9", Range( 1 , 100)) = 26.346
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Float1("Float 1", Float) = 10
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_Float11("Float 11", Float) = 0
		_Float10("Float 10", Float) = 0.29
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _TextureSample1;
		uniform float _Float9;
		uniform float _Float10;
		uniform float _ActiveInvisibility;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Opacity;
		uniform sampler2D _PatternTexture;
		uniform float _Float1;
		uniform samplerCUBE _Cubemap;
		uniform float _Float11;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode2 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float4 color111 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float4 appendResult275 = (float4(_Float9 , _Float9 , 0.0 , 0.0));
			float2 uv_TexCoord276 = i.uv_texcoord * appendResult275.xy;
			float ActiveEffect97 = _ActiveInvisibility;
			float4 lerpResult298 = lerp( ( float4( tex2DNode2 , 0.0 ) * color111 ) , float4( ( UnpackNormal( tex2D( _TextureSample1, uv_TexCoord276 ) ) + _Float10 ) , 0.0 ) , ActiveEffect97);
			o.Normal = lerpResult298.rgb;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = ( tex2D( _TextureSample0, uv_TextureSample0 ) * ( 1.0 - ActiveEffect97 ) ).rgb;
			float Opacity120 = _Opacity;
			float temp_output_240_0 = ( 1.0 - ActiveEffect97 );
			float4 color160 = IsGammaSpace() ? float4(0,0.2333052,0.5849056,1) : float4(0,0.04444675,0.301212,1);
			float4 appendResult143 = (float4(2.749385 , 2.749385 , 0.0 , 0.0));
			float2 uv_TexCoord144 = i.uv_texcoord * appendResult143.xy;
			float mulTime150 = _Time.y * ( Opacity120 * -3.0 );
			float3 objToWorld161 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 ase_worldPos = i.worldPos;
			float clampResult168 = clamp( ( cos( ( _Float1 * ( Opacity120 == 0.0 ? 0.0 : Opacity120 ) * ( mulTime150 + distance( objToWorld161 , ase_worldPos ) ) ) ) + 0.4 ) , 0.0 , 1.06 );
			float4 temp_cast_6 = (0.0).xxxx;
			float4 temp_cast_7 = (3000.0).xxxx;
			float4 clampResult212 = clamp( ( (-1.0 + (ActiveEffect97 - 0.0) * (1.8 - -1.0) / (1.0 - 0.0)) * ( ( float4( 0,0,0,0 ) + ( color160 * ( 1.0 - step( ( (0.0 + (tex2D( _PatternTexture, uv_TexCoord144 ).r - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) - 0.78 ) , 0.0 ) ) * clampResult168 ) ) * 22.3 ) ) , temp_cast_6 , temp_cast_7 );
			float4 ShieldEffect164 = (  ( ActiveEffect97 - 0.0 > Opacity120 ? 0.0 : ActiveEffect97 - 0.0 <= Opacity120 && ActiveEffect97 + 0.0 >= Opacity120 ? 0.0 : temp_output_240_0 )  * clampResult212 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			o.Emission = ( ShieldEffect164 + ( ( texCUBE( _Cubemap, refract( -ase_worldViewDir , ase_worldNormal , 0.2460185 ) ) * _Float11 ) * ActiveEffect97 * Opacity120 ) ).rgb;
			o.Alpha = Opacity120;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
44;524;1447;451;820.8182;-1100.991;1.45751;True;False
Node;AmplifyShaderEditor.RangedFloatNode;114;859.5403,1833.52;Inherit;False;Property;_Opacity;Opacity;6;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;1169.31,1832.341;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-647.282,2209.419;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;False;2.749385;3.493912;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;232;-272.587,2465.582;Inherit;False;120;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;-94.87203,2627.81;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-3;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;143;-338.5505,2211.485;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TransformPositionNode;161;72.88971,2771.096;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;149;113.7278,2962.014;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;150;339.5689,2679.99;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;151;355.5689,2807.99;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;144;-173.7891,2229.973;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;237;44.69351,2560.674;Inherit;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;88.75768,2270.549;Inherit;True;Property;_PatternTexture;Pattern Texture;3;0;Create;True;0;0;False;0;False;-1;69dc29d658644a548b184956107f9bb0;69dc29d658644a548b184956107f9bb0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;236;299.3122,2512.984;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;483.569,2535.99;Inherit;False;Property;_Float1;Float 1;8;0;Create;True;0;0;False;0;False;10;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;531.569,2727.99;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;707.5678,2551.99;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;80;395.2516,2273.465;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;136;681.8404,2290.567;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.78;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;157;942.9939,2573.744;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;923.154,2856.289;Inherit;False;Constant;_Float3;Float 3;11;0;Create;True;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;137;916.3589,2294.533;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;1191.316,2579.477;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;2636.548,1777.95;Inherit;False;Property;_ActiveInvisibility;Active Invisibility;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;146;1203.379,2426.386;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;168;1491.684,2608.376;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;160;1574.853,2317.103;Inherit;False;Constant;_Color0;Color 0;11;0;Create;True;0;0;False;0;False;0,0.2333052,0.5849056,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;1871.515,2485.085;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;2913.694,1779.792;Inherit;False;ActiveEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;128;2511.457,2040.384;Inherit;False;508.2137;229.2429;Nuevo valor para que coincida con la animación;2;113;112;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;2226.071,2325.29;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;2561.457,2090.385;Inherit;False;97;ActiveEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;2562.944,2512.004;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;False;0;False;22.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;2838.775,2374.782;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;113;2794.915,2094.894;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;131;-478.4021,1489.48;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;213;3178.881,2357.339;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-295.0683,1798.636;Inherit;False;Constant;_Index;Index;8;0;Create;True;0;0;False;0;False;0.2460185;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;274;-948.8799,1330.117;Inherit;False;Property;_Float9;Float 9;5;0;Create;True;0;0;False;0;False;26.346;6.459609;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;3178.881,2435.339;Inherit;False;Constant;_Float6;Float 6;10;0;Create;True;0;0;False;0;False;3000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;3119.955,1981.131;Inherit;False;120;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;132;-249.4139,1582.61;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;133;-509.7447,1678.727;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;3137.427,2097.647;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;240;3250.416,1782.572;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;122;233.0574,1625.222;Inherit;False;371;280;Requiere un Skybox;1;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCIf;242;3449.232,1646.383;Inherit;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;125;-436.7036,785.043;Inherit;False;491;526.0035;Normal Map;2;121;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RefractOpVec;41;11.66501,1682.188;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;275;-673.3615,1316.789;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;212;3438.349,2096.622;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;297;656.2723,2038.397;Inherit;False;Property;_Float11;Float 11;10;0;Create;True;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;121;-386.7037,1038.047;Inherit;False;391;251;Necesario como color Default del Normal Map;1;111;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;3742.577,2091.329;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;47;283.0574,1675.222;Inherit;True;Property;_Cubemap;Cubemap;2;0;Create;True;0;0;False;0;False;-1;e7dbcb6a89bacf04f8a8e3c2382610e4;e7dbcb6a89bacf04f8a8e3c2382610e4;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;276;-478.2068,1338.879;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;3916.155,2101.761;Inherit;False;ShieldEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;111;-282.7036,1104.046;Inherit;False;Constant;_NormalColor;Normal Color;16;0;Create;True;0;0;False;0;False;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;222;1079.784,1680.713;Inherit;False;97;ActiveEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;301;141.1385,1548.446;Inherit;False;Property;_Float10;Float 10;11;0;Create;True;0;0;False;0;False;0.29;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;749.2865,1669.704;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;244;903.2125,1237.31;Inherit;False;97;ActiveEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;269;-0.03830147,1321.632;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;False;0;False;-1;bb78f7baf3f41af4fa26c78f69b2bd0a;bb78f7baf3f41af4fa26c78f69b2bd0a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-338.3888,835.043;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;False;-1;bf00c8fccda396c4aac04e4ad4ac1a0d;bf00c8fccda396c4aac04e4ad4ac1a0d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;299;529.1384,1460.811;Inherit;False;97;ActiveEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;1089.205,1438.234;Inherit;False;164;ShieldEffect;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;130;935.3515,944.3707;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;False;-1;c987be1ee0ef6cd449b2b22e377d1308;c987be1ee0ef6cd449b2b22e377d1308;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;254;1158.215,1238.851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;1403.483,1559.573;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;273.179,1080.407;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;347.8376,1328.471;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;298;678.1657,1311.362;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;268;971.8272,856.6328;Inherit;False;Constant;_Float8;Float 8;8;0;Create;True;0;0;False;0;False;0.59;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;1370.359,1047.9;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;263;570.4309,799.2582;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;266;336.7202,915.0768;Inherit;False;1;0;FLOAT;0.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;1947.635,2271.892;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;225;3501.232,1879.769;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;221;1639.208,1452.098;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;261;233.4983,815.3743;Inherit;False;Constant;_Float7;Float 7;4;0;Create;True;0;0;False;0;False;56.18897;3.493912;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;279;-884.1641,1453.622;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;264;1218.59,733.5351;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;260;1134.792,1144.289;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2011.635,1342.383;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Predators Cloack;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;120;0;114;0
WireConnection;231;0;232;0
WireConnection;143;0;139;0
WireConnection;143;1;139;0
WireConnection;150;0;231;0
WireConnection;151;0;161;0
WireConnection;151;1;149;0
WireConnection;144;0;143;0
WireConnection;77;1;144;0
WireConnection;236;0;232;0
WireConnection;236;1;237;0
WireConnection;236;2;237;0
WireConnection;236;3;232;0
WireConnection;152;0;150;0
WireConnection;152;1;151;0
WireConnection;154;0;153;0
WireConnection;154;1;236;0
WireConnection;154;2;152;0
WireConnection;80;0;77;1
WireConnection;136;0;80;0
WireConnection;157;0;154;0
WireConnection;137;0;136;0
WireConnection;158;0;157;0
WireConnection;158;1;159;0
WireConnection;146;0;137;0
WireConnection;168;0;158;0
WireConnection;156;0;160;0
WireConnection;156;1;146;0
WireConnection;156;2;168;0
WireConnection;97;0;96;0
WireConnection;170;1;156;0
WireConnection;174;0;170;0
WireConnection;174;1;175;0
WireConnection;113;0;112;0
WireConnection;132;0;131;0
WireConnection;176;0;113;0
WireConnection;176;1;174;0
WireConnection;240;0;97;0
WireConnection;242;0;97;0
WireConnection;242;1;216;0
WireConnection;242;4;240;0
WireConnection;41;0;132;0
WireConnection;41;1;133;0
WireConnection;41;2;134;0
WireConnection;275;0;274;0
WireConnection;275;1;274;0
WireConnection;212;0;176;0
WireConnection;212;1;213;0
WireConnection;212;2;214;0
WireConnection;215;0;242;0
WireConnection;215;1;212;0
WireConnection;47;1;41;0
WireConnection;276;0;275;0
WireConnection;164;0;215;0
WireConnection;295;0;47;0
WireConnection;295;1;297;0
WireConnection;269;1;276;0
WireConnection;254;0;244;0
WireConnection;220;0;295;0
WireConnection;220;1;222;0
WireConnection;220;2;120;0
WireConnection;129;0;2;0
WireConnection;129;1;111;0
WireConnection;300;0;269;0
WireConnection;300;1;301;0
WireConnection;298;0;129;0
WireConnection;298;1;300;0
WireConnection;298;2;299;0
WireConnection;257;0;130;0
WireConnection;257;1;254;0
WireConnection;263;0;261;0
WireConnection;263;1;266;0
WireConnection;225;0;216;0
WireConnection;225;1;97;0
WireConnection;225;2;216;0
WireConnection;225;3;240;0
WireConnection;221;0;165;0
WireConnection;221;1;220;0
WireConnection;264;0;263;0
WireConnection;264;1;268;0
WireConnection;0;0;257;0
WireConnection;0;1;298;0
WireConnection;0;2;221;0
WireConnection;0;9;120;0
ASEEND*/
//CHKSM=46B33D1904A16DD8326E7A3D4631836543D3EFF3