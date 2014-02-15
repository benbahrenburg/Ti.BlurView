/**
 * benCoding.BlurView
 * Copyright (c) 2013 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiViewProxy.h"

@interface BencodingBlurViewProxy : TiViewProxy {
}

-(void)clearContents:(id)unused;
-(void)tryRefresh:(id)unused;
-(void)startLiveBlur:(id)args;
-(void)stopLiveBlur:(id)unused;
@end
