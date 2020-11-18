// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( CameraPostPPSRenderer ), PostProcessEvent.AfterStack, "CameraPost", true )]
public sealed class CameraPostPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Texture Sample 2" )]
	public TextureParameter _TextureSample2 = new TextureParameter {  };
	[Tooltip( "_Amount" )]
	public FloatParameter _Amount = new FloatParameter { value = 0f };
}

public sealed class CameraPostPPSRenderer : PostProcessEffectRenderer<CameraPostPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "CameraPost" ) );
		if(settings._TextureSample2.value != null) sheet.properties.SetTexture( "_TextureSample2", settings._TextureSample2 );
		sheet.properties.SetFloat( "_Amount", settings._Amount );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
