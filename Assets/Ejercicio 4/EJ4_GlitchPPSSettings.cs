// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( EJ4_GlitchPPSRenderer ), PostProcessEvent.AfterStack, "EJ4_Glitch", true )]
public sealed class EJ4_GlitchPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "MinAmountB" )]
	public FloatParameter _MinAmountB = new FloatParameter { value = 0.3f };
	[Tooltip( "MinAmountG" )]
	public FloatParameter _MinAmountG = new FloatParameter { value = 0.3f };
	[Tooltip( "MinAmountR" )]
	public FloatParameter _MinAmountR = new FloatParameter { value = 0.3f };
	[Tooltip( "Scale Red" )]
	public FloatParameter _ScaleRed = new FloatParameter { value = 4f };
	[Tooltip( "Scale Green" )]
	public FloatParameter _ScaleGreen = new FloatParameter { value = 4f };
	[Tooltip( "Scale Blue" )]
	public FloatParameter _ScaleBlue = new FloatParameter { value = 4f };
	[Tooltip( "TimeScale" )]
	public FloatParameter _TimeScale = new FloatParameter { value = 1f };
}

public sealed class EJ4_GlitchPPSRenderer : PostProcessEffectRenderer<EJ4_GlitchPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "EJ4_Glitch" ) );
		sheet.properties.SetFloat( "_MinAmountB", settings._MinAmountB );
		sheet.properties.SetFloat( "_MinAmountG", settings._MinAmountG );
		sheet.properties.SetFloat( "_MinAmountR", settings._MinAmountR );
		sheet.properties.SetFloat( "_ScaleRed", settings._ScaleRed );
		sheet.properties.SetFloat( "_ScaleGreen", settings._ScaleGreen );
		sheet.properties.SetFloat( "_ScaleBlue", settings._ScaleBlue );
		sheet.properties.SetFloat( "_TimeScale", settings._TimeScale );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
