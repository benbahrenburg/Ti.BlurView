/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"

@interface BencodingBlurView : TiUIView {
@private
	UIImageView *_square;
    NSNumber * _blurLevel;
    NSString * _blurFilter;
    BOOL _cropToFit;
    UIColor *_blurTint;
}

@end
