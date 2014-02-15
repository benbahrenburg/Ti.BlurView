/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurGlassView.h"

@implementation BencodingBlurGlassView

-(void)initializeState
{
    [self GlassView];
	[super initializeState];
}

-(UIView*)GlassView
{

    [self setClipsToBounds:YES];
    
	if (_glassView == nil) {
		_glassView = [[UIView alloc] initWithFrame:[self frame]];
        _toolbar =[[UIToolbar alloc] initWithFrame:[self bounds]];
        [_toolbar setBarTintColor:[UIColor whiteColor]];
        [_glassView.layer insertSublayer:[_toolbar layer] atIndex:0];
        [_glassView setAlpha:0.85];
		[self addSubview:_glassView];
	}
    
	return _glassView;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	if (_glassView != nil) {
		[TiUtils setView:_glassView positionRect:bounds];
        [_toolbar setFrame:[self bounds]];
	}
}

-(void) setBlurAlpha_:(id)value
{
    [[self GlassView] setAlpha:[TiUtils floatValue:value def:1]];
}

-(void) setBlurTintColor_:(id)value
{
    TiColor *newColor = [TiUtils colorValue:value];
    [_toolbar setBarTintColor:[newColor _color]];
}


@end
