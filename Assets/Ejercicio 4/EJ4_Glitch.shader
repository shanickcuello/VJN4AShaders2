// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EJ4_Glitch"
{
	Properties
	{
		_MinAmountB("MinAmountB", Float) = 0.3
		_MinAmountG("MinAmountG", Float) = 0.3
		_MinAmountR("MinAmountR", Float) = 0.3
		_ScaleRed("Scale Red", Float) = 4
		_ScaleGreen("Scale Green", Float) = 4
		_ScaleBlue("Scale Blue", Float) = 4
		_TimeScale("TimeScale", Float) = 1

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _ScaleRed;
			uniform float _TimeScale;
			uniform float _MinAmountR;
			uniform float _ScaleGreen;
			uniform float _MinAmountG;
			uniform float _ScaleBlue;
			uniform float _MinAmountB;


			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash24( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi24( float2 v, float time, inout float2 id, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mr = 0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash24( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						
			F1 = 8.0;
			for ( int j = -2; j <= 2; j++ )
			{
			for ( int i = -2; i <= 2; i++ )
			{
			float2 g = mg + float2( i, j );
			float2 o = voronoihash24( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
			float d = dot( 0.5 * ( mr + r ), normalize( r - mr ) );
			F1 = min( F1, d );
			}
			}
			return F1;
					}
			
					float2 voronoihash65( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi65( float2 v, float time, inout float2 id, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mr = 0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash65( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						
			F1 = 8.0;
			for ( int j = -2; j <= 2; j++ )
			{
			for ( int i = -2; i <= 2; i++ )
			{
			float2 g = mg + float2( i, j );
			float2 o = voronoihash65( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
			float d = dot( 0.5 * ( mr + r ), normalize( r - mr ) );
			F1 = min( F1, d );
			}
			}
			return F1;
					}
			
					float2 voronoihash76( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi76( float2 v, float time, inout float2 id, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mr = 0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash76( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						
			F1 = 8.0;
			for ( int j = -2; j <= 2; j++ )
			{
			for ( int i = -2; i <= 2; i++ )
			{
			float2 g = mg + float2( i, j );
			float2 o = voronoihash76( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
			float d = dot( 0.5 * ( mr + r ), normalize( r - mr ) );
			F1 = min( F1, d );
			}
			}
			return F1;
					}
			

			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float mulTime82 = _Time.y * _TimeScale;
				float2 temp_cast_0 = (mulTime82).xx;
				float simplePerlin2D80 = snoise( temp_cast_0*1.0 );
				simplePerlin2D80 = simplePerlin2D80*0.5 + 0.5;
				float clampResult81 = clamp( simplePerlin2D80 , 0.0 , 10.0 );
				float Randomness97 = clampResult81;
				float time24 = Randomness97;
				float2 uv054 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords24 = uv054 * _ScaleRed;
				float2 id24 = 0;
				float voroi24 = voronoi24( coords24, time24,id24, 0 );
				float2 uv057 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult56 = lerp( id24 , uv057 , _MinAmountR);
				float time65 = Randomness97;
				float2 uv062 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords65 = uv062 * _ScaleGreen;
				float2 id65 = 0;
				float voroi65 = voronoi65( coords65, time65,id65, 0 );
				float2 uv066 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult67 = lerp( id65 , uv066 , _MinAmountG);
				float time76 = Randomness97;
				float2 uv073 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords76 = uv073 * _ScaleBlue;
				float2 id76 = 0;
				float voroi76 = voronoi76( coords76, time76,id76, 0 );
				float2 uv077 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult71 = lerp( id76 , uv077 , _MinAmountB);
				float4 appendResult60 = (float4(tex2D( _MainTex, lerpResult56 ).r , tex2D( _MainTex, lerpResult67 ).g , tex2D( _MainTex, lerpResult71 ).b , 0.0));
				

				float4 color = appendResult60;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
179;433;1447;490;3233.892;-1235.461;1.83813;True;False
Node;AmplifyShaderEditor.RangedFloatNode;90;-3519.35,339.3347;Inherit;False;Property;_TimeScale;TimeScale;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3288.834,533.669;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;82;-3356.556,409.1862;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;80;-3067.327,428.6845;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;81;-2784.115,424.8982;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2267.321,420.3397;Inherit;False;Randomness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2364.566,913.6382;Inherit;False;97;Randomness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-2217.004,1418.288;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-2095.313,1637.197;Inherit;False;Property;_ScaleBlue;Scale Blue;5;0;Create;True;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2138.22,1016.91;Inherit;False;Property;_ScaleGreen;Scale Green;4;0;Create;True;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2303.819,1578.163;Inherit;False;97;Randomness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1789.852,336.5729;Inherit;False;Property;_ScaleRed;Scale Red;3;0;Create;True;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1919.373,148.0874;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-2225.309,714.7461;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2023.782,512.1217;Inherit;False;97;Randomness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-1834.417,1275.449;Inherit;False;Property;_MinAmountG;MinAmountG;1;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-1505.104,683.1674;Inherit;False;Property;_MinAmountR;MinAmountR;2;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;76;-1881.004,1450.288;Inherit;True;0;0;1;4;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;4;False;2;FLOAT;4.84;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-1904,1104;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;65;-1904,800;Inherit;True;0;0;1;4;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;4;False;2;FLOAT;4.84;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;101;-1966.705,1930.185;Inherit;False;Property;_MinAmountB;MinAmountB;0;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1575.626,480.3298;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;24;-1579.142,174.7959;Inherit;True;0;0;1;4;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;4;False;2;FLOAT;4.84;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-1879.204,1730.884;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;71;-1493.137,1614.242;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;56;-1295.083,439.9617;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;67;-1437.818,902.3387;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;69;-1184.049,905.4668;Inherit;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;79;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-987.8738,455.5421;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;79;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;70;-1161.053,1555.754;Inherit;True;Property;_TextureSample2;Texture Sample 2;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;79;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;60;-451.9946,522.56;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;44;-1050.789,164.7949;Inherit;False;0;0;_MainTex;Pass;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;79;-830.7837,160.9271;Inherit;True;Property;_MainCameraRef;Main Camera Ref;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-114.6462,585.214;Float;False;True;-1;2;ASEMaterialInspector;0;2;EJ4_Glitch;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;82;0;90;0
WireConnection;80;0;82;0
WireConnection;80;1;83;0
WireConnection;81;0;80;0
WireConnection;97;0;81;0
WireConnection;76;0;73;0
WireConnection;76;1;100;0
WireConnection;76;2;75;0
WireConnection;65;0;62;0
WireConnection;65;1;99;0
WireConnection;65;2;64;0
WireConnection;24;0;54;0
WireConnection;24;1;98;0
WireConnection;24;2;55;0
WireConnection;71;0;76;1
WireConnection;71;1;77;0
WireConnection;71;2;101;0
WireConnection;56;0;24;1
WireConnection;56;1;57;0
WireConnection;56;2;104;0
WireConnection;67;0;65;1
WireConnection;67;1;66;0
WireConnection;67;2;102;0
WireConnection;69;1;67;0
WireConnection;59;1;56;0
WireConnection;70;1;71;0
WireConnection;60;0;59;1
WireConnection;60;1;69;2
WireConnection;60;2;70;3
WireConnection;79;0;44;0
WireConnection;0;0;60;0
ASEEND*/
//CHKSM=4A690211C3CA021CC11E102A39C32D21B8A45CC3