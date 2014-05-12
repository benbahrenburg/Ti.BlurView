/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "BencodingBlurModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "ImageLoader.h"
#import "BXBImageHelpers.h"
#import "ImageLoader.h"
#import "TiUIViewProxy.h"
#import "BXBGPUHelpers.h"
@implementation BencodingBlurModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d85a60ff-a204-4a70-b16a-315bd61c7d0d";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"bencoding.blur";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];
}

-(void)shutdown:(id)sender
{
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 


#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

-(NSNumber*) isSupported:(id)unused
{
 
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

    return NUMBOOL(YES);
    
#else
    
    return NUMBOOL(NO);
    
#endif
    
}


-(id) applyGPUBlurTo:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);

    NSString *filterType = kBBIOSBlur;
    UIImage *workingImg = nil;
    BOOL debug = [TiUtils boolValue:@"debug" properties:args def:NO];
    BXBGPUHelpers *filterHelpers = [[BXBGPUHelpers alloc] initWithDetails:debug];
    BXBImageHelpers* helper = [[BXBImageHelpers alloc] init];

    if([args objectForKey:@"image"] !=nil){
        workingImg = [helper convertToUIImage:[args objectForKey:@"image"] withProxy:self];
        if(workingImg==nil){
            NSURL* imageURL = [self sanitizeURL:[args objectForKey:@"image"]];
            if (![imageURL isKindOfClass:[NSURL class]]) {
                [self throwException:@"invalid image type"
                           subreason:[NSString stringWithFormat:@"expected TiBlob, String, TiFile, was: %@",[args class]]
                            location:CODELOCATION];
            }
            if ([imageURL isFileURL]) {
                workingImg = [UIImage imageWithContentsOfFile:[imageURL path]];
                if (workingImg == nil) {
                    workingImg = [[ImageLoader sharedLoader] loadImmediateImage:imageURL];
                }
            }
        }
    }



    if(args!=nil){
        filterType = [TiUtils stringValue:@"type" properties:args def:kBBIOSBlur];
    }

    if([filterType  isEqual: kBBGaussianBlur]){
        if(debug){
            NSLog(@"[DEBUG] GPUBlurImageView: applying GPUImageGaussianBlurFilter");
        }

        workingImg =[[filterHelpers buildGaussianBlur:args] imageByFilteringImage:workingImg];
    }

    if([filterType  isEqual: kBBBoxBlur]){
        if(debug){
            NSLog(@"[DEBUG] GPUBlurImageView: applying GPUImageBoxBlurFilter");
        }

         workingImg =[[filterHelpers buildBoxBlur:args] imageByFilteringImage:workingImg];
    }

    if([filterType  isEqual: kBBIOSBlur]){
        if(debug){
            NSLog(@"[DEBUG] GPUBlurImageView: applying GPUImageiOSBlurFilter");
        }

        workingImg= [[filterHelpers buildIOSBlur:args] imageByFilteringImage:workingImg];
    }


    return workingImg ? [[TiBlob alloc] initWithImage:workingImg] : nil;
    
}

-(id) applyBlurTo:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    NSString *filterName = @"CIGaussianBlur";
    UIImage *workingImg = nil;
    BXBImageHelpers* helper = [[BXBImageHelpers alloc] init];
    
    if([args objectForKey:@"image"] !=nil){
        workingImg = [helper convertToUIImage:[args objectForKey:@"image"] withProxy:self];
        if(workingImg==nil){
            NSURL* imageURL = [self sanitizeURL:[args objectForKey:@"image"]];
            if (![imageURL isKindOfClass:[NSURL class]]) {
                [self throwException:@"invalid image type"
                           subreason:[NSString stringWithFormat:@"expected TiBlob, String, TiFile, was: %@",[args class]]
                            location:CODELOCATION];
            }
            if ([imageURL isFileURL]) {
                workingImg = [UIImage imageWithContentsOfFile:[imageURL path]];
                if (workingImg == nil) {
                    workingImg = [[ImageLoader sharedLoader] loadImmediateImage:imageURL];
                }
            }
        }
    }

    if([args objectForKey:@"view"] !=nil){
        id viewToBlur = [args objectForKey:@"view"];
        ENSURE_TYPE(viewToBlur,TiViewProxy);
        workingImg = [[viewToBlur toImage:nil] image];
    }
    
    if(workingImg==nil){
        NSLog(@"[ERROR] no image or view provided");
        return;
    }
    
    NSNumber *blurLevel = [NSNumber numberWithDouble:
                            [TiUtils doubleValue:@"blurLevel" properties:args def:5]];
    
    UIColor *tintColor = [UIColor clearColor];
    
    if([args objectForKey:@"blurTintColor"] !=nil){
        tintColor = [TiUtils colorValue:@"blurTintColor" properties:args].color;
    }

    if([args objectForKey:@"blurFilter"] !=nil){
        filterName = [TiUtils stringValue:@"blurFilter" properties:args];
    }
    
    id rectValue = [args objectForKey:@"cropToRect"];
    
    if(rectValue!=nil)
    {
        CGRect rect;
        NSDictionary *rectData = (NSDictionary*)rectValue;
        rect.origin.x = [TiUtils intValue:@"x" properties:rectData];
        rect.origin.y = [TiUtils intValue:@"y" properties:rectData];
        rect.size.width = [TiUtils intValue:@"width" properties:rectData];
        rect.size.height = [TiUtils intValue:@"height" properties:rectData];
        workingImg = [helper imageCroppedToRect:rect theImage:workingImg];
    }
    
    //PASS THE IMAGE FROM OUR BLOB INTO OUR EFFECT METHOD
    UIImage *results =[helper applyBlur:workingImg withFilter:filterName withLevel:blurLevel withTint:tintColor];
    return results ? [[TiBlob alloc] initWithImage:results] : nil;
    
}

NSString * const kBBIOSBlur = @"IOS_BLUR";
NSString * const kBBBoxBlur = @"BOX_BLUR";
NSString * const kBBGaussianBlur = @"GAUSSIAN_BLUR";


MAKE_SYSTEM_STR(IOS_BLUR, kBBIOSBlur);
MAKE_SYSTEM_STR(BOX_BLUR, kBBBoxBlur);
MAKE_SYSTEM_STR(GAUSSIAN_BLUR, kBBGaussianBlur);

@end
