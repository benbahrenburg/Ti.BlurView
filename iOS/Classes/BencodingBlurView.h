/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
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
    BXBImageHelpers* _helpers;
    BOOL _debug;
    TiViewProxy *_viewToBlur;
    float _onPresentDelay;
    BOOL _cropToFit;
    UIColor *_blurTint;
    BOOL _rebindOnPresent;
    BOOL _rebindOnResize;
    BOOL _stopViewRebind;
    BOOL _rendered;
}

-(void)clearContents:(id)unused;
-(void)tryRefresh:(id)unused;

@end
