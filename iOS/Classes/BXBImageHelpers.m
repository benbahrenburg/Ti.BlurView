/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BXBImageHelpers.h"
#import <CoreImage/CoreImageDefines.h>
#import "ImageLoader.h"


@implementation BXBImageHelpers

-(UIImage*)rotatedImage:(UIImage*)originalImage withProxy:(TiProxy*)proxy
{
    //If autorotate is set to false and the image orientation is not UIImageOrientationUp create new image
    if (![TiUtils boolValue:[proxy valueForUndefinedKey:@"autorotate"] def:YES] && (originalImage.imageOrientation != UIImageOrientationUp)) {
        UIImage* theImage = [UIImage imageWithCGImage:[originalImage CGImage] scale:[originalImage scale] orientation:UIImageOrientationUp];
        return theImage;
    }
    else {
        return originalImage;
    }
}

-(UIImage*)convertToUIImage:(id)arg withProxy:(TiProxy*)proxy
{
    UIImage *image = nil;
    
    if ([arg isKindOfClass:[TiBlob class]]) {
        TiBlob *blob = (TiBlob*)arg;
        image = [blob image];
    }
    else if ([arg isKindOfClass:[TiFile class]]) {
        TiFile *file = (TiFile*)arg;
        NSURL * fileUrl = [NSURL fileURLWithPath:[file path]];
        image = [[ImageLoader sharedLoader] loadImmediateImage:fileUrl];
    }
    else if ([arg isKindOfClass:[UIImage class]]) {
		// called within this class
        image = (UIImage*)arg;
    }
    
    UIImage *imageToUse = [self rotatedImage:image withProxy:proxy];
    
    return imageToUse;
}

- (UIImage *)imageCroppedToRect:(CGRect)rect theImage:(UIImage*)theImage
{
	CGImageRef imageRef = CGImageCreateWithImageInRect([theImage CGImage], rect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return cropped;
}

-(UIImage*) applyBlur :(UIImage*)theImage
               withFilter:(NSString*)blurFilterName
                withLevel:(NSNumber*) blurLevel
                 withTint:(UIColor*)tintColor
{

    CIContext *context   = [CIContext contextWithOptions:nil];
    CIImage *sourceImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    //Create a CIAffineClamp filter to remove the trasparent border around the image
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"
                                      keysAndValues:kCIInputImageKey, sourceImage, nil];
    
    //Create an output CIImage with the results
    CIImage *affineClampOutput = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    //Create a Blur Filter using the filter we pass in
    CIFilter *blurFilter = [CIFilter filterWithName:blurFilterName
                                             keysAndValues:kCIInputImageKey, affineClampOutput,
                            @"inputRadius", blurLevel,nil];
    
    //Convert to a CGImageRef using the fromRect so we can make sure the filter is sized correctly
    CGImageRef cgBlurImage = [context createCGImage:[blurFilter valueForKey:kCIOutputImageKey]
                                       fromRect:[sourceImage extent]];
 
    //Convert from a CGImageRef to a CIImage
    //cOutputImage will be converted to a UIImage at the end of the method
    CIImage *cOutputImage = [CIImage imageWithCGImage:cgBlurImage];
    
    //Do some cleanup
    CGImageRelease(cgBlurImage);
    
    //Check if we need to add a tint filter
    if(tintColor !=[UIColor clearColor]){
   
        //Create a tint filter
        CIFilter *tintFilter = [CIFilter filterWithName:@"CIConstantColorGenerator"
                                          keysAndValues:@"inputColor", [CIColor colorWithCGColor:[tintColor CGColor]],nil];

        CIImage* tintImage = [tintFilter valueForKey:kCIOutputImageKey];
        
        //Apply MultiyCompositing filter, this is needed so we can add the tint filter
        CIFilter *multiCompFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"
                                          keysAndValues:kCIInputImageKey, tintImage,
                             @"inputBackgroundImage",cOutputImage, nil];
        
        //Output the results of everything into the multiOutput CIImage
        CGImageRef cgmultiCompImage = [context createCGImage:[multiCompFilter valueForKey:kCIOutputImageKey]
                                               fromRect:[sourceImage extent]];
        
        //Convert from a CGImageRef to a CIImage
        cOutputImage = [CIImage imageWithCGImage:cgmultiCompImage];
        //Do some cleanup
        CGImageRelease(cgmultiCompImage);
        
    }

    //Convert from a CIImage to a UIImage and sent it out of our method
    return [UIImage  imageWithCIImage:cOutputImage];
}

@end
