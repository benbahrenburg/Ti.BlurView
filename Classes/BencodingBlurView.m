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
    _blurLevel =[NSNumber numberWithDouble:[TiUtils doubleValue:value def:15.0]];
}

- (UIImage *)imageCroppedToRect:(CGRect)rect theImage:(UIImage*)theImage
{
	CGImageRef imageRef = CGImageCreateWithImageInRect([theImage CGImage], rect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return cropped;
}

-(UIImage*)addTint:(UIImage*)theImage withColor:(UIColor*) color
{
    CIImage *beginImage = [CIImage imageWithCGImage:theImage.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //create some blue
    CIFilter* tintGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* tintColor = [CIColor colorWithCGColor:[color CGColor]];
    //CIColor* blue = [CIColor colorWithString:@"0.1 0.5 0.8 1.0"];
    [tintGenerator setValue:tintColor forKey:@"inputColor"];
    CIImage* tintImage = [tintGenerator valueForKey:@"outputImage"];
    
    //apply a multiply filter
    CIFilter* filterm = [CIFilter filterWithName:@"CIMultiplyCompositing"];
    [filterm setValue:tintImage forKey:kCIInputImageKey];
    
    [filterm setValue:beginImage forKey:@"inputBackgroundImage"];
    CIImage *result  = [filterm valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[beginImage extent]];
    UIImage* results = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return results;
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
    UIImage* results = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return results;
}

-(void) setViewToBlur_:(id)viewProxy
{

    ENSURE_SINGLE_ARG(viewProxy, TiViewProxy);
    //CREATE A BLOG IMAGE FROM OUR PROXY
    TiBlob* blobImage = [viewProxy toImage:nil];
    
    //GET THE UIIMAGE FROM THE BLOB, WE'LL BE WORKING WITH THIS FOR AWHILE
    UIImage* workingImg = [blobImage image];
 
    // BE SMART ABOUT THIS AND ONLY TRY TO BLUR IF SUPPORTED
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    
    //CHECK IF WE NEED TO CROP TO THE VIEW'S FRAME
    if(_cropToFit ==YES){
        workingImg = [self imageCroppedToRect:[self frame] theImage:workingImg];
    }
    
    //CHECK IF A CUSTOM TINT HAS BEEN APPLIED
    if(_blurTint !=[UIColor clearColor]){
        workingImg  = [self addTint:workingImg withColor:_blurTint];
    }

    #endif
    
    //PASS THE IMAGE FROM OUR BLOB INTO OUR EFFECT METHOD
    [self blurView].image = [self doBlurEffect:workingImg];
    
}

-(void) setImageToBlur_:(id)args
{
    //LOAD THE IMAGE
    NSURL *url = [TiUtils toURL:args proxy:self.proxy];
    //HANG FETCH THE IMAGE AND HANDL ONTO IT WHILE WE WORK
    UIImage *workingImg = [[ImageLoader sharedLoader] loadImmediateImage:url];

    // BE SMART ABOUT THIS AND ONLY TRY TO BLUR IF SUPPORTED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    
    //CHECK IF WE NEED TO CROP TO THE VIEW'S FRAME
    if(_cropToFit ==YES){
        workingImg = [self imageCroppedToRect:[self frame] theImage:workingImg];
    }
    
    //CHECK IF A CUSTOM TINT HAS BEEN APPLIED
    if(_blurTint !=[UIColor clearColor]){
        workingImg  = [self addTint:workingImg withColor:_blurTint];
    }

#endif
    
    //PASS THE IMAGE FROM OUR BLOB INTO OUR EFFECT METHOD
    [self blurView].image = [self doBlurEffect:workingImg];
}

@end
