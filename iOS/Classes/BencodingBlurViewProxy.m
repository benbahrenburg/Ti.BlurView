/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurViewProxy.h"
#import "TiUtils.h"
#import "BencodingBlurView.h"
@implementation BencodingBlurViewProxy

-(NSArray *)keySequence
{
    return [NSArray arrayWithObjects:
            @"debug",
            @"blurLevel",
            @"blurCroppedToRect",
            @"blurTintColor",
            @"blurFilter",
            @"backgroundView",
            @"image",
            nil];
}

-(void)tryRefresh:(id)unused
{
  	if ([self viewAttached])
	{
		TiThreadPerformOnMainThread(^{[(BencodingBlurView*)[self view] tryRefresh:unused];}, NO);
	}
}

-(void)clearContents:(id)unused
{
  	if ([self viewAttached])
	{
		TiThreadPerformOnMainThread(^{[(BencodingBlurView*)[self view] clearContents:unused];}, NO);
	}
}

-(void)setImage:(id)newImage
{
    id image = newImage;
    if ([image isEqual:@""])
    {
        image = nil;
    }
    [self replaceValue:image forKey:@"image" notification:YES];
}

-(void)startLiveBlur:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary)
  	if ([self viewAttached])
	{
		TiThreadPerformOnMainThread(^{[(BencodingBlurView*)[self view] startLiveBlur:args];}, NO);
	}
}

-(void)stopLiveBlur:(id)unused
{
  	if ([self viewAttached])
	{
		TiThreadPerformOnMainThread(^{[(BencodingBlurView*)[self view] stopLiveBlur:unused];}, NO);
	}
}

@end
