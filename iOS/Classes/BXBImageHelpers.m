/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BXBImageHelpers.h"
#import <CoreImage/CoreImageDefines.h>

@implementation BXBImageHelpers

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
    
    CIFilter* tintGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* tintColor = [CIColor colorWithCGColor:[color CGColor]];
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

-(UIImage*) doBlurEffect :(UIImage*)theImage withFilter:(NSString*)blurFilter withLevel:(NSNumber*) blurLevel
{
    // MODIFIED FROM THIS GREAT BLOG POST BY Evan Davis
    //http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    //SET OF THE FILTER, WE USE A DEFAULT OF CIGaussianBlur YOU CAN CHANGE THIS BY CALLING THE setBlurFilter_ method
    CIFilter *filter = [CIFilter filterWithName:blurFilter];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    //THE LEVEL OR DISTANCE IS THEN SET YOU CAN OVERRIDE THIS BY CALLING setBlurLevel_
    [filter setValue:blurLevel forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage* results = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return results;
}

-(UIImage*) applyBlur :(UIImage*)theImage
               withFilter:(NSString*)blurFilterName
                withLevel:(NSNumber*) blurLevel
                 withTint:(UIColor*)tintColor
{
    // MODIFIED FROM THIS GREAT BLOG POST BY Evan Davis
    //http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
    return theImage;
#endif
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    //SET OF THE FILTER, WE USE A DEFAULT OF CIGaussianBlur YOU CAN CHANGE THIS BY CALLING THE setBlurFilter_ method
    CIFilter *blurFilter = [CIFilter filterWithName:blurFilterName];
    [blurFilter setValue:inputImage forKey:kCIInputImageKey];
    //THE LEVEL OR DISTANCE IS THEN SET YOU CAN OVERRIDE THIS BY CALLING setBlurLevel_
    [blurFilter setValue:blurLevel forKey:@"inputRadius"];
    CIImage *blurImage = [blurFilter valueForKey:kCIOutputImageKey];
    
    if(tintColor !=[UIColor clearColor]){

        CIFilter* tintFilter = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        CIColor* tintFilterColor = [CIColor colorWithCGColor:[tintColor CGColor]];
        [tintFilter setValue:tintFilterColor forKey:@"inputColor"];
        CIImage* tintImage = [tintFilter valueForKey:kCIOutputImageKey];
        
        //apply a multiply filter
        CIFilter* filterm = [CIFilter filterWithName:@"CIMultiplyCompositing"];
        [filterm setValue:tintImage forKey:kCIInputImageKey];
        
        [filterm setValue:blurImage forKey:@"inputBackgroundImage"];
        blurImage  = [filterm valueForKey:kCIOutputImageKey];
        
    }
    
    CGImageRef cgImage = [context createCGImage:blurImage fromRect:[inputImage extent]];
    UIImage* results = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return results;
}

@end
