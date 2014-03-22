/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurGPUBlurViewProxy.h"
#import "TiUtils.h"

@implementation BencodingBlurGPUBlurViewProxy

-(NSArray *)keySequence
{
    return [NSArray arrayWithObjects:
            @"blurImageWait",
            @"debug",
            @"blur",
            nil];
}

@end
