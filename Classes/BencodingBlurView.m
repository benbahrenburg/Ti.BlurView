/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurView.h"
#import "ImageLoader.h"
#import <CoreImage/CoreImageDefines.h>
#import "TiUIViewProxy.h"

@implementation BencodingBlurView

-(void)initializeState
{
 
    //This is alittle hacky but, on init create and add our view
    UIImageView *sq = [self blurView];
    //Set our blur defaults
    _blurLevel = [NSNumber numberWithFloat:5.0f];
    _blurFilter = @"CIGaussianBlur";
    
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

-(void) setBlurFilter_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    _blurFilter =[TiUtils stringValue:value];
}

-(void) setBlurLevel_:(id)value
{
    _blurLevel =[NSNumber numberWithDouble:[TiUtils doubleValue:value def:15.0]];
}

-(UIImage*) doBlurEffect :(UIImage*)theImage
{
    // MODIFIED FROM THIS GREAT BLOG POST BY Evan Davis
    //http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    //SET OF THE FILTER, WE USE A DEFAULT OF CIGaussianBlur YOU CAN CHANGE THIS BY CALLING THE setBlurFilter_ method
    CIFilter *filter = [CIFilter filterWithName:_blurFilter];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    //THE LEVEL OR DISTANCE IS THEN SET YOU CAN OVERRIDE THIS BY CALLING setBlurLevel_
    [filter setValue:_blurLevel forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:cgImage];
}

-(void) setViewToBlur_:(id)viewProxy
{

    ENSURE_SINGLE_ARG(viewProxy, TiViewProxy);
    //CREATE A BLOG IMAGE FROM OUR PROXY
    TiBlob* blobImage = [viewProxy toImage:nil];
    
    //PASS THE IMAGE FROM OUR BLOB INTO OUR EFFECT METHOD
    [self blurView].image = [self doBlurEffect:[blobImage image]];
}

-(void) setImageToBlur_:(id)args
{
    NSURL *url = [TiUtils toURL:args proxy:self.proxy];
    UIImage *theImage = [[ImageLoader sharedLoader] loadImmediateImage:url];
    [self blurView].image = [self doBlurEffect:theImage];
}

@end
