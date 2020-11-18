// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dissolve"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Direction("Direction", Vector) = (1,1,0,0)
		_Vector1("Vector 1", Vector) = (1,1,0,0)
		_Speed("Speed", Float) = 0
		_Float3("Float 3", Float) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_FireOpacity("Fire Opacity", Range( 0 , 1)) = 0.1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
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


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform sampler2D _TextureSample2;
			uniform sampler2D _TextureSample1;
			uniform sampler2D _TextureSample0;
			uniform float _Speed;
			uniform float2 _Direction;
			uniform sampler2D _TextureSample4;
			uniform float _Float3;
			uniform float2 _Vector1;
			uniform float _FireOpacity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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

#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
#endif
				float2 temp_cast_0 = (-0.51).xx;
				float2 uv0105 = i.ase_texcoord1.xy * temp_cast_0 + float2( 0,0 );
				float4 break48 = ( i.ase_color * tex2D( _TextureSample2, uv0105 ) );
				float2 temp_cast_1 = (1.0).xx;
				float2 uv0103 = i.ase_texcoord1.xy * temp_cast_1 + float2( 0,0 );
				float2 temp_cast_2 = (0.0).xx;
				float mulTime41 = _Time.y * _Speed;
				float2 panner37 = ( mulTime41 * _Direction + i.ase_texcoord1.xy);
				float2 uv050 = i.ase_texcoord1.xy * temp_cast_2 + panner37;
				float2 temp_cast_3 = (0.0).xx;
				float mulTime85 = _Time.y * _Float3;
				float2 panner86 = ( mulTime85 * _Vector1 + i.ase_texcoord1.xy);
				float2 uv087 = i.ase_texcoord1.xy * temp_cast_3 + panner86;
				float4 lerpResult44 = lerp( ( 1.0 - step( tex2D( _TextureSample1, uv0103 ) , float4( 0.4811321,0.4811321,0.4811321,0 ) ) ) , float4( 0,0,0,0 ) , ( step( tex2D( _TextureSample0, uv050 ) , float4( 0.5377358,0.5377358,0.5377358,0 ) ) * step( tex2D( _TextureSample4, uv087 ) , float4( 0.8490566,0.8490566,0.8490566,0 ) ) ));
				float4 appendResult49 = (float4(break48.r , break48.g , break48.b , ( lerpResult44 * _FireOpacity ).r));
				
				
				finalColor = appendResult49;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
