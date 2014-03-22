/**
 * benCoding.BlurView
 * Copyright (c) 2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "GPUImageiOSBlurFilter.h"
#import "GPUImageMonochromeFilter.h"
#import "GPUImageFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageBoxBlurFilter.h"

@interface BXBGPUHelpers : NSObject{
@private
    BOOL _debug;
}

-(id)initWithDetails:(BOOL)debug;
-(GPUImageiOSBlurFilter*) buildIOSBlur:(NSDictionary*)options;
-(GPUImageBoxBlurFilter*) buildBoxBlur:(NSDictionary*)options;
-(GPUImageGaussianBlurFilter*) buildGaussianBlur:(NSDictionary*)options;

@end
