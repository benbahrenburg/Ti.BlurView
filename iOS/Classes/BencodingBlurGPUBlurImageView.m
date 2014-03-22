/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurGPUBlurImageView.h"
#import "TiUtils.h"
#import "BencodingBlurModule.h"
#import "BXBGPUHelpers.h"
@implementation BencodingBlurGPUBlurImageView

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

-(void) applyBlur:(UIImageView*) imageView withOptions:(NSDictionary*)options
{
    if( imageView.image == nil ){
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView : Still no image, giving up");
        }
    }else{

        NSString *filterType = kBBIOSBlur;
        BXBGPUHelpers *filterHelpers = [[BXBGPUHelpers alloc] initWithDetails:_debug];

        if(options!=nil){
            filterType = [TiUtils stringValue:@"type" properties:options def:kBBIOSBlur];
        }

        if([filterType  isEqual: kBBGaussianBlur]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: applying GPUImageGaussianBlurFilter");
            }

            [imageView setImage:[[filterHelpers buildGaussianBlur:options] imageByFilteringImage:imageView.image]];
        }

        if([filterType  isEqual: kBBBoxBlur]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: applying GPUImageBoxBlurFilter");
            }

            [imageView setImage:[[filterHelpers buildBoxBlur:options] imageByFilteringImage:imageView.image]];
        }
        
        if([filterType  isEqual: kBBIOSBlur]){
            if(_debug){
                NSLog(@"[DEBUG] GPUBlurImageView: applying GPUImageiOSBlurFilter");
            }

            [imageView setImage:[[filterHelpers buildIOSBlur:options] imageByFilteringImage:imageView.image]];
        }
    }
}

-(void)setBlur_:(id)args
{

    ENSURE_TYPE_OR_NIL(args, NSDictionary);

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
            [self applyBlur:imageView withOptions:args];
        });
    }else{
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView : Image available, starting");
        }
        [self applyBlur:imageView withOptions:args];
    }
}

@end