204;649;1166;275;1192.174;1047.464;1.6;True;False
Node;AmplifyShaderEditor.RangedFloatNode;42;-1513.286,-184.3947;Inherit;False;Property;_Speed;Speed;8;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-1540.997,386.8327;Inherit;False;Property;_Float3;Float 3;9;0;Create;True;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;38;-1425.431,-579.0406;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;83;-1461.93,193.0673;Inherit;False;Property;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;False;1,1;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;85;-1302.469,325.053;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;40;-1371.722,-433.1578;Inherit;False;Property;_Direction;Direction;4;0;Create;True;0;0;False;0;False;1,1;0,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;84;-1440.643,22.1855;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;41;-1274.758,-246.1744;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-855.5403,-709.024;Inherit;False;Constant;_Float7;Float 0;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;86;-1133.073,61.79317;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;37;-1086.921,-434.8876;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1014.437,-237.7092;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-627.0535,-638.299;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-875.2271,-572.4528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-902.9375,-1.225454;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;104;-588.8972,-806.3464;Inherit;False;Constant;_Float8;Float 0;5;0;Create;True;0;0;False;0;False;-0.51;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;-612.197,11.34182;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;False;0;False;-1;None;97ea962fe78452949bcf25116a202ae9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-622.3834,-390.8759;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;97ea962fe78452949bcf25116a202ae9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-371.8323,-640.9688;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;False;-1;None;97ea962fe78452949bcf25116a202ae9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;66;-7.430506,-602.8629;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0.4811321,0.4811321,0.4811321,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;88;-251.0522,-96.43798;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0.8490566,0.8490566,0.8490566,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;36;-233.8611,-339.1192;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0.5377358,0.5377358,0.5377358,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;105;-327.3748,-908.4235;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;67;245.9993,-572.8267;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;29.9774,-266.9282;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;-60.1363,-915.4244;Inherit;True;Property;_TextureSample2;Texture Sample 2;12;0;Create;True;0;0;False;0;False;-1;None;069f9d23c3ac33849b6adfa8d04bb515;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;73;578.1942,-851.6464;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;44;401.2901,-310.6086;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;712.0751,-660.9722;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;74;359.7609,-50.08039;Inherit;False;Property;_FireOpacity;Fire Opacity;13;0;Create;True;0;0;False;0;False;0.1;0.372;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;34;419.4578,412.3532;Inherit;False;525.7368;405.8174;Nodos fundamentales;4;6;27;13;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;48;892.6665,-535.4219;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;772.8168,-236.2802;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;-1119.896,615.2929;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;-1757.954,1003.351;Inherit;False;Property;_Float4;Float 4;10;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;94;-1519.427,941.5713;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;93;-1657.6,638.7039;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;27;469.4578,655.3238;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;6;496.3198,462.3532;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;13;778.4696,487.2287;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;1192.769,-405.1036;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;100;-272.8684,590.1153;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0.8490566,0.8490566,0.8490566,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;58;-1052.617,-956.8849;Inherit;False;Property;_Vector0;Vector 0;7;0;Create;True;0;0;False;0;False;1,1;1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;97;-1350.031,678.3115;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;778.1946,639.1706;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1338.23,517.7129;Inherit;False;Constant;_Float5;Float 5;5;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;61;-573.8768,-992.1889;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1179.922,-800.7362;Inherit;False;Property;_Float2;Float 2;11;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;95;-1678.888,809.5857;Inherit;False;Property;_Vector2;Vector 2;6;0;Create;True;0;0;False;0;False;1,1;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;59;-893.1566,-823.0485;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;60;-1031.33,-1125.916;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;99;-886.9921,714.6162;Inherit;True;Property;_TextureSample5;Texture Sample 5;2;0;Create;True;0;0;False;0;False;-1;None;97ea962fe78452949bcf25116a202ae9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;29;1578.507,-357.1169;Float;False;True;-1;2;ASEMaterialInspector;100;1;Dissolve;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;85;0;80;0
WireConnection;41;0;42;0
WireConnection;86;0;84;0
WireConnection;86;2;83;0
WireConnection;86;1;85;0
WireConnection;37;0;38;0
WireConnection;37;2;40;0
WireConnection;37;1;41;0
WireConnection;103;0;102;0
WireConnection;50;0;51;0
WireConnection;50;1;37;0
WireConnection;87;0;51;0
WireConnection;87;1;86;0
WireConnection;82;1;87;0
WireConnection;35;1;50;0
WireConnection;43;1;103;0
WireConnection;66;0;43;0
WireConnection;88;0;82;0
WireConnection;36;0;35;0
WireConnection;105;0;104;0
WireConnection;67;0;66;0
WireConnection;91;0;36;0
WireConnection;91;1;88;0
WireConnection;45;1;105;0
WireConnection;44;0;67;0
WireConnection;44;2;91;0
WireConnection;72;0;73;0
WireConnection;72;1;45;0
WireConnection;48;0;72;0
WireConnection;76;0;44;0
WireConnection;76;1;74;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;94;0;92;0
WireConnection;49;0;48;0
WireConnection;49;1;48;1
WireConnection;49;2;48;2
WireConnection;49;3;76;0
WireConnection;100;0;99;0
WireConnection;97;0;93;0
WireConnection;97;2;95;0
WireConnection;97;1;94;0
WireConnection;61;0;60;0
WireConnection;61;2;58;0
WireConnection;61;1;59;0
WireConnection;59;0;57;0
WireConnection;99;1;98;0
WireConnection;29;0;49;0
ASEEND*/
//CHKSM=6DAECBACD2C8EDA293B15AFD1F1DA0E93C258183