/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
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

-(id) applyBlurTo:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    NSString *filterName = @"CIGaussianBlur";
    UIImage *workingImg = nil;
    
    if([args objectForKey:@"imageToBlur"] !=nil){
        NSString *imgUrl = [TiUtils stringValue:@"imageToBlur" properties:args];
        NSURL *url = [TiUtils toURL:imgUrl proxy:self];
        workingImg = [[ImageLoader sharedLoader] loadImmediateImage:url];
    }

    if([args objectForKey:@"blobToBlur"] !=nil){
        id blob = [args objectForKey:@"blobToBlur"];
        ENSURE_TYPE(blob,TiBlob);
        workingImg = [(TiBlob*)blob image];
    }

    if([args objectForKey:@"viewToBlur"] !=nil){
        id viewToBlur = [args objectForKey:@"viewToBlur"];
        ENSURE_TYPE(viewToBlur,TiViewProxy);
        TiBlob* blobImage = [viewToBlur toImage:nil];
        workingImg = [blobImage image];
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
    
    BXBImageHelpers* helper = [[BXBImageHelpers alloc] init];
    
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
@end
