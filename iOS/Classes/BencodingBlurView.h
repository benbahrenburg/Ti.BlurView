/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "BXBImageHelpers.h"
@interface BencodingBlurView : TiUIView {
@private
	UIImageView *_blurView;
    NSNumber * _blurLevel;
    NSString * _blurFilter;
    BOOL _cropToFit;
    BOOL _debug;
    UIColor *_blurTint;
    TiViewProxy *_viewToBlur;
    NSTimer* _blurTimer;
    BXBImageHelpers* _helpers;
}

-(void)clearContents:(id)unused;
-(void)tryRefresh:(id)unused;
-(void)startLiveBlur:(id)args;
-(void)stopLiveBlur:(id)unused;

@end
