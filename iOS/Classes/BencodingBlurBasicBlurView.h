/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "TiUIImageView.h"

@interface BencodingBlurBasicBlurView : TiUIImageView {
@private
    BOOL _debug;
    int _imageWait;
    int _retries;
}


@end
