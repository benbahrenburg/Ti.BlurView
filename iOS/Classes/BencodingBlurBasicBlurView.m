/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurBasicBlurView.h"
#import "TiUtils.h"
#import "BencodingBlurModule.h"

#import "GPUImageFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageBoxBlurFilter.h"

@implementation BencodingBlurBasicBlurView

-(void)initializeState
{
    _debug = NO;
    _imageWait = 200;
	[super initializeState];
}

-(void) setDebug_:(id)value
{
    _debug =[TiUtils boolValue:value def:YES];
}

-(void) setBlurImageWait_:(id)value
{
    _imageWait =[TiUtils intValue:value def:200];
}

-(void) applyBlur:(UIImageView*) imageView withBlurRadius:(float)blurRadius
{
    if( imageView.image == nil ){
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView : Still no image, giving up");
        }
    }else{

        GPUImageBoxBlurFilter *filter = [[GPUImageBoxBlurFilter alloc] init];
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView: radiusInPixels %f",
                  blurRadius);
        }
        filter.blurRadiusInPixels = blurRadius;

        if([self valueForUndefinedKey:@"radiusAsFractionOfImageWidth"] !=nil){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusAsFractionOfImageWidth %f",
                      [TiUtils floatValue:[self valueForUndefinedKey:@"radiusAsFractionOfImageWidth"]]);
            }
            filter.blurRadiusAsFractionOfImageWidth =
            [TiUtils floatValue:[self valueForUndefinedKey:@"radiusAsFractionOfImageWidth"]];
        }

        if([self valueForUndefinedKey:@"radiusAsFractionOfImageHeight"] !=nil){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusAsFractionOfImageHeight %f",
                      [TiUtils floatValue:[self valueForUndefinedKey:@"radiusAsFractionOfImageHeight"]]);
            }
            filter.blurRadiusAsFractionOfImageHeight =
            [TiUtils floatValue:[self valueForUndefinedKey:@"radiusAsFractionOfImageHeight"]];
        }

        if([self valueForUndefinedKey:@"blurPasses"] !=nil){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: blurPasses %f",
                      [TiUtils floatValue:[self valueForUndefinedKey:@"blurPasses"]]);
            }
            filter.blurPasses =
            [TiUtils floatValue:[self valueForUndefinedKey:@"blurPasses"]];
        }

        [imageView setImage:[filter imageByFilteringImage:imageView.image]];
    }
}

-(void)setBlurRadius:(id)value
{

    float blurRadius = [TiUtils floatValue:value def:5];

    if(_debug){
        NSLog(@"[DEBUG] GPUBlurImageView : Finding imageView");
    }

    UIImageView *imageView = [self valueForKey:@"imageView"];

    if(imageView==nil){
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView : Not found, giving up");
        }
        return;
    }
    if( imageView.image == nil ){
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView : No image yet, queued");
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, _imageWait);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self applyBlur:imageView withBlurRadius:blurRadius];
        });
    }else{
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView : Image available, starting");
        }
        [self applyBlur:imageView withBlurRadius:blurRadius];
    }
}



@end
