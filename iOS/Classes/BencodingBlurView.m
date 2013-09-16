/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurView.h"
#import "ImageLoader.h"
#import "TiUIViewProxy.h"
#import "BXBImageHelpers.h"

@implementation BencodingBlurView

-(void)initializeState
{
 
    //This is alittle hacky but, on init create and add our view
    [self blurView];
    //Set our blur defaults
    _blurLevel = [NSNumber numberWithFloat:5.0f];
    _blurFilter = @"CIGaussianBlur";
    _cropToFit = YES;
    _blurTint = [UIColor clearColor];
	[super initializeState];
}

-(UIImageView*)blurView
{

	if (_square == nil) {
		_square = [[UIImageView alloc] initWithFrame:[self frame]];
		[self addSubview:_square];
	}
    
	return _square;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	if ([self blurView] != nil) {
		[TiUtils setView:[self blurView] positionRect:bounds];
	}
}

-(void) setBlurTintColor_:(id)value
{
    TiColor *newColor = [TiUtils colorValue:value];
    _blurTint = [newColor _color];
}

-(void) setBlurCroppedToRect_:(id)value
{
    _cropToFit =[TiUtils boolValue:value def:YES];
}

-(void) setBlurFilter_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    _blurFilter =[TiUtils stringValue:value];
}

-(void) setBlurLevel_:(id)value
{
    _blurLevel =[NSNumber numberWithDouble:[TiUtils doubleValue:value def:5.0]];
}

-(void) setViewToBlur_:(id)viewProxy
{

    ENSURE_SINGLE_ARG(viewProxy, TiViewProxy);
    //CREATE A BLOG IMAGE FROM OUR PROXY
    TiBlob* blobImage = [viewProxy toImage:nil];
    
    //GET THE UIIMAGE FROM THE BLOB, WE'LL BE WORKING WITH THIS FOR AWHILE
    UIImage* workingImg = [blobImage image];
 
    BXBImageHelpers* helper = [[BXBImageHelpers alloc] init];
    
    //CHECK IF WE NEED TO CROP TO THE VIEW'S FRAME
    if(_cropToFit ==YES){
        workingImg = [helper imageCroppedToRect:[self frame] theImage:workingImg];
    }
    
    //PASS THE IMAGE FROM OUR BLOB INTO OUR EFFECT METHOD
    [self blurView].image = [helper applyBlur:workingImg withFilter:_blurFilter withLevel:_blurLevel withTint:_blurTint];
    
}

-(void) setImageToBlur_:(id)args
{
    //LOAD THE IMAGE
    NSURL *url = [TiUtils toURL:args proxy:self.proxy];
    //HANG FETCH THE IMAGE AND HANDL ONTO IT WHILE WE WORK
    UIImage *workingImg = [[ImageLoader sharedLoader] loadImmediateImage:url];
    BXBImageHelpers* helper = [[BXBImageHelpers alloc] init];
    
    //CHECK IF WE NEED TO CROP TO THE VIEW'S FRAME
    if(_cropToFit ==YES){
        workingImg = [helper imageCroppedToRect:[self frame] theImage:workingImg];
    }
    
    //PASS THE IMAGE FROM OUR BLOB INTO OUR EFFECT METHOD
    [self blurView].image = [helper applyBlur:workingImg withFilter:_blurFilter withLevel:_blurLevel withTint:_blurTint];
}

@end
