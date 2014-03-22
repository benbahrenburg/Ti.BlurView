/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BXBGPUHelpers.h"
#import "TiUtils.h"
@implementation BXBGPUHelpers

-(id)initWithDetails:(BOOL)debug
{
    if (self = [super init]) {
        _debug = debug;
    }
    return self;
}

-(GPUImageiOSBlurFilter*) buildIOSBlur:(NSDictionary*)options
{

    GPUImageiOSBlurFilter *filter = [[GPUImageiOSBlurFilter alloc] init];

    if(options!=nil){
        if([options valueForKey:@"radiusInPixels"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusInPixels %f",
                      [TiUtils floatValue:@"radiusInPixels" properties:options]);
            }
            filter.blurRadiusInPixels = [TiUtils floatValue:@"radiusInPixels" properties:options];
        }
        if([options valueForKey:@"saturation"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: saturation %f",
                      [TiUtils floatValue:@"saturation" properties:options]);
            }
            filter.saturation = [TiUtils floatValue:@"saturation" properties:options];
        }
        if([options valueForKey:@"downsampling"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: downsampling %f",
                      [TiUtils floatValue:@"downsampling" properties:options]);
            }
            filter.downsampling = [TiUtils floatValue:@"downsampling" properties:options];
        }
    }

    return filter;

}


-(GPUImageBoxBlurFilter*) buildBoxBlur:(NSDictionary*)options
{

    GPUImageBoxBlurFilter *filter = [[GPUImageBoxBlurFilter alloc] init];

    if(options!=nil){
        if([options valueForKey:@"radiusInPixels"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusInPixels %f",
                      [TiUtils floatValue:@"radiusInPixels" properties:options]);
            }
            filter.blurRadiusInPixels = [TiUtils floatValue:@"radiusInPixels" properties:options];
        }
        if([options valueForKey:@"radiusAsFractionOfImageWidth"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusAsFractionOfImageWidth %f",
                      [TiUtils floatValue:@"radiusAsFractionOfImageWidth" properties:options]);
            }
            filter.blurRadiusAsFractionOfImageWidth =
            [TiUtils floatValue:@"radiusAsFractionOfImageWidth" properties:options];
        }
        if([options valueForKey:@"radiusAsFractionOfImageHeight"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusAsFractionOfImageHeight %f",
                      [TiUtils floatValue:@"radiusAsFractionOfImageHeight" properties:options]);
            }
            filter.blurRadiusAsFractionOfImageHeight =
            [TiUtils floatValue:@"radiusAsFractionOfImageHeight" properties:options];
        }
        if([options valueForKey:@"passes"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: passes %f",
                      [TiUtils floatValue:@"passes" properties:options]);
            }
            filter.blurPasses = [TiUtils floatValue:@"passes" properties:options];
        }
    }

    return filter;
}

-(GPUImageGaussianBlurFilter*) buildGaussianBlur:(NSDictionary*)options
{

    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];

    if(options!=nil){
        if([options valueForKey:@"radiusInPixels"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusInPixels %f",
                      [TiUtils floatValue:@"radiusInPixels" properties:options]);
            }
            filter.blurRadiusInPixels = [TiUtils floatValue:@"radiusInPixels" properties:options];
        }
        if([options valueForKey:@"radiusAsFractionOfImageWidth"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusAsFractionOfImageWidth %f",
                      [TiUtils floatValue:@"radiusAsFractionOfImageWidth" properties:options]);
            }
            filter.blurRadiusAsFractionOfImageWidth =
            [TiUtils floatValue:@"radiusAsFractionOfImageWidth" properties:options];
        }
        if([options valueForKey:@"radiusAsFractionOfImageHeight"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: radiusAsFractionOfImageHeight %f",
                      [TiUtils floatValue:@"radiusAsFractionOfImageHeight" properties:options]);
            }
            filter.blurRadiusAsFractionOfImageHeight =
            [TiUtils floatValue:@"radiusAsFractionOfImageHeight" properties:options];
        }
        if([options valueForKey:@"passes"]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: passes %f",
                      [TiUtils floatValue:@"passes" properties:options]);
            }
            filter.blurPasses = [TiUtils floatValue:@"passes" properties:options];
        }
    }
    
    return filter;
}

@end
