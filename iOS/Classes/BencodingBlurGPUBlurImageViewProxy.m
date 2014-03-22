/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurGPUBlurImageViewProxy.h"
#import "TiUtils.h"

@implementation BencodingBlurGPUBlurImageViewProxy

-(NSArray *)keySequence
{
    return [NSArray arrayWithObjects:
            @"image",
            @"blurImageWait",
            @"debug",
            @"blur",
            nil];
}
@end
