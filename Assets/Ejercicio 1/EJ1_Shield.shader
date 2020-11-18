// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Parcial 2/Shield"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float8("Float 8", Float) = 1.24
		_Float15("Float 15", Float) = 1.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPosition1;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _TextureSample0;
		uniform sampler2D _TextureSample1;
		uniform float _Float8;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Float15;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos1 = ase_vertex3Pos;
			float4 ase_screenPos1 = ComputeScreenPos( UnityObjectToClipPos( vertexPos1 ) );
			o.screenPosition1 = ase_screenPos1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color91 = IsGammaSpace() ? float4(0.4764151,0.9179929,1,1) : float4(0.192857,0.8234882,1,1);
			float4 appendResult74 = (float4(4.142641 , 4.142641 , 0.0 , 0.0));
			float mulTime77 = _Time.y * 0.25;
			float4 appendResult90 = (float4(mulTime77 , 14.23 , 0.0 , 0.0));
			float2 uv_TexCoord73 = i.uv_texcoord * appendResult74.xy + appendResult90.xy;
			float3 temp_cast_2 = (tex2D( _TextureSample0, uv_TexCoord73 ).g).xxx;
			float grayscale86 = Luminance(temp_cast_2);
			float4 color122 = IsGammaSpace() ? float4(0.9339623,0.2423016,0.5928693,1) : float4(0.8562991,0.04784841,0.3102872,1);
			float4 appendResult106 = (float4(3.024814 , 3.024814 , 0.0 , 0.0));
			float mulTime103 = _Time.y * 0.25;
			float4 appendResult107 = (float4(_Float8 , mulTime103 , 0.0 , 0.0));
			float2 uv_TexCoord108 = i.uv_texcoord * appendResult106.xy + appendResult107.xy;
			float3 temp_cast_5 = (tex2D( _TextureSample1, uv_TexCoord108 ).r).xxx;
			float grayscale100 = Luminance(temp_cast_5);
			float4 temp_output_101_0 = ( color122 * saturate( grayscale100 ) );
			float4 clampResult179 = clamp( temp_output_101_0 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float4 temp_cast_6 = (0.67).xxxx;
			float4 PinkMask203 = saturate( ( 1.0 - (float4( 0,0,0,0 ) + (step( clampResult179 , temp_cast_6 ) - float4( 0,0,0,0 )) * (float4( 1,0,0,0 ) - float4( 0,0,0,0 )) / (float4( 1,0,0,0 ) - float4( 0,0,0,0 ))) ) );
			float grayscale225 = Luminance(PinkMask203.rgb);
			float4 albedoopa415 = ( saturate( ( color91 * grayscale86 ) ) * step( (0.0 + (grayscale225 - 0.99) * (1.0 - 0.0) / (1.0 - 0.99)) , 0.0 ) );
			o.Albedo = albedoopa415.rgb;
			float4 color409 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 ase_screenPos1 = i.screenPosition1;
			float4 ase_screenPosNorm1 = ase_screenPos1 / ase_screenPos1.w;
			ase_screenPosNorm1.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm1.z : ase_screenPosNorm1.z * 0.5 + 0.5;
			float screenDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm1.xy ));
			float distanceDepth1 = saturate( abs( ( screenDepth1 - LinearEyeDepth( ase_screenPosNorm1.z ) ) / ( 0.3 ) ) );
			float mulTime193 = _Time.y * 4.0;
			float clampResult237 = clamp( ( cos( mulTime193 ) + 2.0 ) , 2.0 , 4.0 );
			float4 PinkPattern419 = temp_output_101_0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV421 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode421 = ( 0.0 + 1.68 * pow( 1.0 - fresnelNdotV421, 2.11 ) );
			float4 color422 = IsGammaSpace() ? float4(0,0.755928,1,0) : float4(0,0.531804,1,0);
			o.Emission = ( ( 1.0 - ( color409 * distanceDepth1 * 1.0 ) ) + ( 10.0 * clampResult237 * PinkPattern419 ) + ( fresnelNode421 * color422 ) ).rgb;
			o.Alpha = ( ( 1.0 - albedoopa415 ) / _Float15 ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
607;578;1447;470;-2029.895;-265.8667;1.627718;True;False
Node;AmplifyShaderEditor.RangedFloatNode;102;-1634.913,-237.6644;Inherit;False;Constant;_Float6;Float 6;6;0;Create;True;0;0;False;0;False;0.25;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1497.224,-121.8684;Inherit;False;Property;_Float8;Float 8;3;0;Create;True;0;0;False;0;False;1.24;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;103;-1435.423,-225.7711;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-1496.351,-402.9502;Inherit;False;Constant;_Float7;Float 7;4;0;Create;True;0;0;False;0;False;3.024814;3.493912;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;106;-1187.619,-400.8837;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;107;-1190.415,-231.3093;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-1012.704,-392.659;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;109;-717.6744,-352.5415;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;False;-1;69dc29d658644a548b184956107f9bb0;69dc29d658644a548b184956107f9bb0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;100;-382.1754,-335.7437;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;164;-114.4871,-270.569;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;122;-11.94712,-520.4067;Inherit;False;Constant;_Color1;Color 1;6;0;Create;True;0;0;False;0;False;0.9339623,0.2423016,0.5928693,1;1,0.5235849,0.7644994,0.5882353;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;208.1152,-270.9797;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;183;539.8217,-183.2378;Inherit;False;Constant;_Float4;Float 4;11;0;Create;True;0;0;False;0;False;0.67;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;179;482.1064,-435.4799;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;182;722.9312,-295.133;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1758.279,280.9384;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;False;0.25;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;184;945.6987,-250.6294;Inherit;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;77;-1576.211,294.7674;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1637.139,117.5883;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;False;4.142641;4.083042;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1638.013,398.6701;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;14.23;0.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;186;1249.983,-236.1651;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;90;-1331.204,289.2292;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;74;-1328.408,119.6548;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;185;1443.638,-265.4395;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-1168.599,127.8795;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;1654.969,-264.5235;Inherit;False;PinkMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;69;-916.2125,134.1771;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;69dc29d658644a548b184956107f9bb0;69dc29d658644a548b184956107f9bb0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;204;-511.3026,665.204;Inherit;False;203;PinkMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;86;-416.8445,191.2746;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;225;-274.9402,608.9614;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;91;-421.1928,-67.14344;Inherit;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;False;0;False;0.4764151,0.9179929,1,1;0.1839623,0.8719941,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;216;-29.22484,360.8945;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.99;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-80.36636,21.29783;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;192;1230.053,297.2505;Inherit;False;Constant;_Float10;Float 10;11;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;321;262.2523,337.4718;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;311;268.4049,49.14771;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;193;1430.358,259.449;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;2211.411,-10.63645;Inherit;False;Constant;_Float5;Float 5;9;0;Create;True;0;0;False;0;False;0.3;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;1606.866,397.1523;Inherit;False;Constant;_Float11;Float 11;11;0;Create;True;0;0;False;0;False;2;4.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;522.5054,55.95978;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CosOpNode;239;1625.955,216.987;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;386;2068.704,-156.617;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;409;2028.99,52.8586;Inherit;False;Constant;_Color5;Color 5;9;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;238;1969.192,493.2807;Inherit;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;False;4;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;1;2391.05,-90.45169;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;419;524.4726,-71.6694;Inherit;False;PinkPattern;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;1840.538,224.075;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;413;2381.868,139.1442;Inherit;False;Constant;_Float29;Float 29;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;415;794.4113,62.85027;Inherit;False;albedoopa;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;323;2455.217,228.4646;Inherit;False;Constant;_Float28;Float 28;8;0;Create;True;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;421;2860.781,754.0854;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.68;False;3;FLOAT;2.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;422;3064.965,861.8323;Inherit;False;Constant;_Color2;Color 2;4;0;Create;True;0;0;False;0;False;0,0.755928,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;407;2608.59,5.407396;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;420;2338.82,449.0145;Inherit;False;419;PinkPattern;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;2181.45,580.4626;Inherit;False;415;albedoopa;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;237;2183.883,232.0431;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;346;2441.468,555.5004;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;410;2763.89,141.0455;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;2609.336,295.5319;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;423;3131.669,551.8461;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;399;2718.577,638.7032;Inherit;False;Property;_Float15;Float 15;4;0;Create;True;0;0;False;0;False;1.5;2.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;424;544.1524,318.6171;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;412;2967.03,243.8224;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;398;2823.778,481.3765;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;417;2852.224,25.37943;Inherit;False;415;albedoopa;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3463.452,193.8373;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Parcial 2/Shield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;103;0;102;0
WireConnection;106;0;104;0
WireConnection;106;1;104;0
WireConnection;107;0;105;0
WireConnection;107;1;103;0
WireConnection;108;0;106;0
WireConnection;108;1;107;0
WireConnection;109;1;108;0
WireConnection;100;0;109;1
WireConnection;164;0;100;0
WireConnection;101;0;122;0
WireConnection;101;1;164;0
WireConnection;179;0;101;0
WireConnection;182;0;179;0
WireConnection;182;1;183;0
WireConnection;184;0;182;0
WireConnection;77;0;78;0
WireConnection;186;0;184;0
WireConnection;90;0;77;0
WireConnection;90;1;89;0
WireConnection;74;0;75;0
WireConnection;74;1;75;0
WireConnection;185;0;186;0
WireConnection;73;0;74;0
WireConnection;73;1;90;0
WireConnection;203;0;185;0
WireConnection;69;1;73;0
WireConnection;86;0;69;2
WireConnection;225;0;204;0
WireConnection;216;0;225;0
WireConnection;85;0;91;0
WireConnection;85;1;86;0
WireConnection;321;0;216;0
WireConnection;311;0;85;0
WireConnection;193;0;192;0
WireConnection;345;0;311;0
WireConnection;345;1;321;0
WireConnection;239;0;193;0
WireConnection;1;1;386;0
WireConnection;1;0;98;0
WireConnection;419;0;101;0
WireConnection;195;0;239;0
WireConnection;195;1;196;0
WireConnection;415;0;345;0
WireConnection;407;0;409;0
WireConnection;407;1;1;0
WireConnection;407;2;413;0
WireConnection;237;0;195;0
WireConnection;237;2;238;0
WireConnection;346;0;416;0
WireConnection;410;0;407;0
WireConnection;300;0;323;0
WireConnection;300;1;237;0
WireConnection;300;2;420;0
WireConnection;423;0;421;0
WireConnection;423;1;422;0
WireConnection;412;0;410;0
WireConnection;412;1;300;0
WireConnection;412;2;423;0
WireConnection;398;0;346;0
WireConnection;398;1;399;0
WireConnection;0;0;417;0
WireConnection;0;2;412;0
WireConnection;0;9;398;0
ASEEND*/
//CHKSM=B09E78AE1FC63520C8A84A12BB398339DCE33676