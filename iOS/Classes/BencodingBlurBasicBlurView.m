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
    _retries = 1;
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

-(void) setBlurImageRetries_:(id)value
{
    _retries =[TiUtils intValue:value def:1];
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

        [imageView setImage:[filter imageByFilteringImage:imageView.image]];
    }
}

-(void)fireTimeout:(int)tries
{
    if ([self.proxy _hasListeners:@"blurred"]){
        NSDictionary * props = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"success",NUMBOOL(NO),
                                @"message",@"timeout",
                                [NSNumber numberWithInt:tries],@"tries",
                                nil];
        [self.proxy fireEvent:@"blurred" withObject:props];
    }
}

-(void)fireBlurred:(int)tries
{
    if ([self.proxy _hasListeners:@"blurred"]){
        NSDictionary * props = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"success",NUMBOOL(YES),
                                [NSNumber numberWithInt:tries],@"tries",
                                nil];
        [self.proxy fireEvent:@"blurred" withObject:props];
    }
}

-(void)setBlurRadius_:(id)value
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

        __block int retryCount = 0;
        
        while ( retryCount < _retries ) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, _imageWait);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if( imageView.image == nil ){
                    if(retryCount == _retries){
                        [self fireTimeout:retryCount];
                    }
                }else{
                    [self applyBlur:imageView withBlurRadius:blurRadius];
                    [self fireBlurred:retryCount];
                }
                retryCount++;
            });
        }
        
    }else{
        if(_debug){
            NSLog(@"[DEBUG] GPUBlurImageView : Image available, starting");
        }
        [self applyBlur:imageView withBlurRadius:blurRadius];
        [self fireBlurred:0];
    }
}
@end
