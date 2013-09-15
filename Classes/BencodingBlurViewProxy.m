/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingBlurViewProxy.h"
#import "TiUtils.h"

@implementation BencodingBlurViewProxy

-(NSArray *)keySequence
{
    return [NSArray arrayWithObjects:
            @"blurLevel",
            @"blurCroppedToRect",
            @"blurTintColor",
            @"viewToBlur",
            @"imageToBlur",
            nil];
}
@end
